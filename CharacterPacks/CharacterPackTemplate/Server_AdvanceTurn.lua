require('Utilities')

-------------shared utility functions------------------

local function constructModData(params)
    return modSign(0) .. table.concat({
        tostring(params.unitExpiryTurn),
        tostring(params.transfer),
        tostring(params.levelAmount),
        "0", -- Initial XP is always 0
        tostring(params.unitPower),
        "0", -- Starting level is always 0
        tostring(params.defense),
        tostring(params.altMove or 0), -- Convert boolean to 1 or 0
        tostring(params.assass or 0) -- Same here
    }, ';;')
end

-------------attack/transfer functions------------------

local function isSpecialUnit(unit)
    return unit.proxyType == "CustomSpecialUnit" and unit.ModData and startsWith(unit.ModData, modSign(0))
end

local function isValidMove(result)
	for _, unit in pairs(result.ActualArmies.SpecialUnits) do -- checking to see if an attack had a special unit
        if isSpecialUnit(unit) then
			local payloadSplit = split(string.sub(unit.ModData, 5), ';;'); 
			local isSlowUnit = tonumber(payloadSplit[8]) or 0
			if (isSlowUnit > 0) then
				return false
			end
		end
	end
	return true
end

local function updateUnit(game, unit, currentXP, currentLevel, levelUpMessage, territoryID, orderPlayerID, addNewOrder)
    local modData = constructModDataFromUnit(unit, currentXP, currentLevel)  -- Assumes existence of this function
    local builder = WL.CustomSpecialUnitBuilder.CreateCopy(unit)
    builder.ModData = modData

    local terrMod = WL.TerritoryModification.Create(territoryID)
    terrMod.AddSpecialUnits = {builder.Build()}
    terrMod.RemoveSpecialUnitsOpt = {unit.ID}

    addNewOrder(WL.GameOrderEvent.Create(orderPlayerID, levelUpMessage, nil, {terrMod}))
end

local function levelUp(unit, territoryID, xpGained, playerID, addNewOrder)
    print("Unit ModData:", unit.ModData) -- To see the initial ModData
    local payload = split(string.sub(unit.ModData, 5), ';;')
    local xpLvlUpThreshold = tonumber(payload[3]) or 0
    local currentXP = tonumber(payload[4]) or 0
    local unitPower = tonumber(payload[5]) or 0
    local lvl = tonumber(payload[6]) or 0
    local defense = tonumber(payload[7]) or 0
    local absorbedDamage = (unitPower + defense) / 2

    print(string.format("Before adding XP -> currentXP: %d, xpLvlUpThreshold: %d, xpGained: %d", currentXP, xpLvlUpThreshold, xpGained))
    currentXP = currentXP + xpGained
    print(string.format("After adding XP -> currentXP: %d, xpLvlUpThreshold for lvlUp: %d", currentXP, xpLvlUpThreshold))

	local builder = WL.CustomSpecialUnitBuilder.CreateCopy(unit)
	local lvlUpMessage = ""

    if currentXP >= xpLvlUpThreshold then
        print("Leveling up...")
        currentXP = 0
        lvl = lvl + 1
        xpLvlUpThreshold = xpLvlUpThreshold + (xpLvlUpThreshold / lvl)  -- Recalculate level-up XP for the next level
        -- Updating builder stats
		builder.AttackPower = builder.AttackPower + (builder.AttackPower / lvl)
		builder.DefensePower = builder.DefensePower + (builder.DefensePower / lvl)
		builder.DamageToKill = builder.DamageToKill + (absorbedDamage / lvl)
		builder.DamageAbsorbedWhenAttacked = builder.DamageAbsorbedWhenAttacked + (absorbedDamage / lvl)
        print(string.format("New Level: %d, New xpLvlUpThreshold: %d", lvl, xpLvlUpThreshold))
        builder.Name = "LV" .. lvl .. ' ' .. unit.Name:sub(payload[6]:len() + 4)
        lvlUpMessage = unit.TextOverHeadOpt .. ' the ' .. builder.Name .. ' has leveled up!'
    else
        print("Gained XP, but not enough to level up.")
        lvlUpMessage = unit.TextOverHeadOpt .. ' the ' .. builder.Name .. ' gained ' .. xpGained ..' XP: ' .. currentXP .. '/' .. xpLvlUpThreshold .. ' to next level' 
    end

	builder.ModData = modData(0) .. table.concat({payload[1], payload[2], xpLvlUpThreshold, currentXP, unitPower, lvl, defense, payload[8], payload[9]}, ';;')

	local terrMod = WL.TerritoryModification.Create(territoryID)
	terrMod.AddSpecialUnits = {builder.Build()}
	terrMod.RemoveSpecialUnitsOpt = {unit.ID}

    addNewOrder(WL.GameOrderEvent.Create(playerID, lvlUpMessage, nil, {terrMod}))
