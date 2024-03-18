require('Utilities');

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
	--Check if we see a Build Fort event.  If we do, add it to a global list that we'll check in BuildForts() below.
	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'FortX')) then  --look for the order that we inserted in Client_PresentMenuUI
		--Extract territory ID from the payload
		local terrID = tonumber(string.sub(order.Payload, 8))


		local playerData = Mod.PlayerGameData

		--Deduct one fort from their total
		playerData[order.PlayerID] = true
		Mod.PlayerGameData = playerData

		--Build the fort. We could add it with addNewOrder right here, but that would result in forts being built mid-turn, but we want them built at the end of the turn.  So instead add them to a list here, and we'll call addNewOrder for each in Server_AdvanceTurn_End
		local pendingFort = {}
		pendingFort.PlayerID = order.PlayerID
		pendingFort.Message = order.Message
		pendingFort.TerritoryID = terrID


		local priv = Mod.PrivateGameData
		if (priv.PendingForts == nil) then priv.PendingForts = {} end
		table.insert(priv.PendingForts, pendingFort)
		Mod.PrivateGameData = priv
		skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage); --skip this order just to avoid clutter in the orders list, since our GameOrderEvent will serve as the message.
	end

	--Check if this is an attack against a territory with a fort.
--Add attack details
	if (order.proxyType == 'GameOrderAttackTransfer' and result.IsAttack) then
		local structures = game.ServerGame.LatestTurnStanding.Territories[order.To].Structures;

		--If no fort here, abort.
		if (structures == nil) then return end;
		if (structures[WL.StructureType.MercenaryCamp] == nil) then return end
		if (structures[WL.StructureType.MercenaryCamp] <= 0) then return end

		--Attack found against a fort!  Cancel the attack and remove the fort.
		structures[WL.StructureType.MercenaryCamp] = structures[WL.StructureType.MercenaryCamp] - 1

		local terrMod = WL.TerritoryModification.Create(order.To)
		terrMod.SetStructuresOpt = structures
		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Destroyed a fort', {}, {terrMod}))


		if (result.DefendingArmiesKilled.IsEmpty) then
			--A successful attack on a territory where no defending armies were killed must mean it was a territory defended by 0 armies.  In this case, we can't stop the attack by simply setting DefendingArmiesKilled to 0, since attacks against 0 are always successful.  So instead, we simply skip the entire attack.
			skipThisOrder(WL.ModOrderControl.Skip);
		else
			result.DefendingArmiesKilled = WL.Armies.Create(0);
		end

	end
end
function Server_AdvanceTurn_End(game, addNewOrder)
	BuildForts(game, addNewOrder)
	AlterArmy(game,addNewOrder)
end

function BuildForts(game, addNewOrder)
	--Build any forts that we queued in up Server_AdvanceTurn_Order
	
	local priv = Mod.PrivateGameData
	local pending = priv.PendingForts
	if (pending == nil) then return end
	local numUnitsAlreadyHave = 0

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
	
	addNewOrder(WL.GameOrderEvent.Create(pending.PlayerID, pending.Message, nil, {mod}));
	

	priv.PendingForts = nil;
	Mod.PrivateGameData = priv;
end

function AlterArmy(game,addNewOrder)
	
end