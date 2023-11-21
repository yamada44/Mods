require('Utilities')

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	Game = game;
	--Close = close;
	publicdata = Mod.PublicGameData
	ID = game.Us.ID
	Pass = nil
	BaseName = "Agency"
	Orderstartwith = 'ISA'
	Targettype = -1


	setMaxSize(450, 320);
	Root = rootParent
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row1 = UI.CreateHorizontalLayoutGroup(vert);


	if (game.Settings.CommerceGame == false) then
		UI.CreateLabel(vert).SetText("This mod only works in commerce games.  This isn't a commerce game.");
		return;
	end

	--checking to see if we're in the game
	if (game.Us == nil or game.Us.State ~= WL.GamePlayerState.Playing) then
		UI.CreateLabel(vert).SetText("You cannot use an agency since your not in the game");
		return;
	end

	--Setting up variable
	 Agentcost = Mod.Settings.Agentcost
	 Decoycost = Mod.Settings.Decoycost
	 Citieslost = Mod.Settings.Citylost
	 Armieslost = Mod.Settings.ArmiesLost
	 Cardremovalon = Mod.Settings.Cardsremoved
	 creationfee = Mod.Settings.Creationfee
	 MissionCost = Mod.Settings.MissionCost


	if publicdata[ID] ~= nil then -- Use this menu if you already have an agency created
		UI.CreateLabel(row1).SetText("Welcome to the " .. publicdata[ID].Agency.agencyname .. " " .. BaseName );
		UI.CreateButton(row1).SetText("Access " .. BaseName).SetOnClick(function () Dialogwindow(2, close, nil) end);

		--run agency options --
		--agent list
		--check agency status
		--buy options
		-- Tutorial
		-- Top Agent
	else -- Use this menu if you dont have an agency
		UI.CreateLabel(row1).SetText("you have no " .. BaseName ..". it cost " ..creationfee.. " gold to start one\nWould you like to create one"  );
		Agencynamefield = UI.CreateTextInputField(vert).SetPlaceholderText(" Name of ".. BaseName .. "                       ").SetFlexibleWidth(1).SetCharacterLimit(50)
		UI.CreateButton(row1).SetText("Create ".. BaseName ).SetOnClick(function () Dialogwindow(1, close, nil) end);

	
	end


end

function Dialogwindow(window, close, data) -- middle function to open up new windows
	publicdata = Mod.PublicGameData


	if window == 1 then --buying an agency
		if Pass == nil then
					BuyingLogic(BaseName,creationfee,0,Agencynamefield.GetText(),close)
		end
		
    elseif window == 2 then -- opening agency menu
		Game.CreateDialog(AgencyOptions)
		close()
	
	elseif window == 3 then -- special units/Assassination
		Game.CreateDialog(AgentPresentLogic)
	elseif window == 4 then -- Agency Ranking
		Game.CreateDialog(AgencyLogic)
	elseif window == 5 then -- Buy optins
		Game.CreateDialog(Buyoptions)
		if data == "close"then close()		end
	elseif window == 6 then -- Tutorial option		
	elseif window == 7 then -- top agent list option		
		Game.CreateDialog(TopAgentLogic)
	elseif window == 8 then -- target territory on map
		Game.CreateDialog(TargetmapLogic)
		Targettype = data
		close()
	elseif window == 9 then -- target Cards on map
		Game.CreateDialog(TargetCardLogic)
		Targettype = data
		close()
	elseif window == 10 then -- target Agent
		Game.CreateDialog(TargetAgentLogic)
		close()
		Targettype = data
	end
