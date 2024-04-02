require('Utilities')

-------------attack/transfer functions------------------

local function checkValidMove(result)
	for _, unit in pairs(result.ActualArmies.SpecialUnits) do -- checking to see if an attack had a special unit
        if unit.proxyType == "CustomSpecialUnit" and unit.ModData and startsWith(unit.ModData, "C&P") then
			local payloadSplit = split(string.sub(unit.ModData, 5), ';;'); 
			local isSlowUnit = tonumber(payloadSplit[8]) or 0
			if (isSlowUnit > 0) then
				return false
			end
		end
	end
	return true
end

local function processAttackTransfer(game, order, result, skipThisOrder, addNewOrder)
    if game.Game.TurnNumber % 2 ~= 0 then
        local invalidMove = checkValidMove(result)
        if invalidMove then
            local skipMessage = 'Move order for this unit was skipped: unit can only move on even turns'
            addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, skipMessage, {}, {}))
            skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
			return
        end
    end

	LevelupLogic(game, order, result, skipThisOrder, addNewOrder)
	Deathlogic(game, order, result, skipThisOrder, addNewOrder)
end


-----------------final functions---------------------
function Server_AdvanceTurn_Start(game, addNewOrder)					
	for _, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		for _, unit in pairs (territory.NumArmies.SpecialUnits)do -- search all Territories and see if it has a speical unit
			if unit.proxyType == "CustomSpecialUnit" and unit.ModData and startsWith(unit.ModData, modSign(0)) then -- make sure the speical unit is only from I.S. mods
				local payloadSplit = split(string.sub(unit.ModData, 5), ';;'); 
				local unitExpiryTurn = tonumber(payloadSplit[1])

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
    if order.proxyType == "GameOrderAttackTransfer" then
        processAttackTransfer(game, order, result, skipThisOrder, addNewOrder)
    elseif order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, modSign(0)) then
        processPurchase(game, order, addNewOrder)
    end
end

local function extractPayloadData(payload)
	local payloadSplit = split(string.sub(payload, 7), ';;')
	return {
		targetTerritoryID = tonumber(payloadSplit[1]),
		type = tonumber(payloadSplit[2]),
		unitPower = tonumber(payloadSplit[3]),
		typeName = payloadSplit[4],
		unitMax = tonumber(payloadSplit[5]),
		image = tonumber(payloadSplit[6]),
		shared = payloadSplit[7] == 'true',
		visible = payloadSplit[8] == 'true',
		characterName = payloadSplit[9]
	}
end

-- local function constructModData(unit, expiryTurn)
--     return modSign(0) .. expiryTurn .. ';;' .. 
-- 			unit.transfer .. ';;' .. 
-- 			unit.levelAmount .. ';;' .. 
-- 			unit.currentXP .. ';;' .. 
-- 			unit.unitPower .. ';;' .. 
-- 			unit.startingLevel .. ';;' .. 
-- 			unit.defense .. ';;' .. 
-- 			unit.altMove .. ';;' .. 
-- 			unit.assass
-- end

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

-- -- Count units of a specific type
-- local function numUnitsIn(armies, typeName, type)
--     local ret = 0
--     for _, su in pairs(armies.SpecialUnits) do
--         if su.proxyType == 'CustomSpecialUnit' then -- Only consider custom units
--             local compare = su.Name

--             -- Adjust for unit levels, if applicable
--             if (Mod.Settings.Unitdata[type].Level or 0) > 0 then
--                 local stringSkip = #su.Name - #typeName
--                 compare = su.Name:sub(stringSkip + 1)
--             end

--             -- Count units matching the criteria
--             if compare == typeName and startsWith(su.ModData, modSign(0)) then
--                 ret = ret + 1
--             end
--         end
--     end
--     return ret
-- end

-- local function prePurchaseChecks(game, order, unit)
--     -- Check if the territory is controlled by the player issuing the order
--     local targetTerritory = game.ServerGame.LatestTurnStanding.Territories[unit.targetTerritoryID]
--     if not targetTerritory or targetTerritory.OwnerPlayerID ~= order.PlayerID then
--         return false -- Territory not controlled by the player
--     end

