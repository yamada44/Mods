require('Utilities')

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
	--Check if we see a Build Fort event.  If we do, add it to a global list that we'll check in BuildForts() below.
	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'FortX')) then  --look for the order that we inserted in Client_PresentMenuUI
		--Extract territory ID from the payload
		local terrID = tonumber(string.sub(order.Payload, 8))
		--Build the fort. We could add it with addNewOrder right here, but that would result in forts being built mid-turn, but we want them built at the end of the turn.  So instead add them to a list here, and we'll call addNewOrder for each in Server_AdvanceTurn_End
		local pendingFort = {}
		pendingFort.PlayerID = order.PlayerID
		pendingFort.Message = order.Message
		pendingFort.TerritoryID = terrID


		local priv = Mod.PublicGameData
		if (priv.PendingForts == nil) then priv.PendingForts = {} end
		table.insert(priv.PendingForts, pendingFort)
		Mod.PublicGameData = priv
		
	end

	--Check if this is an attack against a territory with a fort.
--Add attack details
	if (order.proxyType == 'GameOrderAttackTransfer' and result.IsAttack) then
		local terr = game.ServerGame.LatestTurnStanding.Territories[order.To] 
		--if result.IsSuccessful == true then terr = game.ServerGame.LatestTurnStanding.Territories[order.To]
		--else terr = game.ServerGame.LatestTurnStanding.Territories[order.From] end

		local structures = game.ServerGame.LatestTurnStanding.Territories[order.To].Structures
		
		--If no fort here, abort.
		if (structures == nil) then return end;
		if (structures[WL.StructureType.MercenaryCamp] == nil) then return end
		if (structures[WL.StructureType.MercenaryCamp] <= 0) then return end
		local totalbuilds = structures[WL.StructureType.MercenaryCamp] 

--Forts have troops built into them
		if Mod.Settings.Need > 0 or Mod.Settings.Need == -1 then

			--Forst double the amount of troops built into them
			local turnscale = 0
			if Mod.Settings.Scale > 0 then 
				turnscale = Howmany20(game.Game.TurnNumber)
			end
			local defendland = game.ServerGame.LatestTurnStanding.Territories[order.To]
			local NeededPower = Mod.Settings.Need + (turnscale * Mod.Settings.Scale)
			if Mod.Settings.Need == -1 then NeededPower = defendland.NumArmies.DefensePower end
			
			--Regular calculations
			if result.ActualArmies.AttackPower >= NeededPower then
				local removedbuilds = 0
				local leftover = 0
				if result.ActualArmies.AttackPower > (NeededPower * totalbuilds)then
					removedbuilds = totalbuilds
					leftover = result.ActualArmies.AttackPower - (NeededPower * totalbuilds)
				else
					removedbuilds = math.floor(result.ActualArmies.AttackPower / NeededPower)
				end
				--troop combat values
				local removedtroops = removedbuilds * NeededPower -- duel use of power needed and troops to remove (was not a good ideal)
				local SUremoved = {}

				--Adding SU value to calculations
				SUremoved = SUvalue(result.ActualArmies.SpecialUnits, removedtroops - result.ActualArmies.NumArmies)
				if result.ActualArmies.NumArmies < removedtroops then 

					local currentneed = removedtroops - SUremoved.totalpower 
					removedtroops = currentneed
					if currentneed <= 0 then leftover = 0 
					else
						leftover = result.ActualArmies.NumArmies - currentneed
					end
				else
					leftover = result.ActualArmies.NumArmies - removedtroops
				end

				structures[WL.StructureType.MercenaryCamp] = structures[WL.StructureType.MercenaryCamp] - removedbuilds
				result.ActualArmies = WL.Armies.Create(leftover,SUremoved.add)


				local bigmod = {}
				local mod = WL.TerritoryModification.Create(order.To) -- the defenders
				--mod.RemoveSpecialUnitsOpt = SUremoved
				mod.SetStructuresOpt = structures

				local mod2 = WL.TerritoryModification.Create(order.From) -- the attackers
				mod2.AddArmies = removedtroops * -1
				mod2.RemoveSpecialUnitsOpt = SUremoved.remove
				
				table.insert(bigmod,mod)
				table.insert(bigmod,mod2)
				addNewOrder(WL.GameOrderEvent.Create(game.ServerGame.LatestTurnStanding.Territories[order.From].OwnerPlayerID, removedbuilds .." Forts Destroyed", nil, bigmod))
	
				result.DefendingArmiesKilled = WL.Armies.Create(result.ActualArmies.AttackPower * game.Settings.OffenseKillRate )

			else -- if the attack is not enough to destroy 1 fort
				if (result.DefendingArmiesKilled.IsEmpty) then
					--A successful attack on a territory where no defending armies were killed must mean it was a territory defended by 0 armies.  In this case, we can't stop the attack by simply setting DefendingArmiesKilled to 0, since attacks against 0 are always successful.  So instead, we simply skip the entire attack.
					skipThisOrder(WL.ModOrderControl.Skip)
				else
					result.DefendingArmiesKilled = WL.Armies.Create(0)
				end
			end 
