require('Utilities');

function Server_AdvanceTurn_Start(game, addNewOrder)
	local i = 1000
	while i ~= 100 do
		 i = i + 1 
--Sprint ( game.Map.Territories[i].Name, 'name')
if startsWith(game.Map.Territories[i].Name, 'Western')then
local mod = WL.TerritoryModification.Create(i)
	mod.SetOwnerOpt  = 1	
	local UnitdiedMessage = ''

	addNewOrder(WL.GameOrderEvent.Create(0, UnitdiedMessage, nil, {mod}));
end
end
	



								
	Game1 = game
print('phase 1', "main function has been entered")
	for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do


			for i,v in pairs (ts.NumArmies.SpecialUnits)do -- search all Territories and see if it has a speical unit
				print('phase 2', "does have speical unit")
				if v.proxyType == "CustomSpecialUnit" then
					if v.ModData ~= nil then -- 
						if startsWith(v.ModData, 'C&P') then -- make sure the speical unit is only from I.S. mods
							print('phase 3', "unit is from I.S. mods")
							local payloadSplit = split(string.sub(v.ModData, 4), ';;'); 
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
	
	
end




function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
		
	
	if order.proxyType == "GameOrderAttackTransfer" and result.IsAttack then 
		Game2 = game


		for i, v in pairs(result.ActualArmies.SpecialUnits) do -- checking to see if an attack had a special unit
			if v.proxyType == "CustomSpecialUnit" then -- making sure its a custom unit, not a commander or otherwise
				if v.ModData ~= nil then -- making sure it has data to read from

					if startsWith(v.ModData, 'C&P') then -- make sure the speical unit is only from I.S. mods
						if (result.DefendingArmiesKilled.DefensePower > 0)then -- making sure the attack actually had people who died
							local payloadSplit = split(string.sub(v.ModData, 4), ';;'); 
							local levelamount = tonumber(payloadSplit[3])
							local XP = tonumber(payloadSplit[4])
							local unitpower = tonumber(payloadSplit[5])
							local currlevel = tonumber(payloadSplit[6])
							local unitdefence = tonumber(payloadSplit[7])
							local absoredDamage = AbsoredDecider(unitpower,unitdefence)

							if levelamount ~= 0 and levelamount ~= nil then -- making sure the level option is turned on

								XP = XP + result.DefendingArmiesKilled.DefensePower
								local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v);
								local territory = nil
								local dead = false
								print (currlevel, "level", XP, 'XP')

								local skipper = string.len(payloadSplit[6]) + 4
								local namepayload = split(string.sub(builder.Name, skipper), ';');  -- removing part of the old name to replace
								print(skipper,'skipper')


								for i, v2 in pairs( result.AttackingArmiesKilled.SpecialUnits) do -- checking to see if he died
									if v.ID == v2.ID then
										dead = true
									end
								end
								if dead == false then

									if result.IsSuccessful == true then territory = order.To
									else territory = order.From end
	
									local terrMod = WL.TerritoryModification.Create(territory); -- adding it to territory logic
									local levelupmessage = builder.TextOverHeadOpt .. ' the ' .. builder.Name .. ' Gained XP'
									if (XP >= levelamount) then -- resetting XP and level amount
										XP = 0 
										currlevel = currlevel + 1 
										levelamount = levelamount * (currlevel + 2 )
										builder.AttackPower = builder.AttackPower + unitpower
										builder.DefensePower = unitdefence;
										builder.DamageToKill = absoredDamage;
										builder.DamageAbsorbedWhenAttacked = absoredDamage;
										levelupmessage = builder.TextOverHeadOpt .. ' the ' .. v.Name .. ' has leveled up!!!'
									end --starting XP over if level was reached
										


									builder.Name = "LV" .. currlevel .. ' ' .. namepayload[1]
									builder.ModData = 'C&P' .. payloadSplit[1] .. ';;'..payloadSplit[2] .. ';;'..levelamount .. ';;'.. XP .. ';;' .. unitpower .. ';;' .. currlevel.. ';;'.. payloadSplit[7]
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



		Specialunitdeathlogic(game, order, result, skipThisOrder, addNewOrder)
      
	end



	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'C&P')) then  --look for the order that we inserted in Client_PresentCommercePurchaseUI
		print (order.Payload, 'payload')	
		local publicdata = Mod.PublicGameData

		local payloadSplit = split(string.sub(order.Payload, 6), ';;'); 



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



		local MaxUnitsEver = Mod.Settings.Unitdata[type].MaxServer
		local ID = order.PlayerID
		local minlife = Mod.Settings.Unitdata[type].Minlife
		local maxlife = Mod.Settings.Unitdata[type].Maxlife
		local Turnkilled = 0
		local addedwords = ''
		local transfer = 0
		local levelamount = 0
		local currentxp = 0
		local defence = 0
		if (Mod.Settings.Unitdata[type].Transfer ~= nil)then -- adding values after mod launched
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
		
		elseif (publicdata[type][ID].CurrEver >= unitmax) then
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping '.. typename ..' purchase. you have reached the total Game limit for yourself which is ' .. unitmax));
			return; --this player already has the maximum number of Units possible of this type, so skip adding a new one.
				
		elseif (publicdata[type].CurrEver >= unitmax) then
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Skipping '.. typename ..' purchase since the Max amount for the server is ' .. unitmax .. '. the Game has reached its limit set by host'));
			return; --this player already has the maximum number of Units possible of this type, so skip adding a new one.
		end

		local filename = Filefinder(image) -- sort through images to find the correct one

		if (maxlife ~= 0)then
		Turnkilled = math.random(minlife,maxlife) + game.Game.TurnNumber 
		addedwords =  '\nLife ends on Turn: ' .. Turnkilled
		end
		if (levelamount > 0)then
			typename = 'LV0 ' .. typename
		end
		
		-- for 'DamageAbsorbedWhenAttacked'. this value is deicded between attackpower and defence power. which ever is IsVersionOrHigher

		local absoredDamage = AbsoredDecider(unitpower,defence)


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
		builder.ModData = 'C&P' .. Turnkilled .. ';;' .. transfer .. ';;' .. levelamount .. ';;' .. currentxp .. ';;' .. unitpower .. ';;' .. 0 .. ';;'.. defence-- last number is level
	
		print (defence, 'defence power')
		print (unitpower, 'attack power')
		print(absoredDamage, 'absored')

		local terrMod = WL.TerritoryModification.Create(targetTerritoryID);
		terrMod.AddSpecialUnits = {builder.Build()};

		
		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a '.. typename .. addedwords, nil, {terrMod}));
		
		--create a layer of playerID (prob change everything from publicdata to playerdata with id)
		if (MaxUnitsEver == true and shared == false)then
		publicdata[type][ID].CurrEver = publicdata[type][ID].CurrEver + 1 
			
		elseif (MaxUnitsEver == true and shared == true)then
		publicdata[type].CurrEver = publicdata[type].CurrEver + 1 end

		

		
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

