require('Utilities');

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	Game = game;
	Close = close;
	publicdata = Mod.PublicGameData
	ID = game.Us.ID

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
		UI.CreateLabel(row1).SetText("Welcome to the " .. publicdata[ID].Agency.agencyname .. " Agency" );
		UI.CreateButton(row1).SetText("Access Agency").SetOnClick(function () Dialogwindow(2) end);

		--run agency options --
		--agent list
		--check agency status
		--buy options
		-- Tutorial
	else -- Use this menu if you dont have an agency
		UI.CreateLabel(row1).SetText("you have no agency. it cost " ..creationfee.. " gold to start one\nWould you like to create one"  );
		Agencynamefield = UI.CreateTextInputField(vert).SetPlaceholderText(" Name of Agency                       ").SetFlexibleWidth(1).SetCharacterLimit(50)
		UI.CreateButton(row1).SetText("Create Agency").SetOnClick(function () Dialogwindow(1) end);

	
	end


end

function Dialogwindow(window) -- middle function to open up new windows
	if window == 1 then --buying an agency
		local pass = BuyingLogic("Agency",creationfee,0,Agencynamefield.GetText())
		print (publicdata[ID], "pass")
		if publicdata[ID].Agency ~= nil then Game.CreateDialog(AgencyOptions) end
		print("WFT")
    elseif window == 2 then -- opening agency menu
		Game.CreateDialog(AgencyOptions)
	
	elseif window == 3 then -- special units/Assassination

	elseif window == 4 then -- Agency Ranking
		Game.CreateDialog(RankinglistAgency)
	elseif window == 5 then -- Buy optins
		Game.CreateDialog(Buyoptions)
	elseif window == 6 then -- Tutorial option		
	elseif window == 7 then -- top agent list option		


	end
end

function AgencyOptions(rootParent, setMaxSize, setScrollable, game, close) -- present the menu options for your agency
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local row1 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateButton(row1).SetText("Unit List").SetOnClick(function () Dialogwindow(3) end);
	UI.CreateButton(row1).SetText("Agency Ranking").SetOnClick(function () Dialogwindow(4) end);
	UI.CreateButton(row1).SetText("Top Agents").SetOnClick(function () Dialogwindow(7) end);
	UI.CreateButton(row1).SetText("Shop").SetOnClick(function () Dialogwindow(5) end);
	
	--UI.CreateButton(row1).SetText("Shop").SetOnClick(function () Dialogwindow(6) end);


end
function RankinglistAgency() -- present agency rank
	
end
function Buyoptions(rootParent, setMaxSize, setScrollable, game, close) -- present menu option for your buy menu
	Closed2 = close
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)	

-- Buying decoy
	UI.CreateButton(row1).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Buy a decoy agent, this decoy agent dies every time one of your special units/agents is assassinated"); end);
	UI.CreateButton(row1).SetText("Buy Personal Decoy").SetOnClick(function ()  BuyingLogic("Decoy",Decoycost,1, nil)  end);

	--Buying Agent
	UI.CreateButton(row2).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Creates a Secret agent you can use to sagatage your opponent. you can kill there agents, special units, Destroy cards,cities and armies."); end);
	UI.CreateButton(row2).SetText("Buy Agent").SetOnClick(function () BuyingLogic("Agent", Agentcost, 2, Chartracker.GetText()) end);
	Chartracker = UI.CreateTextInputField(vert).SetPlaceholderText(" Code name of your Agent").SetFlexibleWidth(1).SetCharacterLimit(30)
end
function BuyingLogic(typename, cost, type, text) -- logic for how buying works
	print("jon")
	local payload = {}
	local Pass = false
	if text == "" then
		UI.Alert("your " .. typename.. " has no code name.\nPlease provide a name")

		return Pass
	end
	print("job 2")
		payload.entrytype = type
		payload.typename = typename
		payload.cost = cost
		payload.text = text
		Game.SendGameCustomMessage("new agency...", payload, function(returnValue)
			print("job 3")
			if returnValue.Message ~= nil then 
				UI.Alert(returnValue.Message)
			end
			print("job 4", ID, returnValue.id, publicdata[ID])
			Pass = returnValue.Pass
			print (Pass,"pass(sin)")
			if Pass == true then
				print( typename.. " was created")
				
			end	
		end)
			print("job 5")

			
end



-- Known Bugs
--window wont open up once you create an agency. returnvale is processing later





	--[[*local players = filter(Game.Game.Players, function (p) return p.ID ~= Game.Us.ID end);
	local options = map(players, PlayerButton);

	UI.PromptFromList("Select the player you'd like to give gold to", options);--]]
	--local name = player.DisplayName(nil, false);

	--local orders = Game.Orders;
	--table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload));
	--Game.Orders = orders;

		--local goldHave = game.LatestStanding.NumResources(game.Us.ID, WL.ResourceType.Gold);
	--Game.SendGameCustomMessage("read rules...", payload, function(returnValue) end)


