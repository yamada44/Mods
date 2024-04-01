function Client_PresentConfigureUI(rootParent)
  	Maxpictures = 5
	NewrootParent = rootParent
	InputFieldTable = {}
	TempUI = {}
	Minunits = 1
	Maxunits = 8

	if (not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
		UI.Alert("You must update your app to the latest version to use this mod");
		return;
	end

	if Mod.Settings.Unitdata == nil then Mod.Settings.Unitdata = {} end --Init variables
	uniteconfig = Mod.Settings.Unitdata

	local vert0 = UI.CreateVerticalLayoutGroup(rootParent);
	UI.CreateLabel(vert0).SetText('Tip 1: If UI messes up, uncheck mod box and recheck\nTip 2: note Loading Unit types might take a second\nTip 3: You may have a old template. remove mod, save template and reinstall mod').SetColor('#F3FFAE');

	--Set up access point and max values
	if Mod.Settings.access == nil then Mod.Settings.access = 1 end
	access = Mod.Settings.access
	if Mod.Settings.BeforeMax == nil then Mod.Settings.BeforeMax = 1 end
	BeforeMax = Mod.Settings.BeforeMax

	-- End of Init
	local vert2 = UI.CreateVerticalLayoutGroup(rootParent)

	-- setting up amount of special units to have
	local row0 = UI.CreateHorizontalLayoutGroup(vert2);
	UI.CreateButton(row0).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This determines the amount of unit types you can create at once\nMax of ".. Maxunits) end)
	InputFieldTable.text0 = UI.CreateLabel(row0).SetText('How many Unit Types')
	InputFieldTable.UnitTypeMax = UI.CreateNumberInputField(row0)
		.SetSliderMinValue(Minunits)
		.SetSliderMaxValue(Maxunits)
		.SetValue(BeforeMax)
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

	if access == 2 then -- Setting up UI again
		UI.Alert('Regenerated UI Types')
		Destroy()
	end

	if UnitTypeMax < Minunits or UnitTypeMax > Maxunits then  -- make sure unit types are between Min and max values (values can be found at top of screen)
	UI.Alert('Max unit types ' .. Maxunits .. ' .\nMin unit types '..Minunits..'\n Reset to Default settings')
	UnitTypeMax = 1
	end

	for i = 1, UnitTypeMax do -- looping through all the units so you dont have to repeat code
		local vert = UI.CreateVerticalLayoutGroup(NewrootParent);
		local color = '#FF697A' -- reddish
		local templatetext = 'Empty Unit Template: '.. i

		if uniteconfig[i] == nil then uniteconfig[i] = {} end -- making sure the tables exist
		if InputFieldTable[i] == nil then InputFieldTable[i] = {} end

		InputFieldTable[i].TempCreated = uniteconfig[i].TempCreated
		if InputFieldTable[i].TempCreated == nil then InputFieldTable[i].TempCreated = false 
		elseif InputFieldTable[i].TempCreated == true then 
			TempAlreadyCreated(i)
			templatetext = 'Stored ' .. uniteconfig[i].Name .. ' Template'
			color = '#00E9FF'
		end
		InputFieldTable[i].TemplateStored = uniteconfig[i].TemplateStored
		if InputFieldTable[i].TemplateStored == nil then InputFieldTable[i].TemplateStored = false end

		InputFieldTable[i].row000 = UI.CreateHorizontalLayoutGroup(vert);
		local row000 = InputFieldTable[i].row000
		--UI.CreateButton(row000).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("your stored Unit template"); end);

		InputFieldTable[i].text180 = UI.CreateLabel(row000).SetText(templatetext).SetColor(color)    
		InputFieldTable[i].Template = UI.CreateCheckBox(row000).SetIsChecked(false).SetText('').SetOnValueChanged(function () Unittemplates(vert, i) end)	
	end

	access = 2
	BeforeMax = UnitTypeMax
	InputFieldTable.BeforeMax = UnitTypeMax
end

