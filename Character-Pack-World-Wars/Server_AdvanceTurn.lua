require('Utilities');

function Server_AdvanceTurn_Start(game, addNewOrder)
								
	Game1 = game

	--if (Mod.Settings.corefeature ~= nil or Mod.Settings.corefeature == false) then
	print('phase 1', "main function has been entered")
		for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do


				for i,v in pairs (ts.NumArmies.SpecialUnits)do -- search all Territories and see if it has a speical unit
					print('phase 2', "does have speical unit")
					if v.proxyType == "CustomSpecialUnit" then
						if v.ModData ~= nil then -- 
							if startsWith(v.ModData, ModSign(0)) then -- make sure the speical unit is only from I.S. mods
								print('phase 3', "unit is from I.S. mods")
								local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
								local diebitch = tonumber(payloadSplit[1])

								if diebitch <= Game1.Game.TurnNumber and diebitch ~= 0 then -- check if this unit has expired in life, if yes, then destroy it
									print('phase 4', "killing unit via life")
									local mod = WL.TerritoryModification.Create(ts.ID)
									t = {}
									table.insert(t, v.ID);
									print(v.Name)
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
		

		if order.proxyType == "GameOrderAttackTransfer" and result.IsAttack then 
			Game2 = game

			LevelupLogic(game, order, result, skipThisOrder, addNewOrder)

			Deathlogic(game, order, result, skipThisOrder, addNewOrder)

		end



      




	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, ModSign(0))) then  --look for the order that we inserted in Client_PresentCommercePurchaseUI
		
		print (order.Payload, 'payload')	
		local publicdata = Mod.PublicGameData

		local payloadSplit = split(string.sub(order.Payload, 7), ';;'); 


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
		local cooldown = Nonill(Mod.Settings.Unitdata[type].Cooldown)
		local assass = Nonill(Mod.Settings.Unitdata[type].Assassination)

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
				numUnitsAlreadyHave = numUnitsAlreadyHave + NumUnitsIn(ts.NumArmies, typename);
							
			elseif(ts.OwnerPlayerID == order.PlayerID) then
				numUnitsAlreadyHave = numUnitsAlreadyHave + NumUnitsIn(ts.NumArmies, typename);				
			end
		end
		

		
	--skipping logic if any settings are set to limit the amount of units on field at a given time
		if (numUnitsAlreadyHave >= unitmax) then
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping '.. typename ..' purchase since max is ' .. unitmax .. ' and you have ' .. numUnitsAlreadyHave));
			return; --this player already has the maximum number of Units possible of this type, so skip adding a new one.
		
		elseif (publicdata[type][ID].CurrEver >= MaxUnitsEver and MaxUnitsEver ~= -1) then
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping '.. typename ..' purchase. you have reached the games spawnable amount which is ' .. MaxUnitsEver));
			return; --this player already has the maximum number of Units possible of this type, so skip adding a new one.
				
		elseif (publicdata[type].CurrEver >= MaxUnitsEver and MaxUnitsEver ~= -1) then
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping '.. typename ..' purchase since the Max amount for the server is ' .. MaxUnitsEver .. '. the Game has reached its spawnable amount set by host'));
			return; --the server has already has the maximum number of Units possible of this type, so skip adding a new one.
		end

		local filename = Filefinder(image) -- sort through images to find the correct one

		if (maxlife ~= 0)then
		Turnkilled = math.random(minlife,maxlife) + game.Game.TurnNumber 
		addedwords =  '\nLife ends on Turn: ' .. Turnkilled
		end
		if Mod.Settings.Unitdata[type].AttackMax ~= nil and Mod.Settings.Unitdata[type].AttackMax > unitpower then
			addedwords2 = '\nAttack power: ' .. unitpower
		end
		if (levelamount > 0)then
			typename = 'LV0 ' .. typename
		end
		
		-- for 'DamageAbsorbedWhenAttacked'. this value is deicded between attackpower and defence power. which ever is IsVersionOrHigher

		local absoredDamage = AbsoredDecider(unitpower,defence)
		local startinglevel = 0

		local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID);
		builder.Name = typename;
		builder.IncludeABeforeName = true;
		builder.ImageFilename = filename;
		builder.AttackPower = unitpower;
		builder.DefensePower = defence;
		builder.CombatOrder = 3415; --defends commanders
		builder.DamageToKill = absoredDamage;
		builder.DamageAbsorbedWhenAttacked = absoredDamage;
		builder.CanBeGiftedWithGiftCard = true;
		builder.CanBeTransferredToTeammate = true;
		builder.CanBeAirliftedToSelf = true;
		builder.CanBeAirliftedToTeammate = true;
		builder.TextOverHeadOpt = charactername
		builder.IsVisibleToAllPlayers = visible;
		builder.ModData = ModSign(0) .. Turnkilled .. ';;' .. transfer .. ';;' .. levelamount .. ';;' .. currentxp .. ';;' .. unitpower .. ';;' .. startinglevel .. ';;'.. defence .. ';;'.. altmove .. ';;'.. assass
	
		print (defence, 'defence power')
		print (unitpower, 'attack power')
		print(absoredDamage, 'absored')

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