--Forts stop attacks
		elseif Mod.Settings.Need == 0 then -- Base Fort mod logic
			--Attack found against a fort!  Cancel the attack and remove the fort.
			
			structures[WL.StructureType.MercenaryCamp] = structures[WL.StructureType.MercenaryCamp] - 1

			local terrMod = WL.TerritoryModification.Create(order.To)
			terrMod.SetStructuresOpt = structures
			addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Destroyed a fort', {}, {terrMod}))

			if (result.DefendingArmiesKilled.IsEmpty) then
				--A successful attack on a territory where no defending armies were killed must mean it was a territory defended by 0 armies.  In this case, we can't stop the attack by simply setting DefendingArmiesKilled to 0, since attacks against 0 are always successful.  So instead, we simply skip the entire attack.
				skipThisOrder(WL.ModOrderControl.Skip)
			else
				result.DefendingArmiesKilled = WL.Armies.Create(0)
			end
		end
	end
	
end
function Server_AdvanceTurn_End(game, addNewOrder)
	BuildForts(game, addNewOrder)
	local pub = Mod.PublicGameData
	if pub.fortlocation == nil then pub.fortlocation = {} end
	

end

function BuildForts(game, addNewOrder)
	--Build any forts that we queued in up Server_AdvanceTurn_Order
	
	local priv = Mod.PublicGameData
	if priv.PendingForts == nil then return end
for i,v in pairs (priv.PendingForts) do
	local pending = v
	if (pending == nil) then return end
	local numUnitsAlreadyHave = 0
	local message = "Fort Build complete"

	-- Remove any pending builds where the player lost control of the territory, so we don't build a fort for the new owner
	for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do -- server side check to make sure builds are not above the Given amount
		if(ts.OwnerPlayerID == pending.PlayerID) then
		  numUnitsAlreadyHave = numUnitsAlreadyHave + Buildnumber(ts.Structures)
		end
	  end
	if numUnitsAlreadyHave > Mod.Settings.Maxhives then 
		addNewOrder(WL.GameOrderEvent.Create(pending.PlayerID, 'Already at Max Structure limit. cannot build'))
		return
	  end
 
	-- We will now build a fort for each pending fort.  However, we need to take care to ensure that if there are two build orders for the same territory that we build both of them, so we first group by the territory ID so we get all build orders for the same territory together.
	local mod = WL.TerritoryModification.Create(pending.TerritoryID)
    local struc = {}

    struc[WL.StructureType.MercenaryCamp] = 1
    mod.AddStructuresOpt = struc
	
	addNewOrder(WL.GameOrderEvent.Create(pending.PlayerID, message, nil, {mod}))
end

	priv.PendingForts = nil
	Mod.PublicGameData = priv
	
end
function SUvalue(SU,powerneeded)
	local SUdata = {remove = {},add = {},totalpower = 0}
	local currentpower = 0
	for i,v in pairs(SU)do
		if v.proxyType == "CustomSpecialUnit" and v.proxyType ~= "Commander" then
			currentpower = currentpower + v.AttackPower 

			if currentpower > powerneeded  and (i ~= 1 or (powerneeded <= 0)) then

				table.insert(SUdata.add,v)
			else
				table.insert(SUdata.remove,v.ID)
				SUdata.totalpower = SUdata.totalpower + v.AttackPower 
			end
		end

	end
	
	return SUdata
end