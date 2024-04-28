require('Utilities')

function isValidMove(result)
	for _, unit in pairs(result.ActualArmies.SpecialUnits) do -- checking to see if an attack had a special unit
        if isSpecialUnit(unit) then
			local u = getUnitData(unit)
			if u.slow > 0 then
				return false
			end
		end
	end
	return true
end

local function levelUpUnitName(builder, level)
    local prefix = LEVEL_TAG .. level .. " "
    if not builder.Name:find("^" .. LEVEL_TAG) then
        builder.Name = prefix .. builder.Name
    else
        builder.Name = prefix .. builder.Name:match("^" .. LEVEL_TAG .. "%d+ (.+)$")
    end
end

local function createUnitOrder(builder, unit, territoryID, playerID, addNewOrder, message)
    local modification = WL.TerritoryModification.Create(territoryID)
    modification.AddSpecialUnits = {builder.Build()}
    modification.RemoveSpecialUnitsOpt = {unit.ID}

    addNewOrder(WL.GameOrderEvent.Create(playerID, message, nil, {modification}))
end

local function levelUpUnitStats(builder, u)
    local damageAbsorbed = (u.power + u.defense) / 2

    u.level = u.level + 1
    u.xp = 0
    u.xpThreshold = u.xpThreshold + (u.xpThreshold / u.level)

    builder.AttackPower = builder.AttackPower + (builder.AttackPower / u.level)
    builder.DefensePower = builder.DefensePower + (builder.DefensePower / u.level)
    builder.DamageToKill = builder.DamageToKill + (damageAbsorbed / u.level)
    builder.DamageAbsorbedWhenAttacked = builder.DamageAbsorbedWhenAttacked + (damageAbsorbed / u.level)

    levelUpUnitName(builder, u.level)
    return builder
end

local function levelUp(unit, territoryID, xpGained, playerID, addNewOrder)
	local u = getUnitData(unit)

    printDebug(string.format("Unit gaining XP -> xp: %d, xpThreshold: %d, xpGained: %d", u.xp, u.xpThreshold, xpGained))
    u.xp = u.xp + xpGained
	local builder = WL.CustomSpecialUnitBuilder.CreateCopy(unit)
	local message = ""

    if u.xp >= u.xpThreshold then
		levelUpUnitStats(builder, u)
        message = unit.TextOverHeadOpt .. ' the ' .. builder.Name .. ' has leveled up!'
    else
        message = unit.TextOverHeadOpt .. ' the ' .. builder.Name .. ' gained ' .. xpGained ..' XP: ' .. u.xp .. '/' .. u.xpThreshold .. ' to next level' 
    end

	builder.ModData = constructUnitData({
		expiryTurn = u.expiryTurn,
		transfer = u.transfer,
		xpThreshold = u.xpThreshold,
		xp = u.xp,
		power = u.power,
		level = u.level,
		defense = u.defense,
		slow = u.slow,
		assass = u.assass
	})

    createUnitOrder(builder, unit, territoryID, playerID, addNewOrder, message)
end

