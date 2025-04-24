require('Utilities')

function Server_AdvanceTurn_Start(game, addNewOrder)
								
	Game1 = game

	--if (Mod.Settings.corefeature ~= nil or Mod.Settings.corefeature == false) then
		for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do


				for i,v in pairs (ts.NumArmies.SpecialUnits)do -- search all Territories and see if it has a speical unit
					if v.proxyType == "CustomSpecialUnit" then
						if v.ModData ~= nil then -- 
							if startsWith(v.ModData, modSign(0)) then -- make sure the speical unit is only from I.S. mods
								local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
								local diebitch = tonumber(payloadSplit[1])

								if diebitch <= Game1.Game.TurnNumber and diebitch ~= 0 then -- check if this unit has expired in life, if yes, then destroy it
									local mod = WL.TerritoryModification.Create(ts.ID)
									t = {}
									table.insert(t, v.ID);
									mod.RemoveSpecialUnitsOpt = t
									local UnitdiedMessage = v.TextOverHeadOpt .. ' the ' .. v.Name .. ' has died of natural causes' 
		
									addNewOrder(WL.GameOrderEvent.Create(v.OwnerID, UnitdiedMessage, nil, {mod}));
		
								end
							end
						end
					end
				end
				
		end
	--end
	
end




function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
		

		if order.proxyType == "GameOrderAttackTransfer"  and result.IsAttack then 
			Game2 = game

			local even = Evenmoves(game, order, result, skipThisOrder, addNewOrder)

			if even == true then
				LevelupLogic(game, order, result, skipThisOrder, addNewOrder)

				Deathlogic(game, order, result, skipThisOrder, addNewOrder)
			end


		end


	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, modSign(0))) then  --look for the order that we inserted in Client_PresentCommercePurchaseUI
		
		local publicdata = Mod.PublicGameData

		local payloadSplit = split(string.sub(order.Payload, 7), ';;')


		print (order.Payload)
		local targetTerritoryID = tonumber(payloadSplit[1])
		local type = tonumber(payloadSplit[2])
		local unitpower = tonumber(payloadSplit[3])
		local typename = payloadSplit[4]
		local unitmax = tonumber(payloadSplit[5])
		local image = tonumber(payloadSplit[6])
		local shared = payloadSplit[7]
		local visible = payloadSplit[8]
		local charactername = payloadSplit[9]

		if (visible == 'true') then visible = true -- turning these varibles back into bools after converting them into strings
		else visible = false end
		if (shared == 'true') then shared = true
		else shared = false end

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
		local upkeep = Mod.Settings.Unitdata[type].Upkeep or 0

		if (Mod.Settings.Unitdata[type].Altmoves ~= nil and Mod.Settings.Unitdata[type].Altmoves ~= false)then -- adding values after mod launched
			 altmove = 1
		end 
		if (Mod.Settings.Unitdata[type].Transfer ~= nil)then
		 transfer = Mod.Settings.Unitdata[type].Transfer
		end

		if (Mod.Settings.Unitdata[type].Level ~= nil)then
			levelamount = Mod.Settings.Unitdata[type].Level
		end
		if (Mod.Settings.Unitdata[type].Defend ~= nil)then
			defence = Mod.Settings.Unitdata[type].Defend
		end


		--tracking the max amount between all players
		if publicdata[type] == nil then publicdata[type] = {} end
		if publicdata[type][ID] == nil then publicdata[type][ID] = {} end 
		if publicdata[type][ID].CurrEver == nil then publicdata[type][ID].CurrEver = 0 end
		if publicdata[type][ID].cooldowntimer == nil then publicdata[type][ID].cooldowntimer = 0 end
		if publicdata[type].CurrEver == nil then publicdata[type].CurrEver = 0 end



		local targetTerritoryStanding = game.ServerGame.LatestTurnStanding.Territories[targetTerritoryID];

		if (targetTerritoryStanding.OwnerPlayerID ~= order.PlayerID) then
			return; --can only buy This Unit onto a territory you control
		end

		
		if (order.CostOpt == nil) then
			return; --shouldn't ever happen, unless another mod interferes
		end


		--disabled because can no longer read from Mod.settings using type (without type works fine)
		--local costFromOrder = order.CostOpt[WL.ResourceType.Gold]; --this is the cost from the order.  We can't trust this is accurate, as someone could hack their client and put whatever cost they want in there.  Therefore, we must calculate it ourselves, and only do the purchase if they match

		--[[local realCost = unitcost
		if (realCost > costFromOrder) then
			return; --don't do the purchase if their cost didn't line up.  This would only really happen if they hacked their client or another mod interfered
		end]]--

		local numUnitsAlreadyHave = 0;
		for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do -- server side check to make sure Units are not above the Given amount
			
			if(shared == true )then
				numUnitsAlreadyHave = numUnitsAlreadyHave + NumUnitsIn(ts.NumArmies, typename,type);
							
			elseif(ts.OwnerPlayerID == order.PlayerID) then
				numUnitsAlreadyHave = numUnitsAlreadyHave + NumUnitsIn(ts.NumArmies, typename,type);				
			end
		end
		
		
	--skipping logic if any settings are set to limit the amount of units on field at a given time
		if (numUnitsAlreadyHave >= unitmax) then
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping '.. typename ..' purchase since max is ' .. unitmax .. ' and you have ' .. numUnitsAlreadyHave));
			return; --this player already has the maximum number of Units possible of this type, so skip adding a new one.
		
		elseif (shared == false and publicdata[type][ID].CurrEver >= MaxUnitsEver and MaxUnitsEver ~= -1) then
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping '.. typename ..' purchase. you have reached the games spawnable amount which is ' .. MaxUnitsEver));
			return; --this player already has the maximum number of Units possible of this type, so skip adding a new one.
				
		elseif (publicdata[type].CurrEver >= MaxUnitsEver and MaxUnitsEver ~= -1) then
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping '.. typename ..' purchase since the Max amount for the server is ' .. MaxUnitsEver .. '. the Game has reached its spawnable amount set by host'));
			return; --the server has already has the maximum number of Units possible of this type, so skip adding a new one.
		end

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
		builder.ModData = modSign(0) .. Turnkilled .. ';;' .. transfer .. ';;' .. levelamount .. ';;' .. currentxp .. ';;' .. unitpower .. ';;' .. startinglevel .. ';;'.. defence .. ';;'.. altmove .. ';;'.. assass .. ';;' .. type .. ';;' .. upkeep
	

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
		 Mod.PublicGameData = publicdata
	end