function NumUnitsIn(armies, typename)
	local ret = 0;
	for _,su in pairs(armies.SpecialUnits) do
		if (su.proxyType == 'CustomSpecialUnit' and su.Name == typename) then
			ret = ret + 1;
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
					local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v);
					if v.TextOverHeadOpt == nil then builder.TextOverHeadOpt = '' end

				local UnitKilledMessage = Game2.Game.Players[order.PlayerID].DisplayName(nil,false) .. ':\n' ..
				builder.TextOverHeadOpt .. ' the ' .. v.Name .. ' has perished in battle'   
					
					local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
					local transfer = tonumber(payloadSplit[2]) 
					if (transfer ~= 0 and land.OwnerPlayerID ~= 0 and transfer ~= nil)then
						local transfermessage = v.TextOverHeadOpt .. ' the ' .. v.Name .. ' has been transfered to ' ..  Game2.Game.Players[land.OwnerPlayerID].DisplayName(nil,false)
						
							transfer = transfer - 1
							builder.OwnerID  = land.OwnerPlayerID
							builder.ModData = ModSign(0) .. payloadSplit[1] .. ';;'.. transfer .. ';;' .. payloadSplit[3].. ';;' .. payloadSplit[4].. ';;' .. payloadSplit[5].. ';;' .. payloadSplit[6].. ';;'.. Nonill(payloadSplit[7]).. ';;'.. Nonill(payloadSplit[8]) .. ';;' .. Nonill(payloadSplit[9])

							local terrMod = WL.TerritoryModification.Create(order.To);
							terrMod.AddSpecialUnits = {builder.Build()};
							addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, transfermessage, nil, {terrMod}));
							
					else
						addNewOrder(WL.GameOrderEvent.Create(order.PlayerID , UnitKilledMessage , nil,nil,nil ,{} ))

					end
				end
			end
		end  
	end
	if (#result.DefendingArmiesKilled.SpecialUnits > 0) then -- when a unit dies from defending

		local armiesKilled = result.DefendingArmiesKilled 	
		local specialUnitKilled = armiesKilled.SpecialUnits
		local land = Game2.ServerGame.LatestTurnStanding.Territories[order.To]
		local landfrom = Game2.ServerGame.LatestTurnStanding.Territories[order.From]

		for i,v in pairs (specialUnitKilled)do
			if v.proxyType == "CustomSpecialUnit" then
				if v.ModData ~= nil then 

				if v.TextOverHeadOpt == nil then v.TextOverHeadOpt = '' end

				local UnitKilledMessage = Game2.Game.Players[land.OwnerPlayerID].DisplayName(nil,false) .. ':\n' ..
					v.TextOverHeadOpt .. ' the ' .. v.Name .. ' has perished in battle' 

					local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
					local transfer = tonumber(payloadSplit[2])

					if (transfer ~= 0 and transfer ~= nil)then
						local transfermessage = v.TextOverHeadOpt .. ' the ' .. ' has been transfered to ' ..  Game2.Game.Players[landfrom.OwnerPlayerID].DisplayName(nil,false)

						local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v);
						transfer = transfer - 1
						builder.OwnerID  = landfrom.OwnerPlayerID
						builder.ModData = ModSign(0) .. payloadSplit[1] .. ';;'.. transfer .. ';;' .. payloadSplit[3].. ';;' .. payloadSplit[4].. ';;' .. payloadSplit[5].. ';;' .. payloadSplit[6].. ';;'.. Nonill(payloadSplit[7]).. ';;'.. Nonill(payloadSplit[8]) .. ';;' .. Nonill(payloadSplit[9])

						local terrMod = WL.TerritoryModification.Create(order.To);
						terrMod.AddSpecialUnits = {builder.Build()};
						addNewOrder(WL.GameOrderEvent.Create(land.OwnerPlayerID, transfermessage, nil, {terrMod}));

					else
						addNewOrder(WL.GameOrderEvent.Create(land.OwnerPlayerID , UnitKilledMessage , nil,nil,nil ,{} ))

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


		for i, v in pairs(result.ActualArmies.SpecialUnits) do -- checking to see if an attack had a special unit
			if v.proxyType == "CustomSpecialUnit" then -- making sure its a custom unit, not a commander or otherwise
				if v.ModData ~= nil then -- making sure it has data to read from

					if startsWith(v.ModData, ModSign(0)) then -- make sure the speical unit is only from I.S. mod
						local dead = false
						local territory = nil 
						for i2, v2 in pairs( result.AttackingArmiesKilled.SpecialUnits) do -- checking to see if he died
							if v.ID == v2.ID then
								dead = true
							end
						end
						if dead == false then
							print (v.ModData)
							local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
							local levelamount = tonumber(payloadSplit[3])
							local XP = tonumber(payloadSplit[4])
							local unitpower = tonumber(Nonill(payloadSplit[5]))
							local currlevel = tonumber(payloadSplit[6])
							local unitdefence = Nonill(tonumber(payloadSplit[7]))
							print (unitdefence, "unit defense")
							local absoredDamage = AbsoredDecider(unitpower,unitdefence)
							local altmove = Nonill(tonumber(payloadSplit[8]))
