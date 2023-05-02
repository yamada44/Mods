require('Utilities');

function Server_AdvanceTurn_Start(game, addNewOrder)

	Game1 = game
print('phase 1')
	for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do


			for i,v in pairs (ts.NumArmies.SpecialUnits)do -- search all Territories and see if it has a speical unit
				print('phase 2')
				if v.proxyType == "CustomSpecialUnit" then
					if v.ModData ~= nil then -- 
						if startsWith(v.ModData, 'C&P') then -- make sure the speical unit is only from I.S. mods
							print('phase 3')
							local diebitch = tonumber(string.sub(v.ModData, 4))
							print (diebitch, Game1.Game.TurnNumber, v.ModData)
							if diebitch <= Game1.Game.TurnNumber and diebitch ~= 0 then -- check if this unit has expired in life, if yes, then destroy it
								print('phase 4')
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


        if #result.AttackingArmiesKilled.SpecialUnits > 0  then

			local armiesKilled = result.AttackingArmiesKilled 
			local specialUnitKilled = armiesKilled.SpecialUnits

			for i,v in pairs (specialUnitKilled)do
				if v.ModData ~= nil then 
					if v.TextOverHeadOpt == nil then v.TextOverHeadOpt = '' end

				local UnitKilledMessage = Game2.Game.Players[order.PlayerID].DisplayName(nil,false) .. ':\n ' ..
					  v.TextOverHeadOpt .. ' the ' .. v.Name .. ' has perished in battle'   

					addNewOrder(WL.GameOrderEvent.Create(order.PlayerID , UnitKilledMessage , nil,nil,nil ,{} ))
				end
			end
			  
		end
		if (#result.DefendingArmiesKilled.SpecialUnits > 0) then

			local armiesKilled = result.DefendingArmiesKilled 	
			local specialUnitKilled = armiesKilled.SpecialUnits
			local land = Game2.ServerGame.LatestTurnStanding.Territories[order.To]

			for i,v in pairs (specialUnitKilled)do
				if v.ModData ~= nil then 

				if v.TextOverHeadOpt == nil then v.TextOverHeadOpt = '' end

				local UnitKilledMessage = Game2.Game.Players[land.OwnerPlayerID].DisplayName(nil,false) .. ':\n ' ..
					  v.TextOverHeadOpt .. ' the ' .. v.Name .. ' has perished in battle' 
 
					addNewOrder(WL.GameOrderEvent.Create(land.OwnerPlayerID , UnitKilledMessage , nil,nil,nil ,{} ))
				end
			end
		end



	end


	
	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'C&P')) then  --look for the order that we inserted in Client_PresentCommercePurchaseUI

		local publicdata = Mod.PublicGameData
	

		local payloadSplit = split(string.sub(order.Payload, 6), ','); 
		local targetTerritoryID = tonumber(payloadSplit[1])
		local charactername = payloadSplit[2]
		local unittype = tonumber(payloadSplit[3])
		local unitpower = tonumber(payloadSplit[4])
		local typename = payloadSplit[5]
		local unitmax = tonumber(payloadSplit[6])
		local image = tonumber(payloadSplit[7])
		local shared = payloadSplit[8]
		local visible = payloadSplit[9]
		local type = nil
		if (visible == 'true') then visible = true -- turning these varibles back into bools after converting them into strings
		else visible = false end
		if (shared == 'true') then shared = true
		else shared = false end

if unittype == 1 then local u = Mod.Settings.Unitdata[unittype].MaxServer end 
if unittype == 2 then local u = Mod.Settings.Unitdata[unittype].MaxServer end 
if unittype == 3 then local u = Mod.Settings.Unitdata[unittype].MaxServer end 
if unittype == 4 then local u =  Mod.Settings.Unitdata[unittype].MaxServer end 
if unittype == 5 then local u =  Mod.Settings.Unitdata[unittype].MaxServer end
if unittype == 6 then local u =  Mod.Settings.Unitdata[unittype].MaxServer end
if unittype == nil then local u =  Mod.Settings.Unitdata[unittype].MaxServer end

if unittype > 20 then local u =  Mod.Settings.Unitdata[unittype].MaxServer end
if unittype < 0 then local u =  Mod.Settings.Unitdata[unittype].MaxServer  

 
	else  local u =  Mod.Settings.Unitdata[unittype].MaxServer end 





		local MaxUnitsEver = Mod.Settings.Unitdata[unittype].MaxServer
		local ID = order.PlayerID
		local minlife = Mod.Settings.Unitdata[unittype].Minlife
		local maxlife = Mod.Settings.Unitdata[unittype].Maxlife
		local Turnkilled = 0
		local addedwords = ''

		--tracking the max amount between all players
		if publicdata[type] == nil then publicdata[type] = {} end
		if publicdata[type][ID] == nil then publicdata[type][ID] = {} end 
		if publicdata[type][ID].CurrEver == nil then publicdata[type][ID].CurrEver = 0 end
		if publicdata[type].CurrEver == nil then publicdata[type].CurrEver = 0 end


		print (order.Payload)


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



		local builder = WL.CustomSpecialUnitBuilder.Create(order.PlayerID);
		builder.Name = typename;
		builder.IncludeABeforeName = true;
		builder.ImageFilename = filename;
		builder.AttackPower = unitpower;
		builder.DefensePower = unitpower;
		builder.CombatOrder = 3415; --defends commanders
		builder.DamageToKill = unitpower;
		builder.DamageAbsorbedWhenAttacked = unitpower;
		builder.CanBeGiftedWithGiftCard = true;
		builder.CanBeTransferredToTeammate = true;
		builder.CanBeAirliftedToSelf = true;
		builder.CanBeAirliftedToTeammate = true;
		builder.TextOverHeadOpt = charactername
		builder.IsVisibleToAllPlayers = visible;
		builder.ModData = 'C&P' .. Turnkilled
	
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