end

local function handleLevelUps(game, order, result, addNewOrder)
    for _, unit in pairs(result.ActualArmies.SpecialUnits) do -- handle attacking troops
		local payload = split(string.sub(unit.ModData, 5), ';;')
        if isSpecialUnit(unit) then
			if (result.DefendingArmiesKilled.DefensePower > 0 and tonumber(payload[3]) and tonumber(payload[3]) ~= 0) and
			not any(result.AttackingArmiesKilled.SpecialUnits, function(v) return v.ID == unit.ID end) then
				local xpGained = result.DefendingArmiesKilled.DefensePower or 0
				local territoryID = (result.IsSuccessful and order.To) or order.From

				levelUp(unit, territoryID, xpGained, order.PlayerID, addNewOrder)
			end
		end
	end

	local defendingSpecialUnits = game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies.SpecialUnits or {}
	if (#defendingSpecialUnits > 0 and not result.IsSuccessful) then -- handle defending troops
		for _, unit in pairs(defendingSpecialUnits) do
			local payload = split(string.sub(unit.ModData, 5), ';;')
			if isSpecialUnit(unit) then
				if (result.AttackingArmiesKilled.AttackPower > 0 and tonumber(payload[3]) and tonumber(payload[3]) ~= 0) and
				not any(result.DefendingArmiesKilled.SpecialUnits, function(v) return v.ID == unit.ID end) then
					local xpGained = result.AttackingArmiesKilled.AttackPower or 0
					local territoryID = order.From

					levelUp(unit, territoryID, xpGained, game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID, addNewOrder)
				end
			end
		end
    end
end

local function createDeathMessage(unit, land, isNeutral, newOwner)
    local unitName = unit.TextOverHeadOpt or unit.Name
    -- local ownerName = isNeutral and 'Neutral' or game.Game.Players[land.OwnerPlayerID].DisplayName(nil, false)
	local ownerName = "placeholder"
    local message = ownerName .. ":\n" .. unitName .. " has perished in battle."

    if newOwner then
        message = unitName .. " has been transferred to " .. newOwner .. "."
    end
    return message
end

local function handleDeath(unit, result, land, attackFailed, addNewOrder, attackOrder, order)
    local isNeutral = land.IsNeutral
    local transfer = tonumber(split(string.sub(unit.ModData, 5), ';;')[2]) or 0
    local targetPlayerID = land.OwnerPlayerID

	local isTransferable = transfer > 0
	local isFailedAttackOnPlayer = attackOrder and targetPlayerID ~= 0 and not attackFailed
    if isTransferable and (isFailedAttackOnPlayer or not attackOrder) then -- transfer unit
		transfer = transfer - 1

		local payloadSplit = split(string.sub(unit.ModData, 5), ';;')
        local builder = WL.CustomSpecialUnitBuilder.CreateCopy(unit)
        builder.OwnerID = targetPlayerID
        builder.ModData = modSign(0) .. payloadSplit[1] .. ';;' .. tostring(transfer) .. table.concat(payloadSplit, ';;', 3)
        local terrMod = WL.TerritoryModification.Create(land)
        terrMod.AddSpecialUnits = {builder.Build()}

        local message = createDeathMessage(unit, land, isNeutral, game.Game.Players[targetPlayerID].DisplayName(nil, false))
        addNewOrder(WL.GameOrderEvent.Create(targetPlayerID, message, nil, {terrMod}))
    else -- kill unit
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

	handleLevelUps(game, order, result, addNewOrder)
	handleDeaths(game, order, result, addNewOrder)
end

------------purchase functions----------------------------

local function extractUnitPayloadData(payload)
	local payloadSplit = split(string.sub(payload, 7), ';;')
	print(getImageFile(tonumber(payloadSplit[6])))
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

-- local function updatePublicGameData(publicData, payloadData, playerID)
--     local type = payloadData.type
--     if publicData[type] == nil then publicData[type] = {} end
--     if publicData[type][playerID] == nil then publicData[type][playerID] = {} end
    
--     -- Update the count of units ever created of this type by this player and globally
--     publicData[type][playerID].CurrEver = (publicData[type][playerID].CurrEver or 0) + 1
--     publicData[type].CurrEver = (publicData[type].CurrEver or 0) + 1
    
--     -- Apply cooldown, if applicable
--     if payloadData.cooldown and payloadData.cooldown > 0 then
--         publicData[type][playerID].cooldowntimer = game.Game.TurnNumber + payloadData.cooldown
--     end
-- end

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
	if numUnitsAlreadyHave >= unit.unitMax then
		return false, string.format('Skipping %s purchase. A player can only control %d units of this type, and you currently control %d.', unit.typeName, unit.unitMax, numUnitsAlreadyHave)
	elseif not unit.shared and publicData[unit.type][order.PlayerID].CurrEver >= maxUnitsEver and maxUnitsEver ~= -1 then
		return false, string.format('Skipping %s purchase. A player can only purchase %d units of this type in one game, this limit has been reached.', unit.typeName, maxUnitsEver)
	elseif unit.shared and publicData[unit.type].CurrEver >= maxUnitsEver and maxUnitsEver ~= -1 then
		return false, string.format('Skipping %s purchase. Only %d units of this type can be purchased in the game across all players, this limit has been reached.', unit.typeName, maxUnitsEver)
	end

	if (order.CostOpt == nil) then
		return false, "CostOpt is null; please contact the mod developers (Yamada)"; --shouldn't ever happen, unless another mod interferes
	end
    
    return true
end

local function generateExpiryTurn(minExpiry, maxExpiry, currentTurn)
    if minExpiry == nil or maxExpiry == nil or minExpiry == 0 or maxExpiry == 0 then
        return 0, "" -- Indicates the unit does not have a life expectancy limit
    end
	local turn = math.random(minExpiry, maxExpiry) + currentTurn
    return turn, '\nLife ends on Turn: ' .. turn
end

local function processPurchase(game, order, addNewOrder)
	local BEFORE_ARMIES = 99
	local AFTER_ARMIES = -99
    local unit = extractUnitPayloadData(order.Payload)
	local maxUnitsEver = 0
	if (Mod.Settings.Unitdata[unit.type].MaxServer ~= true and
		Mod.Settings.Unitdata[unit.type].MaxServer ~= false and
		Mod.Settings.Unitdata[unit.type].MaxServer ~= 0) then
			maxUnitsEver = Mod.Settings.Unitdata[unit.type].MaxServer
	end
    local validPurchase, invalidationMessage = prePurchaseChecks(game, order, unit, maxUnitsEver)
    if not validPurchase then
        addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, invalidationMessage))
		return
    end

	-- build unit
	local unitExpiryTurn, additionalMessages = generateExpiryTurn(Mod.Settings.Unitdata[unit.type].Minlife, Mod.Settings.Unitdata[unit.type].Maxlife, game.Game.TurnNumber)
	local combatOrder = BEFORE_ARMIES
	local altMove = Mod.Settings.Unitdata[unit.type].Altmoves or 0
	local transfer = Mod.Settings.Unitdata[unit.type].Transfer or 0
	local levelAmount = Mod.Settings.Unitdata[unit.type].Level or 0
	local defense = Mod.Settings.Unitdata[unit.type].Defend or 0
	local cooldown = Mod.Settings.Unitdata[unit.type].Cooldown or 0
	local assass = Mod.Settings.Unitdata[unit.type].Assassination or 0

	if Mod.Settings.Unitdata[unit.type].AttackMax and Mod.Settings.Unitdata[unit.type].AttackMax > Mod.Settings.Unitdata[unit.type].unitpower then
		additionalMessages = additionalMessages .. '\nAttack power: ' .. unit.unitPower
	end
	if (levelAmount > 0)then
		unit.typeName = 'LV0 ' .. unit.typeName
	end
	if (Mod.Settings.Unitdata[unit.type].CombatOrder or 0) == 1 then
		combatOrder = AFTER_ARMIES
	end

	local absorbedDamage = (unit.unitPower + defense /2 ) / 2

	local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID)
	builder.Name = unit.typeName;
	builder.IncludeABeforeName = true;
	builder.ImageFilename = unit.image
	builder.AttackPower = unit.unitPower
	builder.DefensePower = defense
	builder.CombatOrder = combatOrder
	builder.DamageToKill = absorbedDamage
	builder.DamageAbsorbedWhenAttacked = absorbedDamage
	builder.CanBeGiftedWithGiftCard = true
	builder.CanBeTransferredToTeammate = false
	builder.CanBeAirliftedToSelf = true
	builder.CanBeAirliftedToTeammate = true
	builder.TextOverHeadOpt = unit.characterName
	builder.IsVisibleToAllPlayers = unit.visible
	builder.ModData = constructModData({
		unitExpiryTurn = unitExpiryTurn,
		transfer = transfer,
		levelAmount = levelAmount,
		unitPower = unit.unitPower,
		defense = defense,
		altMove = altMove,
		assass = assass
	})

	local terrMod = WL.TerritoryModification.Create(unit.targetTerritoryID);
	terrMod.AddSpecialUnits = {builder.Build()};
	
	addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a '.. unit.typeName .. additionalMessages, nil, {terrMod})); --create unit

	local publicData = initPublicData(unit.type, order.PlayerID)

	if (maxUnitsEver > 0 and unit.shared == false) then
		publicData[unit.type][order.PlayerID].CurrEver = publicData[unit.type][order.PlayerID].CurrEver + 1
	elseif (maxUnitsEver > 0 and unit.shared == true) then
		publicData[unit.type].CurrEver = publicData[unit.type].CurrEver + 1
	end
	if (cooldown ~= 0) then
		publicData[unit.type][order.PlayerID].cooldowntimer = game.Game.TurnNumber + cooldown
	end

	Mod.PublicGameData = publicData
end

-----------------final functions---------------------
function Server_AdvanceTurn_Start(game, addNewOrder)
	for _, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		for _, unit in pairs (territory.NumArmies.SpecialUnits) do -- search all Territories and see if it has a speical unit
			if isSpecialUnit(unit) then -- make sure the speical unit is only from I.S. mods
				local payloadSplit = split(string.sub(unit.ModData, 5), ';;'); 
				local unitExpiryTurn = tonumber(payloadSplit[1])
				
				print(unit.Name, unit.TextOverHeadOpt, "Unit ModData:", unit.ModData)
				if unitExpiryTurn ~= 0 and unitExpiryTurn <= game.Game.TurnNumber then -- check if this unit has expired in life, if yes, then destroy it
					local mod = WL.TerritoryModification.Create(territory.ID)
					mod.RemoveSpecialUnitsOpt = {unit.ID}
					local UnitdiedMessage = unit.TextOverHeadOpt .. ' the ' .. unit.Name .. ' has died of natural causes'
					addNewOrder(WL.GameOrderEvent.Create(unit.OwnerID, UnitdiedMessage, nil, {mod}));
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