end
function AgentPresentLogic(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(450, 320)

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row0 = UI.CreateHorizontalLayoutGroup(vert)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	AgentBtntracker = {} 

	UI.CreateLabel(row0).SetText("AGENTS");
	if  #publicdata[ID].Agency.Agentlist > 0 then

	for i = 1, #publicdata[ID].Agency.Agentlist do 
		local spacertext = publicdata[ID].Agency.Agentlist[i].codename
		local Nomission = true
		if publicdata[ID].Agency.Agentlist[i].cooldownTill > game.Game.TurnNumber  then
			Nomission = false
			spacertext = "Agent " .. publicdata[ID].Agency.Agentlist[i].codename .. " is in the field for " .. (publicdata[ID].Agency.Agentlist[i].cooldownTill - game.Game.TurnNumber) .. " more turns"
		end
		AgentBtntracker[i] = UI.CreateButton(row1).SetText(spacertext).SetOnClick(function ()Agentmissionoptions(rootParent, close, publicdata[ID].Agency.Agentlist[i].agentID) end).SetInteractable(Nomission)
		if i % 2 == 0 then vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
			row1 = UI.CreateHorizontalLayoutGroup(vert)
		end
	end
	else 
		UI.CreateLabel(rootParent).SetText("No one has trained any Agents yet, go here to start training new Agents")
		UI.CreateButton(rootParent).SetText("Train Agent").SetOnClick(function () Dialogwindow(5,close, "close") end);
	end
	if publicdata.CardstoStop ~= nil and #publicdata.CardstoStop > 0 then
		local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
		local row00 = UI.CreateHorizontalLayoutGroup(vert)

		UI.CreateLabel(row00).SetText("Cards waiting to activate").SetColor('#4EC4FF')
		for i = 1, #publicdata.CardstoStop do 
			if publicdata.CardstoStop[i].PlayerID == ID then
				local row2 = UI.CreateHorizontalLayoutGroup(vert)
				UI.CreateLabel(row2).SetText(publicdata.CardstoStop[i].Cardname .. " Card").SetColor('#FF87FF')
				UI.CreateLabel(row2).SetText("-- ".. publicdata.CardstoStop[i].targetplayername).SetColor('#FFFFFF')
			end
		end
	end

end
function Agentmissionoptions(rootParent, close, agentdata) -- building Orders
	for i = 1, #AgentBtntracker do 
		AgentBtntracker[i].SetInteractable(false)
	end
	Agentdata = agentdata -- publicdata[ID].Agency.Agentlist
--name = " agent won" -- Bring in agents name
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)

	UI.CreateButton(vert).SetText("Assassinate Rival Agent").SetOnClick(function () Dialogwindow(10,close,"KillAgent") end) -- target agent
	UI.CreateButton(vert).SetText("Assassinate Important Target").SetOnClick(function () Dialogwindow(8,close,"Killguy") end) -- target map
	if Citieslost ~= 0 then
		UI.CreateButton(vert).SetText("Sabotage City").SetOnClick(function () Dialogwindow(8,close,"KillCity") end) -- target map
	end
	if Cardremovalon == true then
		UI.CreateButton(vert).SetText("Sabotage influence (Cards)").SetOnClick(function () Dialogwindow(9,close,"Killcard") end) -- target card type
	end
	if Armieslost ~= 0 then
		UI.CreateButton(vert).SetText("Sabotage Army Logistics").SetOnClick(function () Dialogwindow(8,close,"Killarmy") end) -- target map
	end
	-- 		 -- START REBELLION button OPTION

	-- Show how many cards missions still yet to be activated 

end

function AgencyOptions(rootParent, setMaxSize, setScrollable, game, close) -- present the menu options for your agency
	setMaxSize(450, 320);

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local row1 = UI.CreateHorizontalLayoutGroup(vert);

	UI.CreateButton(row1).SetText("Agent List").SetOnClick(function () Dialogwindow(3) end);
	UI.CreateButton(row1).SetText("Top World " .. BaseName).SetOnClick(function () Dialogwindow(4) end);
	UI.CreateButton(row1).SetText("Top World Agents").SetOnClick(function () Dialogwindow(7) end);
	UI.CreateButton(row1).SetText("Training").SetOnClick(function () Dialogwindow(5) end);
	
	--UI.CreateButton(row1).SetText("Shop").SetOnClick(function () Dialogwindow(6) end);