-- 	-- Count units of each type
-- 	local numUnitsAlreadyHave = 0;
-- 	for _, territory in pairs(game.ServerGame.LatestTurnStanding.Territories) do -- server side check to make sure Units are not above the Given amount
-- 		if(unit.shared == true )then
-- 			numUnitsAlreadyHave = numUnitsAlreadyHave + numUnitsIn(territory.NumArmies, unit.typeName, unit.type);
-- 		elseif(territory.OwnerPlayerID == order.PlayerID) then
-- 			numUnitsAlreadyHave = numUnitsAlreadyHave + numUnitsIn(territory.NumArmies, unit.typeName, unit.type);				
-- 		end
-- 	end

-- 	local publicData = Mod.PublicGameData
-- 	if publicData[type] == nil then publicData[type] = {} end
-- 	if publicData[type][ID] == nil then publicData[type][ID] = {} end 
-- 	if publicData[type][ID].CurrEver == nil then publicData[type][ID].CurrEver = 0 end
-- 	if publicData[type][ID].cooldowntimer == nil then publicData[type][ID].cooldowntimer = 0 end
-- 	if publicData[type].CurrEver == nil then publicData[type].CurrEver = 0 end

-- 	-- Check for the maximum units limit for the player and overall in the game
-- 	if numUnitsAlreadyHave >= unit.unitMax then
-- 		return false, string.format('Skipping %s purchase since max is %d and you have %d.', unit.typeName, unit.unitMax, numUnitsAlreadyHave)
-- 	elseif not unit.shared and publicData[unit.type][order.PlayerID].CurrEver >= unit.MaxUnitsEver and unit.MaxUnitsEver ~= -1 then
-- 		return false, string.format('Skipping %s purchase. You have reached the game\'s spawnable amount which is %d.', unit.typeName, unit.MaxUnitsEver)
-- 	elseif unit.shared and publicData[unit.type].CurrEver >= unit.MaxUnitsEver and unit.MaxUnitsEver ~= -1 then
-- 		return false, string.format('Skipping %s purchase since the Max amount for the server is %d. The game has reached its spawnable amount set by host.', unit.typeName, payloadData.MaxUnitsEver)
-- 	end

    
--     return true
-- end

-- local function calculateExpiryTurn(minExpiry, maxEpiry, currentTurn)
--     if minExpiry == nil or maxEpiry == nil or minExpiry == 0 or maxEpiry == 0 then
--         return 0 -- Indicates the unit does not have a life expectancy limit
--     end
--     return math.random(minLife, maxLife) + currentTurn
-- end

-- local function updateUnitValues(type, altmove, transfer, levelamount, defense)
-- 	if (Mod.Settings.Unitdata[type].Altmoves ~= nil and Mod.Settings.Unitdata[type].Altmoves ~= false)then -- adding values after mod launched
-- 		altmove = 1
-- 	end 
-- 	if (Mod.Settings.Unitdata[type].Transfer ~= nil)then
-- 		transfer = Mod.Settings.Unitdata[type].Transfer
-- 	end

-- 	if (Mod.Settings.Unitdata[type].Level ~= nil)then
-- 		levelamount = Mod.Settings.Unitdata[type].Level
-- 	end
-- 	if (Mod.Settings.Unitdata[type].Defend ~= nil)then
-- 		defence = Mod.Settings.Unitdata[type].Defend
-- 	end
-- end

-- local function ProcessCustomOrder(game, order, addNewOrder, unit, publicData)
--     local validationResult, validationMessage = prePurchaseChecks(game, order, unit, publicData)
--     if not validationResult then
--         if validationMessage ~= "" then
--             addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, validationMessage, nil, {}))
--         end
--         return
--     end

--     -- Assuming getImageFile and other utility functions are defined elsewhere
--     local filename = getImageFile(unit.image)