function Unittemplates(vert, i)
	InputFieldTable[i].TempCreated = true
	InputFieldTable[i].Template.SetInteractable(false) 
	InputFieldTable[i].TemplateStored = false

	local picture = uniteconfig[i].image -- initializing all of the defaults if nil
	if picture ==nil then picture = 1 end

	local power = uniteconfig[i].unitpower;
	if power == nil then power = 0; end

	local cost = uniteconfig[i].unitcost;
	if cost == nil then cost = 1; end

	local maxunits = uniteconfig[i].Maxunits;
	if maxunits == nil then maxunits = 1; end;

	local shared = uniteconfig[i].Shared
	if shared == nil then shared = false end

	local visible = uniteconfig[i].Visible
	if visible == nil then visible = false end 

	local maxserver = uniteconfig[i].MaxServer
	if maxserver == nil then maxserver = 0 end 
	
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

	local defend = uniteconfig[i].Defend
	if (defend == nil ) then defend = 0 end 

	local altmoves = uniteconfig[i].Altmoves
	if (altmoves == nil)then altmoves = false end

	local cooldown = uniteconfig[i].Cooldown
	if (cooldown == nil ) then cooldown = 0 end 

	local assass = uniteconfig[i].Assassination
	if (assass == nil ) then assass = 0 end 

	local hostrules = uniteconfig[i].HostRules
	if (hostrules == nil)then hostrules = ''end

	local attmax = uniteconfig[i].AttackMax
	if (attmax == nil ) then attmax = 0 end 

	local auto = uniteconfig[i].Autovalue
	if (auto == nil ) then auto = 0 end 

	local combatorder = uniteconfig[i].CombatOrder
	if (combatorder == nil) then combatorder = 2 end

	local onCity = uniteconfig[i].Oncity
	if (onCity == nil or onCity == false or onCity == true) then onCity = 0 end

	local slot = uniteconfig[i].Slot
	if slot == nil then
	slot = ""
	else 
	slot = uniteconfig[i].Slotstore 
	end

	--setting up the UI and all its fields

	-- how much Gold will this army cost
    InputFieldTable[i].row1 = UI.CreateHorizontalLayoutGroup(vert);
	local row1 = InputFieldTable[i].row1
	InputFieldTable[i].text1 = UI.CreateLabel(row1).SetText('Unit Type '..i).SetColor('#00D4FF')
	InputFieldTable[i].text2 = UI.CreateLabel(row1).SetText('\nHow much gold it costs to buy Unit ' .. i)
	InputFieldTable[i].unitcost = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(40)
		.SetValue(cost);
	UI.CreateButton(row1).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("The Cost of this unit in Gold. Unit will not appear if commerce is turned off"); end);

	--Min attack range
	InputFieldTable[i].row2 = UI.CreateHorizontalLayoutGroup(vert);
	local row2 = InputFieldTable[i].row2
	UI.CreateButton(row2).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This is the first setting of 2 settings that decides a units Power(in armies). Power works with a range. you decide the Minimum-Maximum range. the computer will decide a random value between those two numbers. that number is the attack power of the unit. Set min & max the same to guarantee a value"); end);
	InputFieldTable[i].text3 = UI.CreateLabel(row2).SetText('Min power range for Unit ' .. i .. ' (in armies)').SetColor('#dbddf4')
	InputFieldTable[i].unitpower = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(30)
		.SetValue(power)

	--Max attack range
	InputFieldTable[i].row20 = UI.CreateHorizontalLayoutGroup(vert);
	local row20 = InputFieldTable[i].row20
	UI.CreateButton(row20).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This is the second setting of 2 settings that decides a units Power(in armies). Power works with a range. you decide the Minimum-Maximum range. the computer will decide a random value between those two numbers. that number is the attack power of the unit. Set min & max the same to guarantee a value"); end);
	InputFieldTable[i].text22 = UI.CreateLabel(row20).SetText('Max power range for Unit ' .. i .. ' (in armies)')
	InputFieldTable[i].AttackMax = UI.CreateNumberInputField(row20)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(30)
		.SetValue(attmax)

	--how powerful each unit is in defense 
	InputFieldTable[i].row15 = UI.CreateHorizontalLayoutGroup(vert);
	local row15 = InputFieldTable[i].row15
	UI.CreateButton(row15).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("The Defending power in terms of armies\nthis units health is decided between attack/defence power. which ever is higher"); end);
	InputFieldTable[i].text17 = UI.CreateLabel(row15).SetText('How powerful Unit ' .. i .. ' is when defending (in armies)').SetColor('#dbddf4')
	InputFieldTable[i].Defend = UI.CreateNumberInputField(row15)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(30)
		.SetValue(defend)

	--max units each unit type can have
	InputFieldTable[i].row3 = UI.CreateHorizontalLayoutGroup(vert);
	local row3 = InputFieldTable[i].row3
	UI.CreateButton(row3).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This setting decides how many units of this type you can have on the field at a time\nSet to 0 to disable this unit entirely"); end);
	InputFieldTable[i].text4 = UI.CreateLabel(row3).SetText('How many units each player can have at a time')
	InputFieldTable[i].Maxunits = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(maxunits)

	-- Present Minimum life UI
	InputFieldTable[i].row10 = UI.CreateHorizontalLayoutGroup(vert);
	local row10 = InputFieldTable[i].row10
	UI.CreateButton(row10).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This is the first setting of 2 settings that decides a units life span. Life span works with a range. you decide the Minimum-Maximum range. the computer will decide a random value between those two numbers. that number is the turn it will die. Set Max value to 0 to disable"); end);
	InputFieldTable[i].text12 = UI.CreateLabel(row10).SetText('Life Span Minimum Range').SetColor('#dbddf4')
	InputFieldTable[i].Minlife = UI.CreateNumberInputField(row10)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(99)
		.SetValue(minlife)

	-- present Maximum life UI
	InputFieldTable[i].row11 = UI.CreateHorizontalLayoutGroup(vert);
	local row11 = InputFieldTable[i].row11
	UI.CreateButton(row11).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This is the second setting of 2 settings that decides a units life span\nBy setting this setting to 0. you disable both Life span settings and this feature"); end);
	InputFieldTable[i].text13 = UI.CreateLabel(row11).SetText('Life span Maximum Range')
	InputFieldTable[i].Maxlife = UI.CreateNumberInputField(row11)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(100)
		.SetValue(maxlife)

	-- image UI
	InputFieldTable[i].row4 = UI.CreateHorizontalLayoutGroup(vert);
	local row4 = InputFieldTable[i].row4
	UI.CreateButton(row4).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("The number choosen corresponds with the images listed above\nSet to 0 to have random image every Spawn"); end);
	InputFieldTable[i].text5 = UI.CreateLabel(row4).SetText('What Image will this Unit have').SetColor('#dbddf4')
	InputFieldTable[i].image = UI.CreateNumberInputField(row4)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(Maxpictures)
		.SetValue(picture)

	-- transfer units on death settings
	InputFieldTable[i].row12 = UI.CreateHorizontalLayoutGroup(vert);
	local row12 = InputFieldTable[i].row12
	UI.CreateButton(row12).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("When this unit dies, instead of dying. its transfered to the person that killed it. Neutrals wont work. every time this unit *dies*. this setting's value goes down by 1. once it reaches 0 the unit dies for real\nSet to 0 to disable\nSet to -1 to have unlimited tranfers"); end);
	InputFieldTable[i].text14 = UI.CreateLabel(row12).SetText('Transfers unit upon death')
	InputFieldTable[i].Transfer = UI.CreateNumberInputField(row12)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(10)
		.SetValue(transfer)

	-- Leveling for units
	InputFieldTable[i].row13 = UI.CreateHorizontalLayoutGroup(vert);
	local row13 = InputFieldTable[i].row13
	UI.CreateButton(row13).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("when this unit attacks someone it gains XP from the enemy troops killed(including special units). The setting determines how many troops are needed to kill before its first level up. it does retain XP between battles. When the unit levels up, its power/defence/health increase by there base amounts\nSet to 0 to disable"); end);
	InputFieldTable[i].text15 = UI.CreateLabel(row13).SetText('How many troops needed to level up this unit').SetColor('#dbddf4')
	InputFieldTable[i].Level = UI.CreateNumberInputField(row13)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(500)
		.SetValue(level)

	-- turn unit becomes Active
	InputFieldTable[i].row14 = UI.CreateHorizontalLayoutGroup(vert);
	local row14 = InputFieldTable[i].row14
	UI.CreateButton(row14).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This setting corrospondes to the turns in game. This Unit will be unable to be purchased until this Turn. "); end);
	InputFieldTable[i].text16 = UI.CreateLabel(row14).SetText('Unit is locked till this turn')
	InputFieldTable[i].Active = UI.CreateNumberInputField(row14)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(200)
		.SetValue(active)

	-- max useage for entire game
	InputFieldTable[i].row9 = UI.CreateHorizontalLayoutGroup(vert);
	local row9 = InputFieldTable[i].row9
	UI.CreateButton(row9).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This setting is the maximum amount of units of this type that can be spawned over the entire lifetime of the Game. This is compatiable with the shared feature\nSet to 0 to disable"); end);
	InputFieldTable[i].text8 = UI.CreateLabel(row9).SetText('Max units Spawned over entire game').SetColor('#dbddf4')
	InputFieldTable[i].MaxServer = UI.CreateNumberInputField(row9)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(50)
		.SetValue(maxserver)

	--cool down for units
	InputFieldTable[i].row17 = UI.CreateHorizontalLayoutGroup(vert);
	local row17 = InputFieldTable[i].row17
	UI.CreateButton(row17).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This setting determines the amount of turns needed to wait after buying this unit\nSet to 0 to disable"); end);
	InputFieldTable[i].text19 = UI.CreateLabel(row17).SetText('Cool down Timer for unit')
	InputFieldTable[i].Cooldown = UI.CreateNumberInputField(row17)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(100)
		.SetValue(cooldown)

	--Assassinations
	InputFieldTable[i].row19 = UI.CreateHorizontalLayoutGroup(vert);
	local row19 = InputFieldTable[i].row19
	UI.CreateButton(row19).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("To determine how hard it is for an Assassination to kill this unit with the I.S. Agency mod. Set to 0 to make impossible to kill") end)
	InputFieldTable[i].text21 = UI.CreateLabel(row19).SetText('Assassination/Sabotage level').SetColor('#dbddf4')
	InputFieldTable[i].Assassination = UI.CreateNumberInputField(row19)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(5)
		.SetValue(assass)

	--Auto placer
	InputFieldTable[i].row22 = UI.CreateHorizontalLayoutGroup(vert);
	local row22 = InputFieldTable[i].row22
	UI.CreateButton(row22).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Any Territory with this value at the start of the game will be given this unit. 40 auto placed units shared between all players and unit types\nSet to 0 to disable"); end);
	InputFieldTable[i].text24 = UI.CreateLabel(row22).SetText('Auto place this unit on any territory with this value at game creation')
	InputFieldTable[i].Autovalue = UI.CreateNumberInputField(row22)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(5000)
		.SetValue(auto)

	--Combat order
	InputFieldTable[i].row21 = UI.CreateHorizontalLayoutGroup(vert);
	local row21 = InputFieldTable[i].row21
	UI.CreateButton(row21).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Select the order in which the special unit does combat\n1 - special unit does combat before armies\n2 - special unit does combat after armies"); end);
	InputFieldTable[i].text23 = UI.CreateLabel(row21).SetText('Select the Combat order').SetColor('#dbddf4')
	InputFieldTable[i].Combat = UI.CreateNumberInputField(row21)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(2)
		.SetValue(combatorder)

	--Only on cities
	InputFieldTable[i].row23 = UI.CreateHorizontalLayoutGroup(vert);
	local row23 = InputFieldTable[i].row23
	UI.CreateButton(row23).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("You can only Create this Unit type on this Structure\n0 - Feature disabled\n1 - Cities\n2 - Army Camp\n3 - Mine\n4 - Smelter\n5 - Crafter\n6 - Market\n7 - Army Cache\n8 - Money Cache\n9 - Money Cache\n10 - Resource Cache\n11 - Mercenary Camp\n12 - Man and gun\n13 - Arena\n14 - Hospital\n15 - Dig Site\n16 - Artillery\n17 - Mortar\n18 - Book") end)
	InputFieldTable[i].text25 = UI.CreateLabel(row23).SetText('Only deploy on Structure')
	InputFieldTable[i].City = UI.CreateNumberInputField(row23)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(18)
		.SetValue(onCity)

	--Max amount shared between players
	InputFieldTable[i].row6 = UI.CreateHorizontalLayoutGroup(vert);
	local row6 = InputFieldTable[i].row6
	UI.CreateButton(row6).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("The maximum amount of units is shared between all players. If *Max units Spawned over entire game* is turned on, The share feature will switch from sharing the *How many units each player can have at a time* value to the previous one mentioned value\nSet to 0 to disable"); end);
	InputFieldTable[i].text6 = UI.CreateLabel(row6).SetText('Check if you want the Maximum amount of units to be shared between all players').SetColor('#dbddf4')
	InputFieldTable[i].Shared = UI.CreateCheckBox(row6).SetIsChecked(shared).SetText('')

	--Visible unit setting
	InputFieldTable[i].row7 = UI.CreateHorizontalLayoutGroup(vert);
	local row7 = InputFieldTable[i].row7
	UI.CreateButton(row7).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("When turned on, all players can see where this unit is at all times"); end);
	InputFieldTable[i].text7 = UI.CreateLabel(row7).SetText('Check if you want this unit visible at all times')
	InputFieldTable[i].Visible = UI.CreateCheckBox(row7).SetIsChecked(visible).SetText('')

	--Units can only move every other turn
	InputFieldTable[i].row16 = UI.CreateHorizontalLayoutGroup(vert);
	local row16 = InputFieldTable[i].row16
	UI.CreateButton(row16).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("When turned on. this unit can only move on Even turns"); end);
	InputFieldTable[i].text18 = UI.CreateLabel(row16).SetText('Check if you only want this unit moving every other turn').SetColor('#dbddf4')
	InputFieldTable[i].Altmoves = UI.CreateCheckBox(row16).SetIsChecked(altmoves).SetText('')


	--name of unit
	InputFieldTable[i].row5 = UI.CreateHorizontalLayoutGroup(vert)
	local row5 = InputFieldTable[i].row5
	InputFieldTable[i].text9 = UI.CreateLabel(row5).SetText('Name of Unit in buy menu')
	InputFieldTable[i].Name = UI.CreateTextInputField(vert)
		.SetPlaceholderText(" Name of Unit Type        ").SetText(name)
		.SetFlexibleWidth(1)
		.SetCharacterLimit(25)

	--Host Rules
	InputFieldTable[i].row18 = UI.CreateHorizontalLayoutGroup(vert)
	local row18 = InputFieldTable[i].row18
	UI.CreateButton(row18).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert('input rules here for player intructions on how to use this unit in your game. WARNING: these rules are entierly enforced by you. put them there at your own discretion') end);
	InputFieldTable[i].text20 = UI.CreateLabel(row18).SetText('Host Custom rules').SetColor('#dbddf4')
	InputFieldTable[i].HostRules = UI.CreateTextInputField(vert)
		.SetPlaceholderText(" Host Custom Rules").SetText(hostrules)
		.SetFlexibleWidth(1)
		.SetCharacterLimit(500)

		-- Slots
	InputFieldTable[i].row24 = UI.CreateHorizontalLayoutGroup(vert) -- Slot
	local row24 = InputFieldTable[i].row24
	UI.CreateButton(row24).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("\nLeave blank to disable this feature\nOnly these slot's in game can build these Unit types\nuse '/' to define a new slot without spaces or Letters") end)
	InputFieldTable[i].text26 = UI.CreateLabel(row24).SetText('Which Slot`s Can use this Unit type')
	InputFieldTable[i].Slot = UI.CreateTextInputField(vert)
		.SetPlaceholderText("Slots").SetText(slot)
		.SetFlexibleWidth(1)
		.SetCharacterLimit(300)

	--spacer
	InputFieldTable[i].row8 = UI.CreateHorizontalLayoutGroup(vert)
	local row8 = InputFieldTable[i].row8
	InputFieldTable[i].text10 = UI.CreateEmpty(row8)
	InputFieldTable[i].text11 = UI.CreateLabel(row8).SetText('\n')