local function handleLevelUps(order, targetTerritory, result, addNewOrder)
    for _, unit in pairs(result.ActualArmies.SpecialUnits) do -- handle attacking troops
        if isSpecialUnit(unit) then
			local u = getUnitData(unit)

			if (result.DefendingArmiesKilled.DefensePower > 0 and u.xpThreshold ~= 0) and
			not any(result.AttackingArmiesKilled.SpecialUnits, function(v) return v.ID == unit.ID end) then
				local xpGained = result.DefendingArmiesKilled.DefensePower or 0
				local territoryID = (result.IsSuccessful and order.To) or order.From

				levelUp(unit, territoryID, xpGained, order.PlayerID, addNewOrder)
			end
		end
	end

    local defendingSpecialUnits = targetTerritory.NumArmies.SpecialUnits or {}
	if (#defendingSpecialUnits > 0 and not result.IsSuccessful) then -- handle defending troops
		for _, unit in pairs(defendingSpecialUnits) do
			if isSpecialUnit(unit) then
				local u = getUnitData(unit)

				if (result.AttackingArmiesKilled.AttackPower > 0 and u.xpThreshold ~= 0) and
				not any(result.DefendingArmiesKilled.SpecialUnits, function(v) return v.ID == unit.ID end) then
					local xpGained = result.AttackingArmiesKilled.AttackPower or 0
					local territoryID = order.From

					levelUp(unit, territoryID, xpGained, targetTerritory.OwnerPlayerID, addNewOrder)
				end
			end
		end
    end
end

local function createDeathMessage(unit, land, isNeutral, newOwner)
    local unitName = unit.TextOverHeadOpt or unit.Name
    -- local ownerName = isNeutral and 'Neutral' or game.Game.Players[land.OwnerPlayerID].DisplayName(nil, false)
	local ownerName = "placeholder" -- TODO
    local message = ownerName .. ":\n" .. unitName .. " has perished in battle."

    if newOwner then
        message = unitName .. " has been transferred to " .. newOwner .. "."
    end
    return message
end

local function handleDeath(unit, result, land, attackFailed, addNewOrder, attackOrder, order)
    local isNeutral = land.IsNeutral
	local u = getUnitData(unit)
    local targetPlayerID = land.OwnerPlayerID

	local isTransferable = u.transfer > 0
	local isFailedAttackOnPlayer = attackOrder and targetPlayerID ~= 0 and not attackFailed
    if isTransferable and (isFailedAttackOnPlayer or not attackOrder) then -- transfer unit
		printDebug("transfer unit")
		u.transfer = u.transfer - 1

        local builder = WL.CustomSpecialUnitBuilder.CreateCopy(unit)
        builder.OwnerID = targetPlayerID
        builder.ModData = updateUnitData(unit, {transfer=u.transfer})
		local modification = WL.TerritoryModification.Create(land)
        modification.AddSpecialUnits = {builder.Build()}

        local message = createDeathMessage(unit, land, isNeutral, game.Game.Players[targetPlayerID].DisplayName(nil, false))
        addNewOrder(WL.GameOrderEvent.Create(targetPlayerID, message, nil, {modification}))
    else -- kill unit
		printDebug("kill unit")
        local message = createDeathMessage(unit, land, isNeutral)
        addNewOrder(WL.GameOrderEvent.Create(unit.OwnerID, message, nil, {}))
    end
end

local function handleDeaths(game, order, result, addNewOrder)
    -- Process deaths from attacking
    local landTo = game.ServerGame.LatestTurnStanding.Territories[order.To]
    for _, unit in ipairs(result.AttackingArmiesKilled.SpecialUnits) do
        if isSpecialUnit(unit) then
            handleDeath(unit, result, landTo, not result.IsSuccessful, addNewOrder, true, order)
        end
    end

    -- Process deaths from defending
    local landFrom = game.ServerGame.LatestTurnStanding.Territories[order.From]
    for _, unit in ipairs(result.DefendingArmiesKilled.SpecialUnits) do
        if isSpecialUnit(unit) then
            handleDeath(unit, result, landFrom, result.IsSuccessful, addNewOrder, false, order)
        end
    end
end

local function processAttackTransfer(game, order, result, skipThisOrder, addNewOrder)
    if game.Game.TurnNumber % 2 ~= 0 then
        local validMove = isValidMove(result)
        if not validMove then
            local skipMessage = 'Move order for this unit was skipped: unit can only move on even turns'
            addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, skipMessage, {}, {}))
            skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
			return
        end
    end

	handleLevelUps(order, game.ServerGame.LatestTurnStanding.Territories[order.To], result, addNewOrder)
	handleDeaths(game, order, result, addNewOrder)
end

------------purchase functions----------------------------

local function extractUnitMetaData(payload)
	local payloadSplit = split(string.sub(payload, 7), ';;')
	return {
		targetTerritoryID = tonumber(payloadSplit[1]),
		type = tonumber(payloadSplit[2]),
		unitPower = tonumber(payloadSplit[3]),
		typeName = payloadSplit[4],
		unitMax = tonumber(payloadSplit[5]),
		image = getImageFile(tonumber(payloadSplit[6])),
		shared = payloadSplit[7] == 'true',
		visible = payloadSplit[8] == 'true',
		characterName = payloadSplit[9]
	}
end

-- Count units of a specific type
local function numUnitsIn(armies, typeName, type)
    local ret = 0
    for _, su in pairs(armies.SpecialUnits) do
        if su.proxyType == 'CustomSpecialUnit' then -- Only consider custom units
            local compare = su.Name

            -- Adjust for unit levels, if applicable
            if (Mod.Settings.Unitdata[type].Level or 0) > 0 then
                local stringSkip = #su.Name - #typeName
                compare = su.Name:sub(stringSkip + 1)
            end

            -- Count units matching the criteria
            if compare == typeName and startsWith(su.ModData, modSign(0)) then
                ret = ret + 1
            end
        end
    end
    return ret
