

function Client_GameRefresh(game)
    publicdata = Mod.PublicGameData
	local voteTimer = 3
	Game = game

	if (not Alerted and not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use the Player Manager mod");
        Alerted = true;
	end
    if (game.Us == nil) then return;
    end -- don't show pop-ups for spectators
	local payload = {}
	Game.SendGameCustomMessage("new " .. "playerControl" .. "...", payload, function(returnValue) end)-- just to update the game everytime client is refreshed
	if publicdata.Action ~= nil and #publicdata.Action > 0 then
		for i,v in pairs (publicdata.Action) do 
			if game.Game.TurnNumber >= (publicdata.Action[i].TurnCreated + voteTimer) then
				local payload = {}
				payload.entrytype = 4
				payload.data1 = i
				Game.SendGameCustomMessage("new " .. "playerControl" .. "...", payload, function(returnValue) 
				
				end)

			end
		end
	end
end