end

function Server_AdvanceTurn_End(game, addNewOrder)

	--[[for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do
		for i,v in pairs (ts.NumArmies.SpecialUnits)do -- search all Territories and see if it has a speical unit
			if v.proxyType == "CustomSpecialUnit" then
				if v.ModData ~= nil then -- 
					if startsWith(v.ModData, modSign(0)) then -- make sure the speical unit is only from I.S. mods
						local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
						local mod = WL.TerritoryModification.Create(ts.ID)
						
						if v.OwnerID ~= ts.OwnerPlayerID then -- making sure every unit transfer properly
							local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v)

							builder.OwnerID = ts.OwnerPlayerID
							mod.AddSpecialUnits = {builder.Build()}
							mod.RemoveSpecialUnitsOpt = {v.ID}
							local UnitdiedMessage = "Chaning to proper Owner of SU"

							addNewOrder(WL.GameOrderEvent.Create(v.OwnerID, UnitdiedMessage, nil, {mod}));

						end
					end
				end
			end
		end
		
	end]]--

	local publicdata = Mod.PublicGameData
	publicdata.Access = true
	Mod.PublicGameData = publicdata

end

function NumUnitsIn(armies, typename,type)

	local ret = 0;
	local compare = ""
	for _,su in pairs(armies.SpecialUnits) do
		if su.proxyType == 'CustomSpecialUnit' then -- make sure its a custom unit
			if (Mod.Settings.Unitdata[type].Level or 0) > 0 then -- check to see if levels are turned on, and if so subtract extra text
				local stringskip = #su.Name - #typename 

				compare = string.sub(su.Name, stringskip+1)
				print(compare)
			else
				compare = su.Name
			end
			if (compare == typename and startsWith(su.ModData, modSign(0))) then -- actually count unit
				ret = ret + 1;
				print(ret,"ret")
			end
		end
	end
	return ret;
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
								builder.ModData = modSign(0) .. payloadSplit[1] .. ';;'.. transfer .. ';;' .. payloadSplit[3].. ';;' .. payloadSplit[4].. ';;' .. payloadSplit[5].. ';;' .. payloadSplit[6].. ';;'.. (payloadSplit[7] or 0).. ';;'.. (payloadSplit[8] or 0) .. ';;' .. (payloadSplit[9] or 0) .. ';;' .. (payloadSplit[10] or 0).. ';;' .. (payloadSplit[11] or 0)

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
						local Overhead = v.Name
						if v.TextOverHeadOpt ~= nil then Overhead = v.TextOverHeadOpt end

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
						Overhead .. ' the ' .. v.Name .. '. it perished in battle' 

						if (transfer ~= 0 and transfer ~= nil)then
							Ordername = Game2.Game.Players[landfrom.OwnerPlayerID].DisplayName(nil,false)
							local transfermessage = Overhead .. ' the ' .. v.Name .. ' has been transfered to ' ..  Ordername 

							local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v)
							transfer = transfer - 1
							builder.OwnerID  = landfrom.OwnerPlayerID
							builder.ModData = modSign(0) .. payloadSplit[1] .. ';;'.. transfer .. ';;' .. payloadSplit[3].. ';;' .. payloadSplit[4].. ';;' .. payloadSplit[5].. ';;' .. payloadSplit[6].. ';;'.. (payloadSplit[7] or 0).. ';;'.. (payloadSplit[8] or 0) .. ';;' .. (payloadSplit[9] or 0) .. ';;' .. (payloadSplit[10] or 0).. ';;' .. (payloadSplit[11] or 0)

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
		local wassuccessful = result.IsSuccessful
		local NomoveList = nil
		local buildertalble = {}
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
							local payloadSplit = split(string.sub(v.ModData, 5), ';;')
							local levelamount = tonumber(payloadSplit[3])
							local XP = tonumber(payloadSplit[4])
							local unitpower = tonumber(payloadSplit[5]) or 0
							local currlevel = tonumber(payloadSplit[6])
							local unitdefence = tonumber(payloadSplit[7]) or 0
							local absoredDamage = (unitpower + unitdefence) / 2
							local altmove = tonumber(payloadSplit[8]) or 0
							local upkeep = tonumber(payloadSplit[11]) or 0

							if (result.DefendingArmiesKilled.DefensePower > 0)then -- making sure the attack actually had people who died
								if levelamount ~= 0 and levelamount ~= nil then -- making sure the level option is turned on

									XP = XP + result.DefendingArmiesKilled.DefensePower
									local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v)
									print (currlevel, "level", XP, 'XP')

									local skipper = string.len(payloadSplit[6]) + 4
									local namepayload = split(string.sub(builder.Name, skipper), ';');  -- removing part of the old name to replace

									if result.IsSuccessful == true then territory = order.To
									else territory = order.From end

									local terrMod = WL.TerritoryModification.Create(territory); -- adding it to territory logic
									local levelupmessage = (builder.TextOverHeadOpt or 0) .. ' the ' .. builder.Name .. ' Gained XP'
									if (XP >= levelamount) then -- resetting XP and level amount
										XP = 0 
										currlevel = currlevel + 1 

										levelamount = levelamount + (levelamount / currlevel)
										builder.AttackPower = builder.AttackPower + (builder.AttackPower / currlevel)
										builder.DefensePower = builder.DefensePower + (builder.DefensePower / currlevel)
										builder.DamageToKill = builder.DamageToKill + (absoredDamage / currlevel)
										builder.DamageAbsorbedWhenAttacked = builder.DamageAbsorbedWhenAttacked + (absoredDamage / currlevel)
										upkeep = upkeep + (upkeep / currlevel)
										levelupmessage = builder.TextOverHeadOpt .. ' the ' .. v.Name .. ' has leveled up!!!'

									end --starting XP over if level was reached

									builder.Name = "LV" .. currlevel .. ' ' .. namepayload[1]
									builder.ModData = modSign(0) .. payloadSplit[1] .. ';;'..payloadSplit[2] .. ';;'..levelamount .. ';;'.. XP .. ';;' .. unitpower .. ';;' .. currlevel.. ';;'.. (unitdefence or 0).. ';;'.. (payloadSplit[8] or 0) .. ';;' .. (payloadSplit[9] or 0) .. ';;' .. (payloadSplit[10] or 0).. ';;' .. (upkeep or 0)
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

		if #defendingspecialUnits > 0 and wassuccessful == false then

			for i, v in pairs(defendingspecialUnits) do -- checking to see if an attack had a special unit
				if v.proxyType == "CustomSpecialUnit" then -- making sure its a custom unit, not a commander or otherwise
					if v.ModData ~= nil then -- making sure it has data to read from

						if startsWith(v.ModData, modSign(0)) then -- make sure the speical unit is only from I.S. mod
							local dead = false

							for i2, v2 in pairs( result.DefendingArmiesKilled.SpecialUnits) do -- checking to see if he died
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
								local upkeep = tonumber(payloadSplit[11]) or 0

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
											builder.DamageToKill = builder.DamageToKill + (absoredDamage / currlevel)
											builder.DamageAbsorbedWhenAttacked = builder.DamageAbsorbedWhenAttacked + (absoredDamage / currlevel)
											upkeep = upkeep + (upkeep / currlevel)
											levelupmessage = builder.TextOverHeadOpt .. ' the ' .. v.Name .. ' has leveled up!!!'
										end --starting XP over if level was reached

										builder.Name = "LV" .. currlevel .. ' ' .. namepayload[1]
										builder.ModData = modSign(0) .. payloadSplit[1] .. ';;'..payloadSplit[2] .. ';;'..levelamount .. ';;'.. XP .. ';;' .. unitpower .. ';;' .. currlevel.. ';;'.. (unitdefence or 0).. ';;'.. (payloadSplit[8] or 0) .. ';;' .. (payloadSplit[9] or 0) .. ';;' .. (payloadSplit[10] or 0).. ';;' .. (payloadSplit[11] or 0)
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

function Evenmoves(game, order, result, skipThisOrder, addNewOrder)
	for i, v in pairs(result.ActualArmies.SpecialUnits) do -- checking to see if an attack had a special unit
		if v.proxyType == "CustomSpecialUnit" then -- making sure its a custom unit, not a commander or otherwise
			if v.ModData ~= nil then -- making sure it has data to read from
				if startsWith(v.ModData, "C&P") then -- make sure the speical unit is only from I.S. mod
					local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
					local altmove = tonumber(payloadSplit[8]) or 0
					if (altmove > 0 and isNotEven(Game2.Game.TurnNumber)) then
						local skipmessage = 'Moved order for this unit was skipped because its not an even turn'
						addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, skipmessage , {}, {}))-- remove from territory
						skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
						return false
					end
				end
			end
		end
	end
	return true
end