print (altmove,'altmove')
							local iswholenumber = true

							--move unit every other turne
							if (altmove > 0)then
								iswholenumber = Iswhole(Game2.Game.TurnNumber)
								if iswholenumber == false then

									local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v);
									local s = {}

									local terrMod = WL.TerritoryModification.Create(order.From); -- adding it to territory logic
									local terrNomove = WL.TerritoryModification.Create(order.To); -- adding it to territory logic

									table.insert(s,v.ID)

									terrNomove.RemoveSpecialUnitsOpt = {v.ID}
									--terrMod.AddSpecialUnits = {builder.Build()};

									local skipmessage = 'Moved order for this unit was skipped because its not an even turn'
									addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, skipmessage , nil, {terrNomove}));
									--addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, skipmessage , nil, {terrMod}));
									addNewOrder(WL.GameOrderAttackTransfer.Create(order.PlayerID,order.To,order.From,1,false,Game2.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies,false))

								skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
								end

							end
							if (result.DefendingArmiesKilled.DefensePower > 0 and iswholenumber == true)then -- making sure the attack actually had people who died
								if levelamount ~= 0 and levelamount ~= nil then -- making sure the level option is turned on

									XP = XP + result.DefendingArmiesKilled.DefensePower
									local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v);
								
									print (currlevel, "level", XP, 'XP')

									local skipper = string.len(payloadSplit[6]) + 4
									local namepayload = split(string.sub(builder.Name, skipper), ';');  -- removing part of the old name to replace
									print(skipper,'skipper')

									if result.IsSuccessful == true then territory = order.To
									else territory = order.From end

									local terrMod = WL.TerritoryModification.Create(territory); -- adding it to territory logic
									local levelupmessage = Nonill(builder.TextOverHeadOpt) .. ' the ' .. builder.Name .. ' Gained XP'
									if (XP >= levelamount) then -- resetting XP and level amount
										XP = 0 
										currlevel = currlevel + 1 

										levelamount = levelamount + Baseamount(levelamount, currlevel)
										builder.AttackPower = builder.AttackPower + Baseamount(builder.AttackPower, currlevel)
										builder.DefensePower = unitdefence + Baseamount(builder.DefensePower, currlevel);
										builder.DamageToKill = absoredDamage + Baseamount(absoredDamage, currlevel);
										builder.DamageAbsorbedWhenAttacked = absoredDamage + Baseamount(builder.DamageAbsorbedWhenAttacked, currlevel)
										levelupmessage = builder.TextOverHeadOpt .. ' the ' .. v.Name .. ' has leveled up!!!'
									end --starting XP over if level was reached
										


									builder.Name = "LV" .. currlevel .. ' ' .. namepayload[1]
									builder.ModData = ModSign(0) .. payloadSplit[1] .. ';;'..payloadSplit[2] .. ';;'..levelamount .. ';;'.. XP .. ';;' .. unitpower .. ';;' .. currlevel.. ';;'.. Nonill(unitdefence).. ';;'.. Nonill(payloadSplit[8]) .. ';;' .. Nonill(payloadSplit[9])
									print (v.ModData)
									print (builder.ModData)
									print (builder.AttackPower)
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
			print('defending special units found')

			for i, v in pairs(defendingspecialUnits) do -- checking to see if an attack had a special unit
				if v.proxyType == "CustomSpecialUnit" then -- making sure its a custom unit, not a commander or otherwise
					if v.ModData ~= nil then -- making sure it has data to read from

						if startsWith(v.ModData, ModSign(0)) then -- make sure the speical unit is only from I.S. mod
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
								local unitpower = tonumber(Nonill(payloadSplit[5]))
								local currlevel = tonumber(payloadSplit[6])
								local unitdefence = Nonill(tonumber(payloadSplit[7]))
								print (unitdefence, "unit defense")
								local absoredDamage = AbsoredDecider(unitpower,unitdefence)
								local altmove = Nonill(tonumber(payloadSplit[8]))
								local iswholenumber = true
								local territory = order.To

								--move unit every other turne (this was commented out because its not moving. so should still gain the affects of it)
								--[[if (altmove > 0)then
									--iswholenumber = Iswhole(Game2.Game.TurnNumber)
									if iswholenumber == false then
										local skipmessage = 'Moved order for this unit was skipped because its not an even turn'
										addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, skipmessage , nil, nil, nil, {}));

									--skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage); 
									end

								end]]--

								if (result.AttackingArmiesKilled.AttackPower  > 0 and iswholenumber == true)then -- making sure the attack actually had people who died
									if levelamount ~= 0 and levelamount ~= nil then -- making sure the level option is turned on

										XP = XP + result.AttackingArmiesKilled.AttackPower
										local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v);
									
										print (currlevel, "level", XP, 'XP')

										local skipper = string.len(payloadSplit[6]) + 4
										local namepayload = split(string.sub(builder.Name, skipper), ';');  -- removing part of the old name to replace

										local terrMod = WL.TerritoryModification.Create(territory); -- adding it to territory logic
										local levelupmessage = Nonill(builder.TextOverHeadOpt) .. ' the ' .. builder.Name .. ' Gained XP'
										if (XP >= levelamount) then -- resetting XP and level amount
											XP = 0 
											currlevel = currlevel + 1 

											levelamount = levelamount + Baseamount(levelamount, currlevel)
											builder.AttackPower = builder.AttackPower + Baseamount(builder.AttackPower, currlevel)
											builder.DefensePower = unitdefence + Baseamount(builder.DefensePower, currlevel);
											builder.DamageToKill = absoredDamage + Baseamount(absoredDamage, currlevel);
											builder.DamageAbsorbedWhenAttacked = absoredDamage + Baseamount(builder.DamageAbsorbedWhenAttacked, currlevel)
											levelupmessage = builder.TextOverHeadOpt .. ' the ' .. v.Name .. ' has leveled up!!!'
										end --starting XP over if level was reached
											


										builder.Name = "LV" .. currlevel .. ' ' .. namepayload[1]
										builder.ModData = ModSign(0) .. payloadSplit[1] .. ';;'..payloadSplit[2] .. ';;'..levelamount .. ';;'.. XP .. ';;' .. unitpower .. ';;' .. currlevel.. ';;'.. Nonill(unitdefence).. ';;'.. Nonill(payloadSplit[8]) .. ';;' .. Nonill(payloadSplit[9])
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

