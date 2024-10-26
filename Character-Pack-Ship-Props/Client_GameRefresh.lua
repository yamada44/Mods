Alerted = false;

function Client_GameRefresh(game)
	if (not Alerted and not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use the Tanks mod");
        Alerted = true;
	end

	if publicdata.Access ~= nil and publicdata.Access == true then
		local payload = {}
		payload.type = 0

		Game.SendGameCustomMessage("GiftGoldUltra2" .. "...", payload, function(returnValue) 
		end)
	end
end