end
function AgencyLogic(rootParent, setMaxSize, setScrollable, game, close) -- present agency rank
	setMaxSize(450, 320);
	AgencyTable = Values2TableAgency(publicdata.Ranklist) -- list of all agencies
	local SortedAgency = SortTable(AgencyTable, "successfulmissions")
	for i = 1, #SortedAgency do 
		local vert = UI.CreateVerticalLayoutGroup(rootParent);
		local row1 = UI.CreateHorizontalLayoutGroup(vert);
		local tempagents = 0
		print("test 3")
		if SortedAgency[i].Agentlist ~= nil then 
			print("no agents")
			tempagents = #SortedAgency[i].Agentlist end
		
	UI.CreateLabel(row1).SetText("Rank #" .. i .. " ::");
	UI.CreateButton(row1).SetText(SortedAgency[i].agencyname .. " " .. BaseName)
	UI.CreateLabel(row1).SetText(" --- " .. SortedAgency[i].agencyrating)
	UI.CreateLabel(row1).SetText(" --- " .. SortedAgency[i].Missions)
	UI.CreateLabel(row1).SetText(" --- " .. SortedAgency[i].successfulmissions)
	UI.CreateLabel(row1).SetText(" --- " .. tempagents)

	end

end
function TopAgentLogic(rootParent, setMaxSize, setScrollable, game, close) -- Top Agent
	setMaxSize(450, 320)
	Agentlist = Values2TableAgent(publicdata.Ranklist) -- list of all agencies
		if #Agentlist == 0 then
		UI.CreateLabel(rootParent).SetText("No one has trained any Agents yet, go here to start training new Agents")
		UI.CreateButton(rootParent).SetText("Train Agent").SetOnClick(function () Dialogwindow(5) end);
		

	else

	 local SortedAgents = SortTable(Agentlist, "successfulmissions")
		for i = 1, #SortedAgents do 
			local vert = UI.CreateVerticalLayoutGroup(rootParent);
			local row1 = UI.CreateHorizontalLayoutGroup(vert);
			
		UI.CreateLabel(row1).SetText("Rank #" .. i .. " ::");
		UI.CreateButton(row1).SetText(SortedAgents[i].codename)
		UI.CreateLabel(row1).SetText(" --- " .. SortedAgents[i].level)
		UI.CreateLabel(row1).SetText(" --- " .. SortedAgents[i].missions)
		UI.CreateLabel(row1).SetText(" --- " .. SortedAgents[i].successfulmissions)
	
		end
	end
end
function Buyoptions(rootParent, setMaxSize, setScrollable, game, close) -- present menu option for your buy menu
	Closed2 = close
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)	

-- Buying decoy
UI.CreateLabel(row1).SetText("Cost: " .. Decoycost .. " gold")
	UI.CreateButton(row1).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Buy a decoy agent, this decoy agent dies every time one of your special units/agents is assassinated"); end);
	UI.CreateButton(row1).SetText("Buy Personal Decoy").SetOnClick(function ()  BuyingLogic("Decoy",Decoycost,1, nil)  end);

	--Buying Agent
	UI.CreateLabel(row2).SetText("Cost: " .. Agentcost .. " gold")
	UI.CreateButton(row2).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Creates a Secret agent you can use to sagatage your opponent. you can kill there agents, special units, Destroy cards,cities and armies."); end);
	UI.CreateButton(row2).SetText("Buy Agent").SetOnClick(function () BuyingLogic("Agent", Agentcost, 2, Chartracker.GetText()) close() end);
	Chartracker = UI.CreateTextInputField(vert).SetPlaceholderText(" Code name of your Agent").SetFlexibleWidth(1).SetCharacterLimit(30)
