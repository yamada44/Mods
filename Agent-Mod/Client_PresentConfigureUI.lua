
function Client_PresentConfigureUI(rootParent)
    Maplimit = 12
    Modlimit = 5


	local agentcost = Mod.Settings.Agentcost;
	if agentcost == nil then
		agentcost = 50;
	end

	local decoycost = Mod.Settings.Decoycost;
	if decoycost == nil then
		decoycost = 100;
	end

	local citylost = Mod.Settings.Citylost;
	if citylost == nil then
		citylost = 1;
	end

	local cityremoved = Mod.Settings.Cityremoved;
	if cityremoved == nil then
		cityremoved = true;
	end

	local cardsremoved = Mod.Settings.Cardsremoved;
	if cardsremoved == nil then
		cardsremoved = true;
	end

	local creation = Mod.Settings.Creationfee;
	if creation == nil then
		creation = 1;
	end
    
	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row0 = UI.CreateHorizontalLayoutGroup(vert); -- adding the correct map


	

    local row01 = UI.CreateHorizontalLayoutGroup(vert); -- Agent Cost
	UI.CreateButton(row01).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("The cost for creating a Spy Agency"); end);
	UI.CreateLabel(row01).SetText('How much it cost to create an agency');
    Inportcreationfeecost = UI.CreateNumberInputField(row01)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1000)
		.SetValue(creation);

    local row1 = UI.CreateHorizontalLayoutGroup(vert); -- Agent Cost
	UI.CreateButton(row1).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How much gold does it cost to buy a new Agent/assassin"); end);
	UI.CreateLabel(row1).SetText('Cost for a undercover Agent/Assassination');
    InportAgentcost = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1000)
		.SetValue(agentcost);

	local row2 = UI.CreateHorizontalLayoutGroup(vert); -- Decoy cost
	UI.CreateButton(row2).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How much gold does it cost to buy a new Decoy Agent. A Decoy agent dies before your agents/Special units die"); end);
	UI.CreateLabel(row2).SetText('Cost for a undercover Decoy Agent');
	InportDecoycost = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1000)
		.SetValue(decoycost);

	local row3 = UI.CreateHorizontalLayoutGroup(vert); -- amount of cities removed when an assassin attempt successful on cities
	UI.CreateButton(row3).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Agents can remove cities on the map via Sabotage, how many cities at once will be removed when a sabotage is successful"); end);
	UI.CreateLabel(row3).SetText('How many cities removed when a undercover agent Sabotage');
	InportCityamount = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(10)
		.SetValue(citylost);

	local row4 = UI.CreateHorizontalLayoutGroup(vert); -- can cities allowed to be removed
	UI.CreateButton(row4).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("should city removal be allowed for agents to remove"); end);
	UI.CreateLabel(row4).SetText('Can cities be removed via undercover agents');
	InportCityallowed = UI.CreateCheckBox(row4).SetIsChecked(cityremoved).SetText('')

	local row5 = UI.CreateHorizontalLayoutGroup(vert); -- can cards be removed
	UI.CreateButton(row5).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("should card removal be allowed for agents to remove"); end);
	UI.CreateLabel(row5).SetText('Can cards be removed via undercover Agents');
	InportCardsallowed = UI.CreateCheckBox(row5).SetIsChecked(cardsremoved).SetText('')



end