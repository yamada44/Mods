require('Utilities');

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	Game = game;
	Close = close;
	publicdata = Mod.PublicGameData
	ID = game.Us.ID
	Pass = nil
	BaseName = "Agency"



	setMaxSize(450, 320);
	Root = rootParent
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local row1 = UI.CreateHorizontalLayoutGroup(vert);


	if (game.Settings.CommerceGame == false) then
		UI.CreateLabel(vert).SetText("This mod only works in commerce games.  This isn't a commerce game.");
		return;
	end

	--checking to see if we're in the game
	if (game.Us == nil or game.Us.State ~= WL.GamePlayerState.Playing) then
		UI.CreateLabel(vert).SetText("You cannot gift gold since you're not in the game");
		return;
	end

	--Setting up variable
	 Agentcost = Mod.Settings.Agentcost
	 Decoycost = Mod.Settings.Decoycost
	local citiesremovedatonce = Mod.Settings.Citylost
	local cityRemovalon = Mod.Settings.Cityremoved
	local cardremovalon = Mod.Settings.Cardsremoved
	 creationfee = Mod.Settings.Creationfee


	if publicdata[ID] ~= nil then -- Use this menu if you already have an agency created
		UI.CreateLabel(row1).SetText("Welcome to the " .. publicdata[ID].Agency.agencyname .. " " .. BaseName );
		UI.CreateButton(row1).SetText("Access " .. BaseName).SetOnClick(function () Dialogwindow(2) end);

		--run agency options --
		--agent list
		--check agency status
		--buy options
		-- Tutorial
		-- Top Agent
	else -- Use this menu if you dont have an agency
		UI.CreateLabel(row1).SetText("you have no " .. BaseName ..". it cost " ..creationfee.. " gold to start one\nWould you like to create one"  );
		Agencynamefield = UI.CreateTextInputField(vert).SetPlaceholderText(" Name of ".. BaseName .. "                       ").SetFlexibleWidth(1).SetCharacterLimit(50)
		UI.CreateButton(row1).SetText("Create ".. BaseName ).SetOnClick(function () Dialogwindow(1) end);

	
	end


end

function Dialogwindow(window) -- middle function to open up new windows
	if window == 1 then --buying an agency
		if Pass == nil then
					BuyingLogic(BaseName,creationfee,0,Agencynamefield.GetText())
		end
		
    elseif window == 2 then -- opening agency menu
		Game.CreateDialog(AgencyOptions)
		Close()
	
	elseif window == 3 then -- special units/Assassination

	elseif window == 4 then -- Agency Ranking
		Game.CreateDialog(AgencyLogic)
	elseif window == 5 then -- Buy optins
		Game.CreateDialog(Buyoptions)
	elseif window == 6 then -- Tutorial option		
	elseif window == 7 then -- top agent list option		
		Game.CreateDialog(AgentLogic)


	end
end

function AgencyOptions(rootParent, setMaxSize, setScrollable, game, close) -- present the menu options for your agency
	setMaxSize(450, 320);
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local row1 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateButton(row1).SetText("Unit List").SetOnClick(function () Dialogwindow(3) end);
	UI.CreateButton(row1).SetText(BaseName .. " Ranking").SetOnClick(function () Dialogwindow(4) end);
	UI.CreateButton(row1).SetText("Top Agents").SetOnClick(function () Dialogwindow(7) end);
	UI.CreateButton(row1).SetText("Shop").SetOnClick(function () Dialogwindow(5) end);
	
	--UI.CreateButton(row1).SetText("Shop").SetOnClick(function () Dialogwindow(6) end);


end
function AgencyLogic(rootParent, setMaxSize, setScrollable, game, close) -- present agency rank
	publicdata = Mod.PublicGameData
	setMaxSize(450, 320);
print(publicdata.Ranklist)
	for i = 1, #publicdata.Ranklist do 
		local vert = UI.CreateVerticalLayoutGroup(rootParent);
		local row1 = UI.CreateHorizontalLayoutGroup(vert);
		local tempagents = 0
		print("test 3")
		if publicdata.Ranklist[i].Agentlist ~= nil then 
			print("no agents")
			tempagents = #publicdata.Ranklist[i].Agentlist end
		
	UI.CreateLabel(row1).SetText("Rank #" .. i .. " ::");
	UI.CreateButton(row1).SetText(publicdata.Ranklist[i].agencyname .. " " .. BaseName)
	UI.CreateLabel(row1).SetText(" --- " .. publicdata.Ranklist[i].agencyRank)
	UI.CreateLabel(row1).SetText(" --- " .. publicdata.Ranklist[i].Missions)
	UI.CreateLabel(row1).SetText(" --- " .. tempagents)

	end

