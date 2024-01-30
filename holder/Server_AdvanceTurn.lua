require('Utilities');

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

		if (publicgamedata.trannum == nil)then publicgamedata.trannum = 1 end --keeping track of transactions to properly track
		local transactionNumber = publicgamedata.trannum

		for i,v in pairs(publicgamedata.orderAlt) do

			local targetPlayerID = publicgamedata.orderAlt[i].targetPlayer
			local goldsent = publicgamedata.orderAlt[i].realgold
			local ourid = publicgamedata.orderAlt[i].us

			local localmessage = '(Local info) \n' .. goldsent  .. ' gold sent from ' .. Game.Game.Players[ourid].DisplayName(nil, false) .. ' to ' .. Game.Game.Players[targetPlayerID].DisplayName(nil, false) .. '\n#:' .. transactionNumber;
			local publicmessage =  '(public info) \n Unknown amount of gold sent from ' .. Game.Game.Players[ourid].DisplayName(nil, false) .. ' to ' .. Game.Game.Players[targetPlayerID].DisplayName(nil, false) .. '\n#:' .. transactionNumber
			local revealmessage =  '(public info) \n' .. goldsent  .. ' gold sent from ' .. Game.Game.Players[ourid].DisplayName(nil, false) .. ' to ' .. Game.Game.Players[targetPlayerID].DisplayName(nil, false) .. '\n#:' .. transactionNumber
			local hiddenmessage =  '(public info) \n' .. goldsent .. ' gold sent from an unknown party to ' .. Game.Game.Players[targetPlayerID].DisplayName(nil, false) .. '\n#:' .. transactionNumber


			if(hiddenorder == true and publicgamedata.orderAlt[i].reveal == false)then
				addNewOrder(WL.GameOrderEvent.Create(game.Game.Players[ourid].ID, localmessage ,  {targetPlayerID}, nil, nil, {})); 
	 			addNewOrder(WL.GameOrderEvent.Create(0, hiddenmessage , nil, nil, nil, {}));


			elseif(hiddenorder == true or publicgamedata.orderAlt[i].reveal == true)then -- for players who want to reveal there gifted gold

				addNewOrder(WL.GameOrderEvent.Create(game.Game.Players[ourid].ID, revealmessage ,  nil, nil, nil, {})); 

			elseif(publicgamedata.orderAlt[i].reveal == false)then -- for players who dont
			
				-- creates message for players with visibility
				addNewOrder(WL.GameOrderEvent.Create(game.Game.Players[ourid].ID, localmessage ,  {targetPlayerID}, nil, nil, {})); 
				addNewOrder(WL.GameOrderEvent.Create(game.Game.Players[ourid].ID, publicmessage , nil, nil, nil, {}));
				-- creates a message for everyone else who can't see the territory. handles no modifications 
				-- this will create two messages for players who have visibility
			end
		

			transactionNumber = transactionNumber + 1

		end

		publicgamedata.trannum = transactionNumber
		publicgamedata.orderaccess = false
		publicgamedata.orderAlt = {}
		publicgamedata.orderamount = 0

		Mod.PublicGameData = publicgamedata
	end

end