end
function BuyingLogic(typename, cost, type, text, close) -- logic for how buying works
	print("jon")
	local payload = {}
	Pass = nil
	if text == "" then
		UI.Alert("your " .. typename.. " has no name.\nPlease provide a name")

		return
	end

		payload.entrytype = type
		payload.typename = typename
		payload.cost = cost
		payload.text = text
		Game.SendGameCustomMessage("new " .. BaseName .. "...", payload, function(returnValue)
			print("job 3")
			publicdata = Mod.PublicGameData
			if returnValue.Message ~= nil then 
				UI.Alert(returnValue.Message)
			end
			Pass = returnValue.Pass


			if Pass == true then
				print(returnValue.ranklist)
				if type == 0 then

					Dialogwindow(2, close, nil)
					return
				end

			end	
		end)		
			
end

-- target territory logic
function TargetmapLogic(rootParent, setMaxSize, setScrollable, game, close)

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1); --set flexible width so things don't jump around while we change InstructionLabel

	SelectTerritoryBtn = UI.CreateButton(vert).SetText("Select Territory").SetOnClick(SelectedTerritoryLogic);
	TargetTerritorytext = UI.CreateLabel(vert).SetText("");

	BuyUnitBtn = UI.CreateButton(vert).SetInteractable(false).SetText("Start Mission").SetOnClick(function () CreateOrder(0, close) end);

	SelectedTerritoryLogic(); --just start us immediately in selection mode, no reason to require them to click the button

end
function SelectedTerritoryLogic() -- Needs type
	UI.InterceptNextTerritoryClick(TerritoryClicked);
	TargetTerritorytext.SetText("Please click on the territory you wish to start your mission\nYou can move this dialog out of the way.");
	SelectTerritoryBtn.SetInteractable(false);
end
function TerritoryClicked(terrDetails)
	SelectTerritoryBtn.SetInteractable(true);

	if (terrDetails == nil) then
		--The click request was cancelled.   Return to our default state.
		TargetTerritorytext.SetText("");
		SelectedTerritory = nil;
		BuyUnitBtn.SetInteractable(false);
	else
		--Territory was clicked, check it
			TargetTerritorytext.SetText("Selected territory: " .. terrDetails.Name);
			SelectedTerritory = terrDetails;
			BuyUnitBtn.SetInteractable(true);
		
	end
end
-- Select Player/card logic
function TargetCardLogic(rootParent, setMaxSize, setScrollable, game, close)
	
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	Cardtable = CardData(0)
	Checkclear = {player = false, card = false, allgood = false}


	--select player
	TargetPlayerBtn = UI.CreateButton(row1).SetText("Select Nation/player...").SetOnClick(TargetPlayerClicked)
	--Select Card 	
	GetCardBtn = UI.CreateButton(vert).SetText("Select Card to Sabotage").SetOnClick(FinalcheckCardLogic)
	-- Start mission
	StartCardmissionBtn = UI.CreateButton(row1).SetText("Start Mission").SetOnClick(function () CreateOrder(1,close) end).SetInteractable(Checkclear.allgood)

end
-- Promt list logic for Cards
function FinalcheckCardLogic()
	local options = map2(Cardtable, CardlogicButton);
	UI.PromptFromList("Select the player you'd like to give gold to", options);
end
function CardlogicButton(card)
	local data = card
	local ret = {};
	ret["text"] = data;
	ret["selected"] = function() 
		print(data)
		Cardsource = Cardtable[data]
		Checkclear.card = true
		local cardtable = CardData(0)
		Cardname = "No name found"
        for i,v in pairs(cardtable)do
            if v == Cardsource then Cardname = i break end
        end
		print(Checkclear.player,Checkclear.card)
		if Checkclear.player == true and Checkclear.card == true then 
			Checkclear.allgood = true end
			GetCardBtn.SetText("Sabotage ".. card .. " Card") 
			StartCardmissionBtn.SetInteractable(Checkclear.allgood)
	end
	return ret;
