require('Utilities');
require('Utilities2');
require('WLUtilities');

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, 'GiftGold2')) then  --look for the order that we inserted in Client_PresentMenuUI

local Game = game

		
		--in Client_PresentMenuUI, we comma-delimited the number of armies, the target territory ID, and the target player ID.  Break it out here
		local payloadSplit = split(string.sub(order.Payload, 10), ','); 
		local goldtried = tonumber(payloadSplit[1])
		local goldsent = tonumber(payloadSplit[2]);
		local targetPlayerID = tonumber(payloadSplit[3]);


local publicmessage =  '(public info) An unknown amount of gold was sent from ' .. game.Game.Players[order.PlayerID].DisplayName(nil, false) .. ' to ' .. game.Game.Players[targetPlayerID].DisplayName(nil, false)
		

-- create 
		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, order.Message ,  {targetPlayerID}, nil, nil, {})); 
		-- creates message for players with visibility
		
		
		
		addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, publicmessage , nil, nil, nil, {}));
		-- creates a message for everyone else who can't see the territory. handles no modifications 
		-- this will create two messages for players who have visibility
		
	
		
		skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage); 
		--we replaced the GameOrderCustom with a GameOrderEvent, so get rid of the custom order.  
		--There wouldn't be any harm in leaving it there, but it adds clutter to the orders 
		--list so it's better to get rid of it.

	
	end
	print('does it work')
end