--     -- Calculate life expectancy and other properties for the new unit
--     local expiryTurn = calculateExpiryTurn(unit.minLife, unit.maxLife, game.Game.TurnNumber)
--     local addedWords = '\nLife ends on Turn: ' .. Turnkilled

--     -- Building and adding the new unit
--     local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID)
--     builder.Name = unit.typeName
--     builder.IncludeABeforeName = true
--     builder.ImageFilename = filename
--     builder.AttackPower = unit.unitPower
--     builder.DefensePower = unit.defense
--     builder.CombatOrder = unit.combatOrder
--     builder.DamageToKill = unit.absorbedDamage
--     builder.DamageAbsorbedWhenAttacked = unit.absorbedDamage
--     builder.CanBeGiftedWithGiftCard = true
--     builder.CanBeTransferredToTeammate = false
--     builder.CanBeAirliftedToSelf = true
--     builder.CanBeAirliftedToTeammate = true
--     builder.TextOverHeadOpt = unit.characterName
--     builder.IsVisibleToAllPlayers = unit.visible
--     builder.ModData = constructModData(unit, expiryTurn)

--     local terrMod = WL.TerritoryModification.Create(unit.targetTerritoryID)
--     terrMod.AddSpecialUnits = {builder.Build()}

--     local purchaseMessage = 'Purchased a ' .. unit.typeName .. addedWords
--     addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, purchaseMessage, nil, {terrMod}))

--     -- Update public game data
--     updatePublicGameData(publicData, unit, order.PlayerID)

--     Mod.PublicGameData = publicData
-- end

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
	-- Process attack/transfer orders
	if order.proxyType == "GameOrderAttackTransfer"  and result.IsAttack then 
		Game2 = game
		if (game.Game.TurnNumber % 2 ~= 0) then
			local canMove = checkValidMove(game, order, result, skipThisOrder, addNewOrder)
			if canMove then
				LevelupLogic(game, order, result, skipThisOrder, addNewOrder)
				Deathlogic(game, order, result, skipThisOrder, addNewOrder)
			end
		end
	end

	-- Process purchase order
	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, modSign(0))) then
        local unitData = extractPayloadData(order.Payload)
        if not prePurchaseChecks(game, order, unitData) then return end
		ProcessCustomOrder(game, order, addNewOrder, unitData)
	end

		local tempMaxunits = -1
		if (Mod.Settings.Unitdata[type].MaxServer ~= true and Mod.Settings.Unitdata[type].MaxServer ~= false and Mod.Settings.Unitdata[type].MaxServer ~= 0)then tempMaxunits = Mod.Settings.Unitdata[type].MaxServer end 

		local MaxUnitsEver = tempMaxunits
		local ID = order.PlayerID
		local minlife = Mod.Settings.Unitdata[type].Minlife
		local maxlife = Mod.Settings.Unitdata[type].Maxlife
		local Turnkilled = 0
		local addedwords = ''
		local addedwords2 = ""
		local transfer = 0
		local levelamount = 0
		local currentxp = 0
		local defence = unitpower / 2
		local altmove = 0 
		local combatorder = 123
		local cooldown = Mod.Settings.Unitdata[type].Cooldown or 0
		local assass = Mod.Settings.Unitdata[type].Assassination or 0

		--disabled because can no longer read from Mod.settings using type (without type works fine)
		--local costFromOrder = order.CostOpt[WL.ResourceType.Gold]; --this is the cost from the order.  We can't trust this is accurate, as someone could hack their client and put whatever cost they want in there.  Therefore, we must calculate it ourselves, and only do the purchase if they match
		--[[local realCost = unitcost
		if (realCost > costFromOrder) then
			return; --don't do the purchase if their cost didn't line up.  This would only really happen if they hacked their client or another mod interfered
		end]]--
		
		local filename = getImageFile(image) -- sort through images to find the correct one

		if (maxlife ~= 0)then
		Turnkilled = math.random(minlife,maxlife) + game.Game.TurnNumber 
		addedwords =  '\nLife ends on Turn: ' .. Turnkilled
		end
		if Mod.Settings.Unitdata[type].AttackMax ~= nil and Mod.Settings.Unitdata[type].AttackMax > Mod.Settings.Unitdata[type].unitpower then
			addedwords2 = '\nAttack power: ' .. unitpower
		end
		if (levelamount > 0)then
			typename = 'LV0 ' .. typename

		end
			if (Mod.Settings.Unitdata[type].CombatOrder or 0) == 1 then
			combatorder = combatorder * -1
			end

			--- Building Unit now
		local absoredDamage = (unitpower+defence)/2
		local startinglevel = 0

		local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID);
		builder.Name = typename;
		builder.IncludeABeforeName = true;
		builder.ImageFilename = filename;
		builder.AttackPower = unitpower;
		builder.DefensePower = defence;
		builder.CombatOrder = combatorder
		builder.DamageToKill = absoredDamage
		builder.DamageAbsorbedWhenAttacked = absoredDamage
		builder.CanBeGiftedWithGiftCard = true;
		builder.CanBeTransferredToTeammate = false
		builder.CanBeAirliftedToSelf = true;
		builder.CanBeAirliftedToTeammate = true;
		builder.TextOverHeadOpt = charactername
		builder.IsVisibleToAllPlayers = visible;
		builder.ModData = modSign(0) .. Turnkilled .. ';;' .. transfer .. ';;' .. levelamount .. ';;' .. currentxp .. ';;' .. unitpower .. ';;' .. startinglevel .. ';;'.. defence .. ';;'.. altmove .. ';;'.. assass

		local terrMod = WL.TerritoryModification.Create(targetTerritoryID);
		terrMod.AddSpecialUnits = {builder.Build()};

		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a '.. typename .. addedwords .. addedwords2, nil, {terrMod}));
		
		--create a layer of playerID (prob change everything from publicdata to playerdata with id)
		if (MaxUnitsEver > 0 and shared == false)then
		publicdata[type][ID].CurrEver = publicdata[type][ID].CurrEver + 1 
			
		elseif (MaxUnitsEver > 0 and shared == true)then
		publicdata[type].CurrEver = publicdata[type].CurrEver + 1 end

		if (cooldown ~= 0)then 
			publicdata[type][ID].cooldowntimer = game.Game.TurnNumber + cooldown
		end
		print('type',type,'id',ID,'cooldown',publicdata[type][ID].cooldowntimer)
		Mod.PublicGameData = publicdata
	end