function Filefinder(image)
local filestorage = {}

	filestorage[1] = 'pack 1.a.png'
	filestorage[2] = 'pack 1.b.png'
	filestorage[3] = 'pack 1.c.png'
	filestorage[4] = 'pack 1.d.png'
	filestorage[5] = 'pack 1.e.png'

return filestorage[image]
end

function Specialunitdeathlogic(game, order, result, skipThisOrder, addNewOrder)
	if #result.AttackingArmiesKilled.SpecialUnits > 0  then -- when a unit dies from attacking. 

		local armiesKilled = result.AttackingArmiesKilled 
		local specialUnitKilled = armiesKilled.SpecialUnits
		local land = Game2.ServerGame.LatestTurnStanding.Territories[order.To]

		for i,v in pairs (specialUnitKilled)do
			if v.ModData ~= nil then 
				if v.TextOverHeadOpt == nil then v.TextOverHeadOpt = '' end

			local UnitKilledMessage = Game2.Game.Players[order.PlayerID].DisplayName(nil,false) .. ':\n' ..
				  v.TextOverHeadOpt .. ' the ' .. v.Name .. ' has perished in battle'   
				
				  local payloadSplit = split(string.sub(v.ModData, 4), ';;'); 
				  local transfer = tonumber(payloadSplit[2])
				if (transfer ~= 0 and land.OwnerPlayerID ~= 0 and transfer ~= nil)then
					local transfermessage = 'A ' .. v.Name .. ' has been transfered to ' ..  Game2.Game.Players[land.OwnerPlayerID].DisplayName(nil,false)
					
						local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v);
						transfer = transfer - 1
						builder.OwnerID  = land.OwnerPlayerID
						builder.ModData = 'C&P' .. payloadSplit[1] .. ';;'.. transfer .. ';;' .. payloadSplit[3].. ';;' .. payloadSplit[4].. ';;' .. payloadSplit[5].. ';;' .. payloadSplit[6].. ';;'.. payloadSplit[7]

						local terrMod = WL.TerritoryModification.Create(order.To);
						terrMod.AddSpecialUnits = {builder.Build()};
						addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, transfermessage, nil, {terrMod}));
						 
				else
					addNewOrder(WL.GameOrderEvent.Create(land.OwnerPlayerID , UnitKilledMessage , nil,nil,nil ,{} ))

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
			if v.ModData ~= nil then 

			if v.TextOverHeadOpt == nil then v.TextOverHeadOpt = '' end

			local UnitKilledMessage = Game2.Game.Players[land.OwnerPlayerID].DisplayName(nil,false) .. ':\n' ..
				  v.TextOverHeadOpt .. ' the ' .. v.Name .. ' has perished in battle' 

				  local payloadSplit = split(string.sub(v.ModData, 4), ';;'); 
				  local transfer = tonumber(payloadSplit[2])
				  if (transfer ~= 0 and transfer ~= nil)then
					local transfermessage = 'A ' .. v.Name .. ' has been transfered to ' ..  Game2.Game.Players[landfrom.OwnerPlayerID].DisplayName(nil,false)

					local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v);
					transfer = transfer - 1
					builder.OwnerID  = landfrom.OwnerPlayerID
					builder.ModData = 'C&P' .. payloadSplit[1] .. ';;'.. transfer .. ';;' .. payloadSplit[3].. ';;' .. payloadSplit[4].. ';;' .. payloadSplit[5].. ';;' .. payloadSplit[6].. ';;'.. payloadSplit[7]

					local terrMod = WL.TerritoryModification.Create(order.To);
					terrMod.AddSpecialUnits = {builder.Build()};
					addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, transfermessage, nil, {terrMod}));

				else
					addNewOrder(WL.GameOrderEvent.Create(landfrom.OwnerPlayerID , UnitKilledMessage , nil,nil,nil ,{} ))

				end

			end
		end
	end
	end

function AbsoredDecider(attack, defence)
	local higher
	if attack > defence then higher = attack
	else higher = defence end

	return higher
end