end

local function ensureTableExists(table, key, defaultValue)
    if not table[key] then
        table[key] = defaultValue or {}
    end
end

local function initPublicData(unitType, playerID)
    local publicData = Mod.PublicGameData
    
    ensureTableExists(publicData, unitType)
    ensureTableExists(publicData[unitType], playerID)
    ensureTableExists(publicData[unitType][playerID], 'CurrEver', 0)
    ensureTableExists(publicData[unitType][playerID], 'cooldowntimer', 0)
    ensureTableExists(publicData[unitType], 'CurrEver', 0)

	return publicData
end

local function updatePublicData(unitType, playerID, maxUnitsEver, game)
    local publicData = initPublicData(unitType, playerID)
    if maxUnitsEver > 0 then
        publicData[unitType][playerID].CurrEver = (publicData[unitType][playerID].CurrEver or 0) + 1
    end
    if Mod.Settings.Unitdata[unitType].Cooldown ~= 0 then
        publicData[unitType][playerID].cooldowntimer = game.Game.TurnNumber + Mod.Settings.Unitdata[unitType].Cooldown
    end
    Mod.PublicGameData = publicData
end

local function prePurchaseChecks(game, order, unit, maxUnitsEver)
    -- Check if the territory is controlled by the player issuing the order
    local targetTerritory = game.ServerGame.LatestTurnStanding.Territories[unit.targetTerritoryID]
    if not targetTerritory or targetTerritory.OwnerPlayerID ~= order.PlayerID then
        return false, "You do not control the target territory." -- Territory not controlled by the player
    end

	-- Count units of each type
	local numUnitsAlreadyHave = 0;
	for _, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		if(unit.shared == true )then
			numUnitsAlreadyHave = numUnitsAlreadyHave + numUnitsIn(territory.NumArmies, unit.typeName, unit.type);
		elseif(territory.OwnerPlayerID == order.PlayerID) then
			numUnitsAlreadyHave = numUnitsAlreadyHave + numUnitsIn(territory.NumArmies, unit.typeName, unit.type);				
		end
	end

	local publicData = initPublicData(unit.type, order.PlayerID)

	-- Check for the maximum units limit for the player and overall in the game
	if unit.unitMax > 0 and numUnitsAlreadyHave >= unit.unitMax then
		return false, string.format('Skipping %s purchase. A player can only control %d units of this type, and you currently control %d.', unit.typeName, unit.unitMax, numUnitsAlreadyHave)
	elseif not unit.shared and publicData[unit.type][order.PlayerID].CurrEver >= maxUnitsEver and maxUnitsEver ~= -1 then
		return false, string.format('Skipping %s purchase. A player can only purchase %d units of this type in one game, this limit has been reached.', unit.typeName, maxUnitsEver)
	elseif unit.shared and publicData[unit.type].CurrEver >= maxUnitsEver and maxUnitsEver ~= -1 then
		return false, string.format('Skipping %s purchase. Only %d units of this type can be purchased in the game across all players, this limit has been reached.', unit.typeName, maxUnitsEver)
	end

	if (order.CostOpt == nil) then
		return false, "CostOpt is null; please contact the mod developer (Yamada)"; --shouldn't ever happen, unless another mod interferes
	end
    
    return true
end

local function generateExpiryTurn(minExpiry, maxExpiry, currentTurn)
    if minExpiry == nil or maxExpiry == nil or minExpiry == 0 or maxExpiry == 0 then
        return 0, "" -- Unit does not have a life expectancy
    end
	local turn = math.random(minExpiry, maxExpiry) + currentTurn
    return turn, '\nUnit dies on turn: ' .. turn
end

