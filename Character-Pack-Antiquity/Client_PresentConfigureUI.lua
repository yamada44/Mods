
function Client_PresentConfigureUI(rootParent)

  	UnitTypeMax = 5
  	Maxpictures = 5
NewrootParent = rootParent

	if (not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use this mod");
		return;
	end


	if Mod.Settings.Unitdata == nil then Mod.Settings.Unitdata = {} end
	 uniteconfig =	Mod.Settings.Unitdata

	local vert0 = UI.CreateVerticalLayoutGroup(rootParent);
	UI.CreateLabel(vert0).SetText('Tip: If UI messes up, uncheck mod box and recheck').SetColor('#F3FFAE');


	if Mod.Settings.test == nil then Mod.Settings.test = false end
	local test = Mod.Settings.test


	InputFieldTable = {}

	if 	InputFieldTable[20] == nil then InputFieldTable[20] = {} end



	local vert2 = UI.CreateVerticalLayoutGroup(rootParent);

	local row10 = UI.CreateHorizontalLayoutGroup(vert2);
	UI.CreateLabel(row10).SetText('test');
	InputFieldTable[20].test = UI.CreateCheckBox(row10).SetIsChecked(test).SetText('').SetOnValueChanged(New)

	if InputFieldTable[20].test.GetIsChecked() == true then
		New()
	end








	
	
	
	
	
	


	
	

end


function New()
if InputFieldTable[20].test.GetIsChecked() == true then 

	for i = 1, UnitTypeMax do -- looping through all the units so you dont have to repeat code
		if uniteconfig[i] == nil then uniteconfig[i] = {}end -- making sure the tables exist

		if 	InputFieldTable[i] == nil then InputFieldTable[i] = {} end

		local picture = uniteconfig[i].image -- initializing all of the defaults if nil
		if picture ==nil then picture = 1 end

		local power = uniteconfig[i].unitpower;
		if power == nil then power = 1; end
	
		local cost = uniteconfig[i].unitcost;
		if cost == nil then cost = 1; end
	
		local maxunits = uniteconfig[i].Maxunits;
		if maxunits == nil then maxunits = 0; end;

		local shared = uniteconfig[i].Shared
		if shared == nil then shared = false end

		local visible = uniteconfig[i].Visible
		if visible == nil then visible = false end 

		local maxserver = uniteconfig[i].MaxServer
		if maxserver == nil then maxserver = false end 
		
		local name = uniteconfig[i].Name
		if (name == nil ) then name = '' end 

   
		--setting up the UI and all its fields
	local vert = UI.CreateVerticalLayoutGroup(NewrootParent);

    local row1 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row1).SetText('Unit Type '..i).SetColor('#00D4FF');
	UI.CreateLabel(row1).SetText('\nHow much gold it costs to buy Unit ' .. i);

    InputFieldTable[i].costInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(40)
		.SetValue(cost);


	local row2 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row2).SetText('How powerful Unit ' .. i .. ' is (in armies)');
	InputFieldTable[i].powerInputField = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(30)
		.SetValue(power);

	local row3 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row3).SetText('How many units each player can have at a time\n(Set to 0 to disable this unit)');
	InputFieldTable[i].maxUnitsField = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(5)
		.SetValue(maxunits);

	

		local row4 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row4).SetText('What Image will this Unit have');
	InputFieldTable[i].Image = UI.CreateNumberInputField(row4)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(Maxpictures)
		.SetValue(picture);

		local row6 = UI.CreateHorizontalLayoutGroup(vert);
		UI.CreateLabel(row6).SetText('Check if you want the Maximum amount to be shared between all players');
		InputFieldTable[i].Shared = UI.CreateCheckBox(row6).SetIsChecked(shared).SetText('')

		local row7 = UI.CreateHorizontalLayoutGroup(vert);
		UI.CreateLabel(row7).SetText('Check if you want this unit visible at all times');
		InputFieldTable[i].Visible = UI.CreateCheckBox(row7).SetIsChecked(visible).SetText('')

		local row9 = UI.CreateHorizontalLayoutGroup(vert);
		UI.CreateLabel(row9).SetText('Check if you want this unit to have a max useage for the entire game');
		InputFieldTable[i].MaxServer = UI.CreateCheckBox(row9).SetIsChecked(maxserver).SetText('')
		
		local row5 = UI.CreateHorizontalLayoutGroup(vert)
		UI.CreateLabel(row5).SetText('Name of Unit in buy menu');
		InputFieldTable[i].Name = UI.CreateTextInputField(vert)
		.SetPlaceholderText(" Name of Unit Type        ").SetText(name)
		.SetFlexibleWidth(1)
		.SetCharacterLimit(20)


		local row8 = UI.CreateHorizontalLayoutGroup(vert)
		UI.CreateEmpty(row8)
		UI.CreateLabel(row8).SetText('\n')
	
	end
end
end