end

function Server_AdvanceTurn_End(game, addNewOrder)
	--[[for _, territories in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		for i, unit in pairs (territories.NumArmies.SpecialUnits)do -- search all Territories and see if it has a speical unit
			if unit.proxyType == "CustomSpecialUnit" and unit.ModData and startsWith(unit.ModData, modSign(0)) then
				local payloadSplit = split(string.sub(unit.ModData, 5), ';;'); 
				local mod = WL.TerritoryModification.Create(territories.ID)
				
				if v.OwnerID ~= territories.OwnerPlayerID then -- making sure every unit transfer properly
					local builder = WL.CustomSpecialUnitBuilder.CreateCopy(unit)
					builder.OwnerID = territories.OwnerPlayerID
					mod.AddSpecialUnits = {builder.Build()}
					mod.RemoveSpecialUnitsOpt = {unit.ID}
					local UnitdiedMessage = "Chaning to proper Owner of SU"
					addNewOrder(WL.GameOrderEvent.Create(unit.OwnerID, UnitdiedMessage, nil, {mod}));
				end
			end
		end
	end]]--
end

function Deathlogic(game, order, result, skipThisOrder, addNewOrder)
	if #result.AttackingArmiesKilled.SpecialUnits > 0  then -- when a unit dies from attacking. 

		local armiesKilled = result.AttackingArmiesKilled 
		local specialUnitKilled = armiesKilled.SpecialUnits
		local land = Game2.ServerGame.LatestTurnStanding.Territories[order.To]

		for i,v in pairs (specialUnitKilled)do
			if v.proxyType == "CustomSpecialUnit" then
				if v.ModData ~= nil then 
					if startsWith(v.ModData, modSign(0)) then

						local Ordername = ""
						local UnitKilledMessage = ""
						if land.IsNeutral == true then Ordername = 'Neutral' 
						else Ordername = Game2.Game.Players[land.OwnerPlayerID].DisplayName(nil,false) end

						local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v);
						if v.TextOverHeadOpt == nil then builder.TextOverHeadOpt = v.Name end

						UnitKilledMessage = Game2.Game.Players[v.OwnerID].DisplayName(nil,false) .. ':\n' ..
						builder.TextOverHeadOpt .. ' the ' .. v.Name .. ' has perished in battle'   
						
						local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
						local transfer = tonumber(payloadSplit[2]) 

						if (transfer ~= 0 and land.OwnerPlayerID ~= 0 and transfer ~= nil and result.IsSuccessful == false)then
							local transfermessage = v.TextOverHeadOpt .. ' the ' .. v.Name .. ' has been transfered to ' ..  Game2.Game.Players[land.OwnerPlayerID].DisplayName(nil,false)
							
								transfer = transfer - 1
								builder.OwnerID  = land.OwnerPlayerID
								builder.ModData = modSign(0) .. payloadSplit[1] .. ';;'.. transfer .. ';;' .. payloadSplit[3].. ';;' .. payloadSplit[4].. ';;' .. payloadSplit[5].. ';;' .. payloadSplit[6].. ';;'.. (payloadSplit[7] or 0).. ';;'.. (payloadSplit[8] or 0) .. ';;' .. (payloadSplit[9] or 0)

								local terrMod = WL.TerritoryModification.Create(order.To)
								terrMod.AddSpecialUnits = {builder.Build()}
								addNewOrder(WL.GameOrderEvent.Create(land.OwnerPlayerID, transfermessage, nil, {terrMod}))
								
						else
							addNewOrder(WL.GameOrderEvent.Create(v.OwnerID , UnitKilledMessage , nil,nil,nil ,{} ))

						end
					end
				end
			end
		end  
	end
	if (#result.DefendingArmiesKilled.SpecialUnits > 0) then -- when a unit dies from defending

		local specialUnitKilled = result.DefendingArmiesKilled.SpecialUnits
		local land = Game2.ServerGame.LatestTurnStanding.Territories[order.To]
		local landfrom = Game2.ServerGame.LatestTurnStanding.Territories[order.From]

		for i,v in pairs (specialUnitKilled)do
			if v.proxyType == "CustomSpecialUnit" then
				if v.ModData ~= nil then 
					if startsWith(v.ModData, modSign(0)) then

						if v.TextOverHeadOpt == nil then v.TextOverHeadOpt = v.Name end

						local Ordername = ''
						local ID = 1

						if land.IsNeutral == true then 
							Ordername = 'Neutral' 
							ID = 0
						else Ordername = Game2.Game.Players[v.OwnerID].DisplayName(nil,false)
						ID = v.OwnerID end
					
						local payloadSplit = split(string.sub(v.ModData, 5), ';;')
						local transfer = tonumber(payloadSplit[2])
						local UnitKilledMessage = Ordername .. ' destroyed \n' ..
						v.TextOverHeadOpt .. ' the ' .. v.Name .. '. it perished in battle' 

						if (transfer ~= 0 and transfer ~= nil)then
							Ordername = Game2.Game.Players[landfrom.OwnerPlayerID].DisplayName(nil,false)
							local transfermessage = v.TextOverHeadOpt .. ' the ' .. v.Name .. ' has been transfered to ' ..  Ordername 

							local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v)
							transfer = transfer - 1
							builder.OwnerID  = landfrom.OwnerPlayerID
							builder.ModData = modSign(0) .. payloadSplit[1] .. ';;'.. transfer .. ';;' .. payloadSplit[3].. ';;' .. payloadSplit[4].. ';;' .. payloadSplit[5].. ';;' .. payloadSplit[6].. ';;'.. (payloadSplit[7] or 0).. ';;'.. (payloadSplit[8] or 0) .. ';;' .. (payloadSplit[9] or 0)

							local terrMod = WL.TerritoryModification.Create(order.From);
							terrMod.AddSpecialUnits = {builder.Build()};
							addNewOrder(WL.GameOrderEvent.Create(landfrom.OwnerPlayerID, transfermessage, nil, {terrMod}));

						else
							addNewOrder(WL.GameOrderEvent.Create(ID , UnitKilledMessage , nil,nil,nil ,{} ))

						end
					end

				end
			end
		end
	end
	end