local function buildAndAddUnit(order, unit, game, addNewOrder)
    local expiryTurn, additionalMessages = generateExpiryTurn(
        Mod.Settings.Unitdata[unit.type].Minlife, Mod.Settings.Unitdata[unit.type].Maxlife, game.Game.TurnNumber
    )
    if Mod.Settings.Unitdata[unit.type].AttackMax then
        additionalMessages = additionalMessages .. '\nAttack power: ' .. unit.unitPower
    end

	local defense = Mod.Settings.Unitdata[unit.type].Defend or 0
    local damageAbsorbed = (unit.unitPower + defense / 2) / 2

    if Mod.Settings.Unitdata[unit.type].Level > 0 then
        unit.typeName = LEVEL_TAG .. '0 ' .. unit.typeName
    end

	local attributes = {
        name = unit.typeName,
        image = unit.image,
        attackPower = unit.unitPower,
        defensePower = defense or 0,
        combatOrder = Mod.Settings.Unitdata[unit.type].CombatOrder == 1 and AFTER_ARMIES_PRIORITY or BEFORE_ARMIES_PRIORITY,
        damageToKill = damageAbsorbed,
        damageAbsorbed = damageAbsorbed,
        textOverHeadOpt = unit.characterName,
        isVisible = unit.visible,
        modData = constructUnitData({
            expiryTurn = expiryTurn,
            transfer = Mod.Settings.Unitdata[unit.type].Transfer or 0,
            xpThreshold = Mod.Settings.Unitdata[unit.type].Level or 0,
            power = unit.unitPower,
            defense = damageAbsorbed or 0,
            slow = Mod.Settings.Unitdata[unit.type].Altmoves or 0,
            assass = Mod.Settings.Unitdata[unit.type].Assassination or 0,
        })
    }
    local builder = buildCustomUnit(order.PlayerID, attributes)
    local modification = WL.TerritoryModification.Create(unit.targetTerritoryID)

    modification.AddSpecialUnits = {builder.Build()}
    addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a ' .. unit.typeName .. additionalMessages, nil, {modification}))
end

local function processPurchase(game, order, addNewOrder)
    local unit = extractUnitMetaData(order.Payload)

	local max = Mod.Settings.Unitdata[unit.type].MaxServer
	local maxUnitsEver = (max ~= true and max ~= false and max ~= 0) and max or -1

    local validPurchase, invalidationMessage = prePurchaseChecks(game, order, unit, maxUnitsEver)
    if not validPurchase then
        addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, invalidationMessage))
		return
    end

	buildAndAddUnit(order, unit, game, addNewOrder)
	updatePublicData(unit.type, order.PlayerID, maxUnitsEver, game)
end

-----------------final functions---------------------
function Server_AdvanceTurn_Start(game, addNewOrder)
	for _, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		for _, unit in pairs (territory.NumArmies.SpecialUnits) do
			if isSpecialUnit(unit) then
				u = getUnitData(unit)
				if u.expiryTurn ~= 0 and u.expiryTurn <= game.Game.TurnNumber then
					local message = unit.TextOverHeadOpt .. ' the ' .. unit.Name .. ' has died of natural causes'
					local modification = WL.TerritoryModification.Create(territory.ID)
					modification.RemoveSpecialUnitsOpt = {unit.ID}
					addNewOrder(WL.GameOrderEvent.Create(unit.OwnerID, message, nil, {modification}));
				end
			end
		end
	end
end

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
    if order.proxyType == "GameOrderAttackTransfer" and result.IsAttack then
        processAttackTransfer(game, order, result, skipThisOrder, addNewOrder)
    elseif order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, modSign(0)) then
        processPurchase(game, order, addNewOrder)
    end
end

-- function Server_AdvanceTurn_End(game, addNewOrder)
-- 	for _, territories in pairs(game.ServerGame.LatestTurnStanding.Territories) do
-- 		for i, unit in pairs (territories.NumArmies.SpecialUnits)do -- search all Territories and see if it has a speical unit
-- 			if unit.proxyType == "CustomSpecialUnit" and unit.ModData and startsWith(unit.ModData, modSign(0)) then
-- 				local payloadSplit = split(string.sub(unit.ModData, 5), ';;'); 
-- 				local mod = WL.TerritoryModification.Create(territories.ID)
-- 				if unit.OwnerID ~= territories.OwnerPlayerID then -- making sure every unit transfer properly
-- 					local builder = WL.CustomSpecialUnitBuilder.CreateCopy(unit)
-- 					builder.OwnerID = territories.OwnerPlayerID
-- 					mod.AddSpecialUnits = {builder.Build()}
-- 					mod.RemoveSpecialUnitsOpt = {unit.ID}
-- 					local UnitdiedMessage = "Chaning to proper Owner of SU"
-- 					addNewOrder(WL.GameOrderEvent.Create(unit.OwnerID, UnitdiedMessage, nil, {mod}));
-- 				end
-- 			end
-- 		end
-- 	end
-- end
