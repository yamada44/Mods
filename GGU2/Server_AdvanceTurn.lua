require('Utilities')

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
	local publicgamedata = Mod.PublicGameData

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'GiftGold2')) then  --look for the order that we inserted in Client_PresentMenuUI
		skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage); 
		--we replaced the GameOrderCustom with a GameOrderEvent, so get rid of the custom order.  
		--There wouldn't be any harm in leaving it there, but it adds clutter to the orders 
		--list so it's better to get rid of it.

	end
	

		-- logic to bypass CustomOrder if its been cancelled or removed somehow
     if(publicgamedata.orderAlt ~= nil and publicgamedata.orderaccess == true)then
		Game = game

		local hiddenorder = publicgamedata.HiddenOrders


		for i,v in pairs(publicgamedata.orderAlt) do

			local targetPlayerID = publicgamedata.orderAlt[i].targetPlayer
			local goldsent = publicgamedata.orderAlt[i].realgold
			local ourid = publicgamedata.orderAlt[i].us
			local MyID = publicgamedata.Entity[ourid].ID
			local Trannumber = publicgamedata.orderAlt[i].Trannumber
			if MyID < 0 then MyID = 0 end

			local localmessage = '(Local info) \n' .. goldsent  .. ' gold sent from ' .. publicgamedata.Entity[ourid].Name .. ' to ' .. publicgamedata.Entity[targetPlayerID].Name .. '\n#:' .. Trannumber;
			local publicmessage =  '(public info) \nUnknown amount of gold sent from ' .. publicgamedata.Entity[ourid].Name .. ' to ' .. publicgamedata.Entity[targetPlayerID].Name .. '\n#:' .. Trannumber
			local revealmessage =  '(public info) \n' .. goldsent  .. ' gold sent from ' .. publicgamedata.Entity[ourid].Name .. ' to ' .. publicgamedata.Entity[targetPlayerID].Name .. '\n#:' .. Trannumber
			local hiddenmessage =  '(public info) \n' .. goldsent .. ' gold sent from an unknown party to ' .. publicgamedata.Entity[targetPlayerID].Name .. '\n#:' .. Trannumber


			if(hiddenorder == true and publicgamedata.orderAlt[i].reveal == false)then
				addNewOrder(WL.GameOrderEvent.Create(MyID, localmessage ,  {targetPlayerID}, nil, nil, {})); 
	 			addNewOrder(WL.GameOrderEvent.Create(0, hiddenmessage , nil, nil, nil, {}));


			elseif(hiddenorder == true or publicgamedata.orderAlt[i].reveal == true)then -- for players who want to reveal there gifted gold

				addNewOrder(WL.GameOrderEvent.Create(MyID, revealmessage ,  nil, nil, nil, {})); 

			elseif(publicgamedata.orderAlt[i].reveal == false)then -- for players who dont
			
				-- creates message for players with visibility
				addNewOrder(WL.GameOrderEvent.Create(MyID, localmessage ,  {targetPlayerID}, nil, nil, {})); 
				addNewOrder(WL.GameOrderEvent.Create(MyID, publicmessage , nil, nil, nil, {}));
				-- creates a message for everyone else who can't see the territory. handles no modifications 
				-- this will create two messages for players who have visibility
			end
		



		end

		publicgamedata.orderaccess = false
		publicgamedata.orderAlt = {}
		publicgamedata.orderamount = 0
		if publicgamedata.PayP ~= nil then
		publicgamedata.PayP.accessed = false end

		Mod.PublicGameData = publicgamedata
	end
	
	if publicgamedata.ServerAccess == false then
		publicgamedata.Entity = AccountEntityUpdate(publicgamedata,publicgamedata.Entity,game)
		publicgamedata.ServerAccess = nil

		Mod.PublicGameData = publicgamedata
	end

end

--At the moment only updating member list history
function AccountEntityUpdate(publicgamedata,Entity,Game)

	for i,v in pairs (Entity) do
		if v.Status == "A" then

			if v.OwnerHistory[Game.Game.TurnNumber] == nil then v.OwnerHistory[Game.Game.TurnNumber] = {Turn = Game.Game.TurnNumber,List = v.owners}
			end
		end
	
	end

	return Entity
end