end

function TempAlreadyCreated(i)
	print('template already created access')

	InputFieldTable[i].TemplateStored = true

    InputFieldTable[i].unitcost = uniteconfig[i].unitcost
	InputFieldTable[i].unitpower = uniteconfig[i].unitpower 
	InputFieldTable[i].AttackMax = uniteconfig[i].AttackMax 
	InputFieldTable[i].Defend = uniteconfig[i].Defend 
	InputFieldTable[i].Maxunits = uniteconfig[i].Maxunits 
	InputFieldTable[i].Minlife = uniteconfig[i].Minlife 
	InputFieldTable[i].Maxlife = uniteconfig[i].Maxlife 
	InputFieldTable[i].image = uniteconfig[i].image 
	InputFieldTable[i].Transfer = uniteconfig[i].Transfer 
	InputFieldTable[i].Level = uniteconfig[i].Level 
	InputFieldTable[i].Active = uniteconfig[i].Active 
	InputFieldTable[i].MaxServer = uniteconfig[i].MaxServer 
	InputFieldTable[i].Cooldown = uniteconfig[i].Cooldown 
	InputFieldTable[i].Assassination = uniteconfig[i].Assassination 
	InputFieldTable[i].Shared = uniteconfig[i].Shared
	InputFieldTable[i].Visible = uniteconfig[i].Visible
	InputFieldTable[i].Altmoves = uniteconfig[i].Altmoves
	InputFieldTable[i].Name = uniteconfig[i].Name
	InputFieldTable[i].HostRules = uniteconfig[i].HostRules
	InputFieldTable[i].Autovalue = uniteconfig[i].Autovalue
	InputFieldTable[i].City = uniteconfig[i].Oncity
	InputFieldTable[i].Combat = uniteconfig[i].CombatOrder
	InputFieldTable[i].Slot = uniteconfig[i].Slot
	InputFieldTable[i].Slotstore = uniteconfig[i].Slotstore