function LevelupLogic(game, order, result, skipThisOrder, addNewOrder)

		local defendingspecialUnits = Game2.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies.SpecialUnits
		local land =  Game2.ServerGame.LatestTurnStanding.Territories[order.To]
		local NoMterrMod = WL.TerritoryModification.Create(order.From); -- adding it to territory logic
		local NoMterrNomove = WL.TerritoryModification.Create(order.To); -- adding it to territory logic

		for i, v in pairs(result.ActualArmies.SpecialUnits) do -- checking to see if an attack had a special unit
			if v.proxyType == "CustomSpecialUnit" then -- making sure its a custom unit, not a commander or otherwise
				if v.ModData ~= nil then -- making sure it has data to read from

					if startsWith(v.ModData, modSign(0)) then -- make sure the speical unit is only from I.S. mod
						local dead = false
						local territory = nil 
						for i2, v2 in pairs( result.AttackingArmiesKilled.SpecialUnits) do -- checking to see if he died
							if v.ID == v2.ID then
								dead = true
							end
						end
						if dead == false then
							print (v.ModData)
							local payloadSplit = split(string.sub(v.ModData, 5), ';;')
							local levelamount = tonumber(payloadSplit[3])
							local XP = tonumber(payloadSplit[4])
							local unitpower = tonumber(payloadSplit[5]) or 0
							local currlevel = tonumber(payloadSplit[6])
							local unitdefence = tonumber(payloadSplit[7]) or 0
							local absoredDamage = math.max(unitpower, unitdefence)
							local altmove = tonumber(payloadSplit[8]) or 0
							print (altmove,'altmove')

							if (result.DefendingArmiesKilled.DefensePower > 0)then -- making sure the attack actually had people who died
								if levelamount ~= 0 and levelamount ~= nil then -- making sure the level option is turned on

									XP = XP + result.DefendingArmiesKilled.DefensePower
									local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v)
									print (currlevel, "level", XP, 'XP')

									local skipper = string.len(payloadSplit[6]) + 4
									local namepayload = split(string.sub(builder.Name, skipper), ';');  -- removing part of the old name to replace
									print(skipper,'skipper')

									if result.IsSuccessful == true then territory = order.To
									else territory = order.From end

									local terrMod = WL.TerritoryModification.Create(territory); -- adding it to territory logic
									local levelupmessage = (builder.TextOverHeadOpt or 0) .. ' the ' .. builder.Name .. ' Gained XP'
									if (XP >= levelamount) then -- resetting XP and level amount
										XP = 0 
										currlevel = currlevel + 1 

										levelamount = levelamount + (levelamount / currlevel)
										builder.AttackPower = builder.AttackPower + (builder.AttackPower / currlevel)
										builder.DefensePower = builder.DefensePower + (builder.DefensePower / currlevel);
										builder.DamageToKill = absoredDamage + (builder.DamageToKill / currlevel);
										builder.DamageAbsorbedWhenAttacked = absoredDamage + (builder.DamageAbsorbedWhenAttacked / currlevel)
										levelupmessage = builder.TextOverHeadOpt .. ' the ' .. v.Name .. ' has leveled up!!!'
									end --starting XP over if level was reached

									builder.Name = "LV" .. currlevel .. ' ' .. namepayload[1]
									builder.ModData = modSign(0) .. payloadSplit[1] .. ';;'..payloadSplit[2] .. ';;'..levelamount .. ';;'.. XP .. ';;' .. unitpower .. ';;' .. currlevel.. ';;'.. (unitdefence or 0).. ';;'.. (payloadSplit[8] or 0) .. ';;' .. (payloadSplit[9] or 0)
									print (v.ModData)
									terrMod.AddSpecialUnits = {builder.Build()};
									terrMod.RemoveSpecialUnitsOpt = {v.ID}

									addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, levelupmessage, nil, {terrMod}));
								end
							end
						end
					end
				end
			end
		end

		if #defendingspecialUnits > 0 and result.IsSuccessful == false then
			print('defending special units found')

			for i, v in pairs(defendingspecialUnits) do -- checking to see if an attack had a special unit
				if v.proxyType == "CustomSpecialUnit" then -- making sure its a custom unit, not a commander or otherwise
					if v.ModData ~= nil then -- making sure it has data to read from

						if startsWith(v.ModData, modSign(0)) then -- make sure the speical unit is only from I.S. mod
							local dead = false

							for _, v2 in pairs( result.DefendingArmiesKilled.SpecialUnits) do -- checking to see if he died
								if v.ID == v2.ID then
									dead = true
								end
							end
							if dead == false then
								print (v.ModData)
								local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
								local levelamount = tonumber(payloadSplit[3])
								local XP = tonumber(payloadSplit[4])
								local unitpower = tonumber(payloadSplit[5]) or 0
								local currlevel = tonumber(payloadSplit[6])
								local unitdefence = tonumber(payloadSplit[7]) or 0
								local absoredDamage = math.max(unitpower,unitdefence)
								local territory = order.To

								if (result.AttackingArmiesKilled.AttackPower  > 0)then -- making sure the attack actually had people who died
									if levelamount ~= 0 and levelamount ~= nil then -- making sure the level option is turned on

										XP = XP + result.AttackingArmiesKilled.AttackPower
										local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v);

										print (currlevel, "level", XP, 'XP')

										local skipper = string.len(payloadSplit[6]) + 4
										local namepayload = split(string.sub(builder.Name, skipper), ';');  -- removing part of the old name to replace

										local terrMod = WL.TerritoryModification.Create(territory); -- adding it to territory logic
										local levelupmessage = (builder.TextOverHeadOpt or 0) .. ' the ' .. builder.Name .. ' Gained XP'
										if (XP >= levelamount) then -- resetting XP and level amount
											XP = 0 
											currlevel = currlevel + 1 

											levelamount = levelamount + (levelamount / currlevel)
											builder.AttackPower = builder.AttackPower + (builder.AttackPower / currlevel)
											builder.DefensePower = builder.DefensePower + (builder.DefensePower / currlevel);
											builder.DamageToKill = absoredDamage + (absoredDamage / currlevel);
											builder.DamageAbsorbedWhenAttacked = absoredDamage + (builder.DamageAbsorbedWhenAttacked / currlevel)
											levelupmessage = builder.TextOverHeadOpt .. ' the ' .. v.Name .. ' has leveled up!!!'
										end --starting XP over if level was reached

										builder.Name = "LV" .. currlevel .. ' ' .. namepayload[1]
										builder.ModData = modSign(0) .. payloadSplit[1] .. ';;'..payloadSplit[2] .. ';;'..levelamount .. ';;'.. XP .. ';;' .. unitpower .. ';;' .. currlevel.. ';;'.. (unitdefence or 0).. ';;'.. (payloadSplit[8] or 0) .. ';;' .. (payloadSplit[9] or 0)
										print (v.ModData)
										print (builder.ModData)
										print (builder.AttackPower)
										terrMod.AddSpecialUnits = {builder.Build()};
										terrMod.RemoveSpecialUnitsOpt = {v.ID}

										addNewOrder(WL.GameOrderEvent.Create(land.OwnerPlayerID, levelupmessage, nil, {terrMod}));
									end
								end
							end
						end
					end
				end
			end
		end
	end
