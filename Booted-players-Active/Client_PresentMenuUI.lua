require('Utilities')

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	publicdata = Mod.PublicGameData

	Game = game;
	Close = close;
	BaseTable = {"Swapped"}
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)


	setMaxSize(500, 400);
	if (game.Us == nil or game.Us.State ~= WL.GamePlayerState.Playing) then
		UI.CreateLabel(vert).SetText("You cannot gift gold since you're not in the game")
		return;
	end


--for loop of current groups
if publicdata.Action ~= nil and #publicdata.Action > 0 then
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row00 = UI.CreateHorizontalLayoutGroup(vert)
	ID = game.Us.ID

	UI.CreateLabel(row00).SetText("Vote on Actions to be processed").SetColor('#4EC4FF')
	for i = 1, #publicdata.Action do 
		local HaventVoted = true
		for i = 1, #publicdata.Action[i].VotingIDs do
		--if publicdata.Action[i].VotingIDs[i] == ID then HaventVoted = false break 
		--end
			local row2 = UI.CreateHorizontalLayoutGroup(vert)
			UI.CreateLabel(row2).SetText(Game.Game.Players[publicdata.Action[i].OrigPlayerID].DisplayName(nil, false) .. " to be " .. publicdata.Action[i].Actiontype .. " with " .. Game.Game.Players[publicdata.Action[i].NewPlayerID].DisplayName(nil, false)).SetColor('#FF87FF')
			UI.CreateButton(row2).SetText("Remove Vote")--.SetOnClick(function () Window(1,close,vert) end)
			UI.CreateButton(row2).SetText("Add Vote")--.SetOnClick(function () Window(1,close,vert) end)
		end
	end
end

	UI.CreateLabel(row1).SetText("Create a booted/PE player swap")
	-- add check if it has already been clicked
	MainBtn = UI.CreateButton(vert).SetText("Create Swap vote").SetOnClick(function () Window(1,close,vert) end)


end
function Window(window, close, data)
	
	if window == 1 then
		Game.CreateDialog(DisplaySwapAction)
		close()
	end
end
function DisplaySwapAction(rootParent, setMaxSize, setScrollable, game, close)
	--setMaxSize(300, 400)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateHorizontalLayoutGroup(vert)

	OrigPlayerBtn = UI.CreateButton(row1).SetText("Select Old player...").SetOnClick(function ()PromptListSetup(1) end)
	ActPlayerBtn = UI.CreateButton(row2).SetText("Select Action...").SetOnClick(function ()PromptListSetup(3) end)

	SwapPlayerBtn = UI.CreateButton(row3).SetText("Select New player...").SetOnClick(function ()PromptListSetup(2) end)

	UI.CreateButton(row4).SetText("Commit").SetOnClick(function ()Serverload(1,ActPlayerBtn.GetText(),OrigPlayerID,SwapPlayerID, close) end)

end

function PromptListSetup(data)
	local funcvar
	local Senttable = {}
	local message = ""
	-- set up for each prompt
	if data == 1 then 
		funcvar = PlayerButton 
		Senttable = Game.Game.Players 
		message = "Select the Original player for this action"
	elseif data == 2 then 
		funcvar = SwapPlayerButton 
		Senttable = Game.Game.Players 
		message = "Select the new player for this action"
	elseif data == 3 then
		funcvar = ActionButton
		Senttable = BaseTable
		message = "Select the Action you'd like to do"
	end


	local options = map(Senttable, funcvar);
	UI.PromptFromList(message, options)
end
function PlayerButton(player)

	local name = player.DisplayName(nil, false);
	local ret = {};
	ret["text"] = name;
	ret["selected"] = function() 
		OrigPlayerBtn.SetText(name)
		OrigPlayerID = player.ID

	end
	return ret;
end

function SwapPlayerButton(player)

	local name = player.DisplayName(nil, false);
	local ret = {};
	ret["text"] = name;
	ret["selected"] = function() 
		SwapPlayerBtn.SetText(name)
		SwapPlayerID = player.ID

	end
	return ret;
end
function ActionButton(action)

	local name = action
	local ret = {};
	ret["text"] = name;
	ret["selected"] = function() 
		ActPlayerBtn.SetText(name)
		ActionType = action

	end
	return ret;
end
function Serverload(type, text,data1, data2,close)
	close()
	local payload = {}
	Pass = nil
	if text == "Select New player..." or data1 == nil or data2 == nil then
		UI.Alert("Did not fill out all fields before Commiting")
		return
	end

		payload.entrytype = type
		payload.text = text
		payload.data1 = Nonill(data1)
		payload.data2 = Nonill(data2)

		Game.SendGameCustomMessage("new " .. "playerControl" .. "...", payload, function(returnValue)
			publicdata = Mod.PublicGameData
			if returnValue.Message ~= nil then 
				UI.Alert(returnValue.Message)
			end
		

		end)	
end

function BuyingLogic(typename, cost, type, text, close) -- logic for how buying works
	print("jon")
			
end