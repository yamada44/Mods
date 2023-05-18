
function Client_PresentConfigureUI(rootParent)

  	Maxpictures = 5

NewrootParent = rootParent

	if (not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use this mod");
		return;
	end


	if Mod.Settings.Unitdata == nil then Mod.Settings.Unitdata = {} end --Init variables
	 uniteconfig =	Mod.Settings.Unitdata

	local vert0 = UI.CreateVerticalLayoutGroup(rootParent);
	UI.CreateLabel(vert0).SetText('Tip 1: If UI messes up, uncheck mod box and recheck\nTip 2: note Loading Unit types might take a second').SetColor('#F3FFAE');


	if Mod.Settings.access == nil then Mod.Settings.access = 1 end
	 access = Mod.Settings.access
	 if Mod.Settings.BeforeMax == nil then Mod.Settings.BeforeMax = 1 end
	 BeforeMax = Mod.Settings.BeforeMax
-- End of Init


	InputFieldTable = {}

	local vert2 = UI.CreateVerticalLayoutGroup(rootParent);

-- setting up amount of special units to have
	local row0 = UI.CreateHorizontalLayoutGroup(vert2);
	InputFieldTable.text0 = UI.CreateLabel(row0).SetText('How many Unit Types')
	InputFieldTable.UnitTypeMax = UI.CreateNumberInputField(row0)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(BeforeMax);
		UnitTypeMax = InputFieldTable.UnitTypeMax.GetValue()


	RefreshButton = UI.CreateButton(row0).SetText("Refresh").SetColor("#00DD00").SetOnClick(UnitCreation);

	if (access == 3 )then 
			UI.Alert('Tip: If UI messes up, uncheck mod box and recheck')
	end
	if access == 2 or access == 3 then
		UnitCreation()
	end
	 
end

function UnitCreation()
UnitTypeMax = InputFieldTable.UnitTypeMax.GetValue()



	if access == 2 then
		UI.Alert('Regenerated UI Types')

		for i = 1, BeforeMax do  -- deleting UI before generating a new one


			UI.Destroy(InputFieldTable[i].text1)
			UI.Destroy(InputFieldTable[i].text2)
			UI.Destroy(InputFieldTable[i].text3)
			UI.Destroy(InputFieldTable[i].text4)
			UI.Destroy(InputFieldTable[i].text5)
			UI.Destroy(InputFieldTable[i].text6)
			UI.Destroy(InputFieldTable[i].text7)
			UI.Destroy(InputFieldTable[i].text8)
			UI.Destroy(InputFieldTable[i].text9)
			UI.Destroy(InputFieldTable[i].text10)
			UI.Destroy(InputFieldTable[i].text11)
			UI.Destroy(InputFieldTable[i].text12)
			UI.Destroy(InputFieldTable[i].text13)
			UI.Destroy(InputFieldTable[i].text14)
			UI.Destroy(InputFieldTable[i].text15)
			UI.Destroy(InputFieldTable[i].text16)
			UI.Destroy(InputFieldTable[i].costInputField)
			UI.Destroy(InputFieldTable[i].powerInputField)
			UI.Destroy(InputFieldTable[i].maxUnitsField)
			UI.Destroy(InputFieldTable[i].Image)
			UI.Destroy(InputFieldTable[i].Shared)
			UI.Destroy(InputFieldTable[i].Visible)
			UI.Destroy(InputFieldTable[i].MaxServer)
			UI.Destroy(InputFieldTable[i].Name)
			UI.Destroy(InputFieldTable[i].Minlife)
			UI.Destroy(InputFieldTable[i].Maxlife)
			UI.Destroy(InputFieldTable[i].Transfer)
			UI.Destroy(InputFieldTable[i].Level)
			UI.Destroy(InputFieldTable[i].row1)
			UI.Destroy(InputFieldTable[i].row2)
			UI.Destroy(InputFieldTable[i].row3)
			UI.Destroy(InputFieldTable[i].row4)
			UI.Destroy(InputFieldTable[i].row6)
			UI.Destroy(InputFieldTable[i].row7)
			UI.Destroy(InputFieldTable[i].row5)
			UI.Destroy(InputFieldTable[i].row9)
			UI.Destroy(InputFieldTable[i].row8)
			UI.Destroy(InputFieldTable[i].row10)
			UI.Destroy(InputFieldTable[i].row11)
			UI.Destroy(InputFieldTable[i].row12)
			UI.Destroy(InputFieldTable[i].row13)
			UI.Destroy(InputFieldTable[i].row14)


		end
	end

	if UnitTypeMax < 0 or UnitTypeMax > 6 then 
	UI.Alert('Max unit types 6.\nMin unit types 1\n Reset to Default settings')
	UnitTypeMax = 1
	end



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

		local minlife = uniteconfig[i].Minlife
		if (minlife == nil ) then minlife = 0 end 

		local maxlife = uniteconfig[i].Maxlife
		if (maxlife == nil ) then maxlife = 0 end 

		local transfer = uniteconfig[i].Transfer
		if (transfer == nil ) then transfer = 0 end 

		local level = uniteconfig[i].Level
		if (level == nil ) then level = 0 end 

		local active = uniteconfig[i].Active
		if (active == nil ) then active = 0 end 

		--setting up the UI and all its fields
	local vert = UI.CreateVerticalLayoutGroup(NewrootParent);

	-- how much Gold will this army cost
    InputFieldTable[i].row1 = UI.CreateHorizontalLayoutGroup(vert);
	local row1 = InputFieldTable[i].row1
	InputFieldTable[i].text1 = UI.CreateLabel(row1).SetText('Unit Type '..i).SetColor('#00D4FF');
	InputFieldTable[i].text2 = UI.CreateLabel(row1).SetText('\nHow much gold it costs to buy Unit ' .. i);
    InputFieldTable[i].costInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(40)
		.SetValue(cost);

		--how powerful each unit is in army amounts
		InputFieldTable[i].row2 = UI.CreateHorizontalLayoutGroup(vert);
		local row2 = InputFieldTable[i].row2
	InputFieldTable[i].text3 = UI.CreateLabel(row2).SetText('How powerful Unit ' .. i .. ' is (in armies)');
	InputFieldTable[i].powerInputField = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(30)
		.SetValue(power);

		--max units each unit type can have
		InputFieldTable[i].row3 = UI.CreateHorizontalLayoutGroup(vert);
		local row3 = InputFieldTable[i].row3
	InputFieldTable[i].text4 = UI.CreateLabel(row3).SetText('How many units each player can have at a time\n(Set to 0 to disable this unit)');
	InputFieldTable[i].maxUnitsField = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(5)
		.SetValue(maxunits);

	-- Present Minimum life UI
	InputFieldTable[i].row10 = UI.CreateHorizontalLayoutGroup(vert);
	local row10 = InputFieldTable[i].row10
	InputFieldTable[i].text12 = UI.CreateLabel(row10).SetText('Minimum Turns alive');
InputFieldTable[i].Minlife = UI.CreateNumberInputField(row10)
	.SetSliderMinValue(0)
	.SetSliderMaxValue(99)
	.SetValue(minlife);

	-- present Maximum life UI
	InputFieldTable[i].row11 = UI.CreateHorizontalLayoutGroup(vert);
	local row11 = InputFieldTable[i].row11
	InputFieldTable[i].text13 = UI.CreateLabel(row11).SetText('Max Turns alive (Set to 0 to disable life range for Units)');
InputFieldTable[i].Maxlife = UI.CreateNumberInputField(row11)
	.SetSliderMinValue(0)
	.SetSliderMaxValue(100)
	.SetValue(maxlife);

	-- presenting image UI
		InputFieldTable[i].row4 = UI.CreateHorizontalLayoutGroup(vert);
		local row4 = InputFieldTable[i].row4
		InputFieldTable[i].text5 = UI.CreateLabel(row4).SetText('What Image will this Unit have');
	InputFieldTable[i].Image = UI.CreateNumberInputField(row4)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(Maxpictures)
		.SetValue(picture);

		-- transfer units on death settings
		InputFieldTable[i].row12 = UI.CreateHorizontalLayoutGroup(vert);
		local row12 = InputFieldTable[i].row12
		InputFieldTable[i].text14 = UI.CreateLabel(row12).SetText('How many transfers between players you want this unit to have before death\n (-1 for infinite)\n (0 to disable)');
		InputFieldTable[i].Transfer = UI.CreateNumberInputField(row12)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(10)
		.SetValue(transfer);

		-- Leveling for units
		InputFieldTable[i].row13 = UI.CreateHorizontalLayoutGroup(vert);
		local row13 = InputFieldTable[i].row13
		InputFieldTable[i].text15 = UI.CreateLabel(row13).SetText('How many troops needed to kill to level up\nleveling up adds current army power to existing army power\n(0 to disable)');
		InputFieldTable[i].Level = UI.CreateNumberInputField(row13)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(500)
		.SetValue(level);

		-- turn unit becomes Active
		InputFieldTable[i].row14 = UI.CreateHorizontalLayoutGroup(vert);
		local row14 = InputFieldTable[i].row14
		InputFieldTable[i].text16 = UI.CreateLabel(row14).SetText('Unit is locked till this turn\n(0 to disable)');
		InputFieldTable[i].Active = UI.CreateNumberInputField(row14)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(200)
		.SetValue(active);

		--Max amount shared between players
		InputFieldTable[i].row6 = UI.CreateHorizontalLayoutGroup(vert);
		local row6 = InputFieldTable[i].row6
		InputFieldTable[i].text6 = UI.CreateLabel(row6).SetText('Check if you want the Maximum amount to be shared between all players');
		InputFieldTable[i].Shared = UI.CreateCheckBox(row6).SetIsChecked(shared).SetText('')

		--Visible unit setting
		InputFieldTable[i].row7 = UI.CreateHorizontalLayoutGroup(vert);
		local row7 = InputFieldTable[i].row7
		InputFieldTable[i].text7 = UI.CreateLabel(row7).SetText('Check if you want this unit visible at all times');
		InputFieldTable[i].Visible = UI.CreateCheckBox(row7).SetIsChecked(visible).SetText('')

		-- max useage for entire game
		InputFieldTable[i].row9 = UI.CreateHorizontalLayoutGroup(vert);
		local row9 = InputFieldTable[i].row9
		InputFieldTable[i].text8 = UI.CreateLabel(row9).SetText('Check if you want this unit to have a max useage for the entire game');
		InputFieldTable[i].MaxServer = UI.CreateCheckBox(row9).SetIsChecked(maxserver).SetText('')
		
		--name of unit
		InputFieldTable[i].row5 = UI.CreateHorizontalLayoutGroup(vert)
		local row5 = InputFieldTable[i].row5
		InputFieldTable[i].text9 = UI.CreateLabel(row5).SetText('Name of Unit in buy menu');
		InputFieldTable[i].Name = UI.CreateTextInputField(vert)
		.SetPlaceholderText(" Name of Unit Type        ").SetText(name)
		.SetFlexibleWidth(1)
		.SetCharacterLimit(20)

		--spacer
		InputFieldTable[i].row8 = UI.CreateHorizontalLayoutGroup(vert)
		local row8 = InputFieldTable[i].row8
		InputFieldTable[i].text10 = UI.CreateEmpty(row8)
		InputFieldTable[i].text11 = UI.CreateLabel(row8).SetText('\n')


	
	end	
	

	access = 2
	BeforeMax = UnitTypeMax
InputFieldTable.BeforeMax = UnitTypeMax
end