end

function AutoPlacer(vertb,i)
--List of things to add
end

function Destroy()
	for D = 1, BeforeMax do  -- deleting UI before generating a new one
	print('before delete '.. D)

		if InputFieldTable[D].Template.GetIsChecked() == true then -- if true, that means UI was not generated and can skip
			UI.Destroy(InputFieldTable[D].text1)
			UI.Destroy(InputFieldTable[D].text2)
			UI.Destroy(InputFieldTable[D].text3)
			UI.Destroy(InputFieldTable[D].text4)
			UI.Destroy(InputFieldTable[D].text5)
			UI.Destroy(InputFieldTable[D].text6)
			UI.Destroy(InputFieldTable[D].text7)
			UI.Destroy(InputFieldTable[D].text8)
			UI.Destroy(InputFieldTable[D].text9)
			UI.Destroy(InputFieldTable[D].text10)
			UI.Destroy(InputFieldTable[D].text11)
			UI.Destroy(InputFieldTable[D].text12)
			UI.Destroy(InputFieldTable[D].text13)
			UI.Destroy(InputFieldTable[D].text14)
			UI.Destroy(InputFieldTable[D].text15)
			UI.Destroy(InputFieldTable[D].text16)
			UI.Destroy(InputFieldTable[D].text17)
			UI.Destroy(InputFieldTable[D].text18)
			UI.Destroy(InputFieldTable[D].text19)
			UI.Destroy(InputFieldTable[D].text20)
			UI.Destroy(InputFieldTable[D].text21)
			UI.Destroy(InputFieldTable[D].text22)
			UI.Destroy(InputFieldTable[D].text24) 
			UI.Destroy(InputFieldTable[D].text23)
			UI.Destroy(InputFieldTable[D].text25)
			UI.Destroy(InputFieldTable[D].text26)
			UI.Destroy(InputFieldTable[D].unitcost)
			UI.Destroy(InputFieldTable[D].unitpower)
			UI.Destroy(InputFieldTable[D].Maxunits)
			UI.Destroy(InputFieldTable[D].image)
			UI.Destroy(InputFieldTable[D].Shared)
			UI.Destroy(InputFieldTable[D].Visible)
			UI.Destroy(InputFieldTable[D].MaxServer)
			UI.Destroy(InputFieldTable[D].Name)
			UI.Destroy(InputFieldTable[D].Minlife)
			UI.Destroy(InputFieldTable[D].Maxlife)
			UI.Destroy(InputFieldTable[D].Transfer)
			UI.Destroy(InputFieldTable[D].Level)
			UI.Destroy(InputFieldTable[D].Active)
			UI.Destroy(InputFieldTable[D].Defend)
			UI.Destroy(InputFieldTable[D].Altmoves)
			UI.Destroy(InputFieldTable[D].Cooldown)
			UI.Destroy(InputFieldTable[D].HostRules)
			UI.Destroy(InputFieldTable[D].Assassination)
			UI.Destroy(InputFieldTable[D].AttackMax)
			UI.Destroy(InputFieldTable[D].Autovalue)
			UI.Destroy(InputFieldTable[D].Combat)
			UI.Destroy(InputFieldTable[D].City)
			UI.Destroy(InputFieldTable[D].Slot)
			UI.Destroy(InputFieldTable[D].row1)
			UI.Destroy(InputFieldTable[D].row2)
			UI.Destroy(InputFieldTable[D].row3)
			UI.Destroy(InputFieldTable[D].row4)
			UI.Destroy(InputFieldTable[D].row6)
			UI.Destroy(InputFieldTable[D].row7)
			UI.Destroy(InputFieldTable[D].row5)
			UI.Destroy(InputFieldTable[D].row9)
			UI.Destroy(InputFieldTable[D].row8)
			UI.Destroy(InputFieldTable[D].row10)
			UI.Destroy(InputFieldTable[D].row11)
			UI.Destroy(InputFieldTable[D].row12)
			UI.Destroy(InputFieldTable[D].row13)
			UI.Destroy(InputFieldTable[D].row14)
			UI.Destroy(InputFieldTable[D].row15)
			UI.Destroy(InputFieldTable[D].row16)
			UI.Destroy(InputFieldTable[D].row17)
			UI.Destroy(InputFieldTable[D].row18)
			UI.Destroy(InputFieldTable[D].row19)
			UI.Destroy(InputFieldTable[D].row20)
			UI.Destroy(InputFieldTable[D].row22)
			UI.Destroy(InputFieldTable[D].row21)
			UI.Destroy(InputFieldTable[D].row23)
			UI.Destroy(InputFieldTable[D].row24)
		end
		UI.Destroy(InputFieldTable[D].text180)
		UI.Destroy(InputFieldTable[D].Template)
		InputFieldTable[D].TempCreated = false
		uniteconfig[D] = {}
		InputFieldTable[D].Slotstore = {}
	end
	access = 1
end