end
--Promt list logic for player list
function TargetPlayerClicked()
	
	local players = Game.Game.Players--filter(Game.Game.Players, function (p) return p.ID ~= Game.Us.ID end);
	local options = map(players, PlayerButton);
	UI.PromptFromList("Select the player you'd like to give gold to", options);
end
function PlayerButton(player)
	Checkclear.player = true
	if Checkclear.player == true and Checkclear.card == true then 
		Checkclear.allgood = true end
		print(Checkclear.player,Checkclear.card)
	local name = player.DisplayName(nil, false);
	local ret = {};
	ret["text"] = name;
	ret["selected"] = function() 
		TargetPlayerBtn.SetText(name);
		TargetPlayerID = player.ID;
		StartCardmissionBtn.SetInteractable(Checkclear.allgood)
	end
	return ret;
end
-- Target Agent logic
function TargetAgentLogic(rootParent, setMaxSize, setScrollable, game, close)
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	Agentlist = Values2TableAgent(publicdata.Ranklist)
	UI.CreateLabel(vert).SetText("Choose an Agent to assassinate");

	for i,v in pairs (Agentlist) do
		if Agentlist[i].agentHomeAgency ~= publicdata[ID].Agency.agencyname then --making sure our own agents dont appear there
			temptable = {agentid = v.agentID, playeridofagent = i}
			UI.CreateButton(vert).SetText("Agent " .. v.codename).SetOnClick(function () CreateOrder(2,close, temptable) end) 
		end
	end
end
-- Create orders
function CreateOrder(type,close, data)
	close()

	local baseload = {}
	baseload.entrytype = 3
	baseload.text = Findmatch(publicdata[ID].Agency.Agentlist,Agentdata,"agentID")
	baseload.cost = MissionCost

	--local killagent_Index = Findmatch(publicdata[ID].Agency.Agentlist,data,"agentID")
	local agentsent = Agentdata -- just to clear up the name
	local datasent2 = 0
	if Targettype ~= "KillAgent" and Targettype ~= "Killcard" and Game.LatestStanding.Territories[SelectedTerritory.ID].FogLevel > 3 then UI.Alert("Must pick a territory with visible Territory") return end

	Game.SendGameCustomMessage("new " .. BaseName .. "...", baseload, function(returnValue)
		local datasent = 0
		local msg = nil
		if type == 0 then -- getting territory logic
			msg = "Agent " .. publicdata[ID].Agency.Agentlist[baseload.text].codename .. " Has begun a operation in " .. SelectedTerritory.Name
			datasent = SelectedTerritory.ID


		elseif type == 1 then -- getting card logic
			msg = "Agent " .. publicdata[ID].Agency.Agentlist[baseload.text].codename .. " Has begun Sabotaging political influence in " .. TargetPlayerBtn.GetText() .. "'s land" .." ("..Cardname..")"
			datasent = Cardsource
		elseif type == 2 then -- getting agent on agent action
			targetagentplayerID = data.playeridofagent
			indexofagent = data.agentid
			print(targetagentplayerID)
			print(indexofagent)
			print(publicdata[ID].Agency.Agentlist[baseload.text].codename)
			print(publicdata[targetagentplayerID].Agency.Agentlist[indexofagent].codename)
			msg = "Agent " .. publicdata[ID].Agency.Agentlist[baseload.text].codename .. " has began a assassination operation on agent " .. publicdata[targetagentplayerID].Agency.Agentlist[indexofagent].codename
			datasent = data
			datasent2 = publicdata[targetagentplayerID].Agency.Agentlist[indexofagent].PlayerofAgentID
		end
		Orderstartwith = Targettype
		local SelectedTerritoryID 
		local payload = Orderstartwith  .. datasent .. ';;' .. agentsent .. ';;' .. Nonill(TargetPlayerID) .. ';;' .. Nonill(datasent2)
		local orders = Game.Orders;
		table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload));
		Game.Orders = orders;
	end)
end