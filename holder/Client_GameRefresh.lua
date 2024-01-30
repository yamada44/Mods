

function Client_GameRefresh(game)

    local publicdata = Mod.PublicGameData
	Game = game

	if (not Alerted and not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use the Gift Gold Ultra 2 mod")
	end
    if (game.Us == nil) then return
    end 
	if publicdata.PayP == nil then return
	end

	if publicdata.PayP.accessed == false and #publicdata.PayP.Plan > 0  and publicdata.PayP.Sameturn ~= game.Game.TurnNumber then
		local payload = {}
		payload.setup = 1

		Game.SendGameCustomMessage("GiftGoldUltra2" .. "...", payload, function(returnValue) 
		end)
	end
end