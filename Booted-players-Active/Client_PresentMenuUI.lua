require('Utilities')

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	publicdata = Mod.PublicGameData

	Game = game;
	Close = close;
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local ActivePlayers = 0
	local NeedPercent = Mod.Settings.Percentthreshold
	local IDletter = {"A","B","C","D","E"}
	ID = game.Us.ID


	setMaxSize(570, 400);
	if (game.Us == nil or game.Us.State ~= WL.GamePlayerState.Playing) then
		UI.CreateLabel(vert).SetText("You cannot Vote since you're not in the game")
		return;
	end
	for playerID, player in pairs(game.Game.PlayingPlayers) do
        if (not player.IsAIOrHumanTurnedIntoAI) then 
            ActivePlayers = ActivePlayers + 1
        end
    end


--for loop of current groups
if publicdata.Action ~= nil and #publicdata.Action > 0 then
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row00 = UI.CreateHorizontalLayoutGroup(vert)

	print("getting access",#publicdata.Action)
	UI.CreateLabel(row00).SetText("Vote on Actions to be processed").SetColor('#4EC4FF')
	for i = 1, #publicdata.Action do 
		local HaventVoted = true
		local voteid = 1
		for i2 = 1, #publicdata.Action[i].VotingIDs do
			if publicdata.Action[i].VotingIDs[i2] == ID then 
				HaventVoted = false
				voteid = i2
			end
		end

			local GoldorLand = Nonill(publicdata.Action[i].turned) .. "% of land affected"
			local row1 = UI.CreateHorizontalLayoutGroup(vert)
			local row2 = UI.CreateHorizontalLayoutGroup(vert)
			local row3 = UI.CreateHorizontalLayoutGroup(vert)
			local Tempvote = (#publicdata.Action[i].VotingIDs / ActivePlayers) * 100
			local percentVote = math.floor(Tempvote * 100) / 100 
			local votedplayer = Votedplayers(publicdata.Action[i].VotingIDs)
			local tempname = publicdata.Action[i].NewPlayerID
			local propername = Nonill(publicdata.Action[i].playerWhoCreated)
			if propername ~= 0 then
				propername = Game.Game.Players[publicdata.Action[i].playerWhoCreated].DisplayName(nil, false)
			end
			UI.CreateLabel(row1).SetText("--- " .. IDletter[i])
			if 	publicdata.Action[i].OrigPlayerID == 0 or publicdata.Action[i].NewPlayerID == 0 then 
				Serverload(3,"N/A",i,voteid,close)
			end

			if publicdata.Action[i].Actiontype == ActionTypeNames(7) then 
				UI.CreateLabel(row2).SetText( "All players(non AI) with " .. publicdata.Action[i].Cutoff .. " or less income will get " .. publicdata.Action[i].incomebump .. "+ income Next turn").SetColor('#FF87FF')
				GoldorLand = ""
			else
				if publicdata.Action[i].NewPlayerID ~= "Neutral" then tempname = Game.Game.Players[publicdata.Action[i].NewPlayerID].DisplayName(nil, false) end

				UI.CreateLabel(row2).SetText( Game.Game.Players[publicdata.Action[i].OrigPlayerID].DisplayName(nil, false) .. " to be " .. publicdata.Action[i].Actiontype .. " by " ..tempname).SetColor('#FF87FF')
				
			end
				UI.CreateButton(row2).SetText("Remove Vote").SetOnClick(function () Serverload(3,"N/A",i,voteid,close) end).SetInteractable(not HaventVoted)
				UI.CreateButton(row2).SetText("Add Vote").SetOnClick(function () Serverload(2,"N/A",i,ID,close) end).SetInteractable(HaventVoted)

				UI.CreateLabel(row2).SetText(percentVote .. "% of active players voted. need ".. NeedPercent.."%\n".. GoldorLand).SetColor('#00FF05')
				UI.CreateButton(row3).SetText("Voted players").SetOnClick(function ()PromptListSetup(4,votedplayer) end)
				UI.CreateLabel(row3).SetText("Turns left: " .. (publicdata.Action[i].TurnCreated+3) - game.Game.TurnNumber).SetColor('#00F4FF')
			
			UI.CreateLabel(row3).SetText(" -- Created by: " .. propername).SetColor('#FF697A')
	end
end

	Serverload(0, 0,0, 0,nil)
	local NoActionCreated = true
	print(publicdata.CreatedActionID,"test 00")
	if publicdata.CreatedActionID ~= nil then
	for i = 1, #publicdata.CreatedActionID do
		print(publicdata.CreatedActionID[i],"test")
		if ID == publicdata.CreatedActionID[i] then NoActionCreated = false end
	end end
	UI.CreateLabel(row1).SetText("Begin player management")
	-- add check if it has already been clicked
	MainBtn = UI.CreateButton(vert).SetText("Create Action vote").SetOnClick(function () Window(1,close,vert) end).SetInteractable(NoActionCreated)


end
function Window(window, close, data)
	
	if window == 1 then
		Game.CreateDialog(DisplaySwapAction)
		close()
	end
end
function DisplaySwapAction(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(400, 400)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row33 = UI.CreateHorizontalLayoutGroup(vert)
	local row34 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateHorizontalLayoutGroup(vert)
	HelperMessage = "select a Action, then click on this again, it will have a help tip"

	UI.CreateLabel(row1).SetText("Original Player: ").SetColor('#4EC4FF')
	OrigPlayerBtn = UI.CreateButton(row1).SetText("Select Old player...").SetOnClick(function ()PromptListSetup(1) end)
	UI.CreateLabel(row2).SetText("Action: ").SetColor('#4EC4FF')
	ActPlayerBtn = UI.CreateButton(row2).SetText("Select Action...").SetOnClick(function ()PromptListSetup(3) end)
	UI.CreateButton(row2).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert(HelperMessage); end);

	UI.CreateLabel(row3).SetText("New Player: ").SetColor('#4EC4FF')
	SwapPlayerBtn = UI.CreateButton(row3).SetText("Select New player...").SetOnClick(function ()PromptListSetup(2) end)

	--TurnedBtn = UI.CreateCheckBox(row33).SetIsChecked(false).SetText("Land Affected percent") endt
    Textland1 = UI.CreateLabel(row33).SetText('Percent of Land affected')
    TurnedBtn = UI.CreateNumberInputField(row33)
        .SetSliderMinValue(5)
        .SetSliderMaxValue(100)
        .SetValue(100)
	Textland2 = UI.CreateLabel(row34).SetText('Income Cut off')
    TurnedBtn2 = UI.CreateNumberInputField(row34)
        .SetSliderMinValue(1)
        .SetSliderMaxValue(500)
        .SetValue(100).SetInteractable(false)

		

	UI.CreateButton(row4).SetText("Commit").SetOnClick(function ()Serverload(1,ActPlayerBtn.GetText(),OrigPlayerID,SwapPlayerID, close) end)

end

function PromptListSetup(data,votedplayers)
	local funcvar
	local Senttable = {}
	local message = ""
	local Aliveplayers = {}
	for playerID, player in pairs(Game.Game.PlayingPlayers) do
        if (player.State == 2) then 
            table.insert(Aliveplayers,player)
        end
    end
	-- set up for each prompt
	if data == 1 then 
		funcvar = PlayerButton 
		Senttable = Aliveplayers
		message = "Select the Original player for this action"
	elseif data == 2 then 
		funcvar = SwapPlayerButton 
		Senttable = Aliveplayers
		message = "Select the new player for this action"
	elseif data == 3 then
		funcvar = ActionButton
		Senttable = ActionTypeNames(0)
		message = "Select the Action you'd like to do"
	elseif data == 4 then
		funcvar = ViewButton
		Senttable = votedplayers
		message = "View who has voted so far"
	end
print(Senttable)

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

		if name == ActionTypeNames(2) then
			SwapPlayerBtn.SetInteractable(true)
			OrigPlayerBtn.SetInteractable(true)
			HelperMessage = "New player takes Original player's land, and New player's former land is turn to wasteland"
		elseif name == ActionTypeNames(1) then
			SwapPlayerBtn.SetInteractable(true)
			OrigPlayerBtn.SetInteractable(true)
			HelperMessage = "New player and Original player Swap all land, armies, cities ect. with each other"
		elseif name == ActionTypeNames(3) then
			SwapPlayerBtn.SetInteractable(false)
			OrigPlayerBtn.SetInteractable(true)
			HelperMessage = "Original player is simply turned neutral, his land is left untouched"
			SwapPlayerID = -1
		elseif name == ActionTypeNames(4) then
			SwapPlayerBtn.SetInteractable(false)
			OrigPlayerBtn.SetInteractable(true)
			HelperMessage = "Original player's land is factory wiped. cities, armies, special units, commanders. Everything is removed and replaced with wastelands"
			SwapPlayerID = -1
		elseif name == ActionTypeNames(5) then
			SwapPlayerBtn.SetInteractable(true)
			OrigPlayerBtn.SetInteractable(true)
			HelperMessage = "New player Takes all of Original player's land. New player also keeps his former land as well"
		elseif name == ActionTypeNames(6) then
			SwapPlayerBtn.SetInteractable(false)
			OrigPlayerBtn.SetInteractable(true)
			HelperMessage = "Original player's has all of his armies/special units removed"
			SwapPlayerID = -1
		elseif name == ActionTypeNames(7) then
			SwapPlayerBtn.SetInteractable(false)
			OrigPlayerBtn.SetInteractable(false)
			Textland1.SetText("Bonus Income")
			Textland2.SetText("Income Cut off")
			TurnedBtn2.SetInteractable(true)
			HelperMessage = "All players get X amount of income based on how much income they have. Good use for balance"
			OrigPlayerID = -1
			SwapPlayerID = -1
		elseif name == ActionTypeNames(8) then
			SwapPlayerBtn.SetInteractable(true)
			OrigPlayerBtn.SetInteractable(true)
			HelperMessage = "New player Takes all of Original player's land. New player also keeps his former land. Lastly the Armies and special units of Original players lands are removed"
		elseif name == ActionTypeNames(9) then
			SwapPlayerBtn.SetInteractable(false)
			OrigPlayerBtn.SetInteractable(true)
			HelperMessage = "Original player's land is turned neutral and the Armies and special units of Original players lands are removed"
			OrigPlayerID = -1
		end
	end
	return ret;
end
function ViewButton(action)

	local name = action
	local ret = {};
	ret["text"] = name;
	ret["selected"] = function() 

	end
	return ret;
end

function Serverload(type, text,data1, data2,close)
	if close ~= nil then
		close()
	end

	local payload = {}
	Pass = nil

		payload.entrytype = type
		payload.text = text
		payload.data1 = Nonill(data1)
		payload.data2 = Nonill(data2)
		payload.data3 = 100

		if TurnedBtn ~= nil then
		local data3 = Nonill(TurnedBtn.GetValue())
		if TurnedBtn2.GetInteractable() == false then
		if data3 > 100 or data3 < 5 then data3 = 100 end end

		payload.data3 = data3
		payload.data4 = Nonill(TurnedBtn2.GetValue())
		end

		Game.SendGameCustomMessage("new " .. "playerControl" .. "...", payload, function(returnValue)
			publicdata = Mod.PublicGameData
			if returnValue.Message ~= nil then 
				UI.Alert(returnValue.Message)
			end
		

		end)	
end

function Votedplayers(newtable)
	local group = {}

	for i,v in pairs (newtable) do
	
	table.insert(group,Game.Game.Players[v].DisplayName(nil, false))
	print(Game.Game.Players[v].DisplayName(nil, false))
	end
return group
end