end
function AgentLogic(rootParent, setMaxSize, setScrollable, game, close)
	publicdata = Mod.PublicGameData
print("")
	if #publicdata.AgentRank == 0 then
		UI.CreateLabel(rootParent).SetText("No one has trained any Agents yet, go here to start training new Agents")
		UI.CreateButton(rootParent).SetText("Train Agent").SetOnClick(function () Dialogwindow(5) end);
		

	else
		for i = 1, #publicdata.Ranklist do 
			local vert = UI.CreateVerticalLayoutGroup(rootParent);
			local row1 = UI.CreateHorizontalLayoutGroup(vert);
			
		UI.CreateLabel(row1).SetText("Rank #" .. i .. " ::");
		UI.CreateButton(row1).SetText(publicdata.AgentRank[i].codename)
		UI.CreateLabel(row1).SetText(" --- " .. publicdata.AgentRank[i].level)
		UI.CreateLabel(row1).SetText(" --- " .. publicdata.AgentRank[i].missions)
		UI.CreateLabel(row1).SetText(" --- " .. publicdata.AgentRank[i].successfulmissions)
	
		end
	end
end
function Buyoptions(rootParent, setMaxSize, setScrollable, game, close) -- present menu option for your buy menu
	Closed2 = close
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)	

-- Buying decoy
UI.CreateLabel(row2).SetText("Cost: " .. Decoycost .. " gold")
	UI.CreateButton(row1).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Buy a decoy agent, this decoy agent dies every time one of your special units/agents is assassinated"); end);
	UI.CreateButton(row1).SetText("Buy Personal Decoy").SetOnClick(function ()  BuyingLogic("Decoy",Decoycost,1, nil)  end);

	--Buying Agent
	UI.CreateLabel(row2).SetText("Cost: " .. Agentcost .. " gold")
	UI.CreateButton(row2).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Creates a Secret agent you can use to sagatage your opponent. you can kill there agents, special units, Destroy cards,cities and armies."); end);
	UI.CreateButton(row2).SetText("Buy Agent").SetOnClick(function () BuyingLogic("Agent", Agentcost, 2, Chartracker.GetText()) end);
	Chartracker = UI.CreateTextInputField(vert).SetPlaceholderText(" Code name of your Agent").SetFlexibleWidth(1).SetCharacterLimit(30)
end
function BuyingLogic(typename, cost, type, text) -- logic for how buying works
	print("jon")
	local payload = {}
	Pass = nil
	if text == "" then
		UI.Alert("your " .. typename.. " has no code name.\nPlease provide a name")

		return
	end

		payload.entrytype = type
		payload.typename = typename
		payload.cost = cost
		payload.text = text
		Game.SendGameCustomMessage("new " .. BaseName .. "...", payload, function(returnValue)
			print("job 3")
			if returnValue.Message ~= nil then 
				UI.Alert(returnValue.Message)
			end

			Pass = returnValue.Pass
			print (Pass,"pass(sin)")
			if Pass == true then
				print( typename.. " was created")

				Dialogwindow(2)
				Close()
			end	
		end)		
			
end




-- Objectives
-- how rankings work
    -- any new agency is instaly added to list
	-- at turn end, empty table, then loop through agencies and list from highest to lowest on Scores

-- Known Bugs
--





	--[[*local players = filter(Game.Game.Players, function (p) return p.ID ~= Game.Us.ID end);
	local options = map(players, PlayerButton);

	UI.PromptFromList("Select the player you'd like to give gold to", options);--]]
	--local name = player.DisplayName(nil, false);

	--local orders = Game.Orders;
	--table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload));
	--Game.Orders = orders;

		--local goldHave = game.LatestStanding.NumResources(game.Us.ID, WL.ResourceType.Gold);
	--Game.SendGameCustomMessage("read rules...", payload, function(returnValue) end)


