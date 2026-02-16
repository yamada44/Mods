
function Client_PresentConfigureUI(rootParent)


	--gold cost of hive
	local hivecost = Mod.Settings.HiveCost
	if hivecost == nil then
		hivecost = 500
	end

	-- max hivies
	local maxH = Mod.Settings.Maxhives
	if maxH == nil then
		maxH = 1
	end

	--Cost increase 
	local CostX = Mod.Settings.Costincrease
	if CostX == nil then
		CostX = 0
	end

	--Troops needed to remove 
	local needattack = Mod.Settings.Need
	if needattack == nil then
		needattack = 10
	end
	--Forts per tile
	local limit = Mod.Settings.Limit
	if limit == nil then
		limit = 1
	end
	--Scale
	local scale = Mod.Settings.Scale
	if scale == nil then
		scale = 0
	end
	--Turn
	local turn = Mod.Settings.Turn
	if turn == nil then
		turn = 20
	end
	--market
	local market = Mod.Settings.Market
	if market == nil then
		market = false
	end

	--auto place hibes
	local auto = Mod.Settings.Auto
	if auto == nil then
		auto = 0
	end

	local vert = UI.CreateVerticalLayoutGroup(rootParent)


	local row3 = UI.CreateHorizontalLayoutGroup(vert); -- Hive Cost
	UI.CreateButton(row3).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("The cost of each Structure type") end)
	UI.CreateLabel(row3).SetText('Cost of each Fort')
	Costfield = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1000)
		.SetValue(hivecost)

	local row4 = UI.CreateHorizontalLayoutGroup(vert) -- Max Hives
	UI.CreateButton(row4).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How many Structures of this type can you have\nSet to 0 to disable while still having the auto placer work") end)
	UI.CreateLabel(row4).SetText('Max Fort amount')
	Maxfield = UI.CreateNumberInputField(row4)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(maxH)

	local row55 = UI.CreateHorizontalLayoutGroup(vert) -- Fort increase by amount of forts
	UI.CreateButton(row55).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("By how much more does this Fort cost increase per forts owned\nSet to 0 to disable") end)
	UI.CreateLabel(row55).SetText('Fort cost increase')
	increaseXfield = UI.CreateNumberInputField(row55)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(300)
		.SetValue(CostX)

	local row6 = UI.CreateHorizontalLayoutGroup(vert) -- Troops needed to remove fort in a attack
	UI.CreateButton(row6).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Set to -1 for manned forts. Meaning the power of a fort is dobuled and the fort remains \nSet to 0 to have the fort cancel a attack(of any army size) and delete itself\nAbove 0 - Forts will cancel attacks until this number value attacks it. The units needed to delete this fort will be destroyed in the attack") end)
	UI.CreateLabel(row6).SetText('Troops needed to remove Fort')
	Needfield = UI.CreateNumberInputField(row6)
	.SetSliderMinValue(-1)
	.SetSliderMaxValue(100)
	.SetValue(needattack)

	local row66 = UI.CreateHorizontalLayoutGroup(vert) -- How many forts per Tile
	UI.CreateButton(row66).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How many Forts per tile allowed\nSet to 0 to disable") end)
	UI.CreateLabel(row66).SetText('Forts per Territroy')
	Limitfield = UI.CreateNumberInputField(row66)
	.SetSliderMinValue(0)
	.SetSliderMaxValue(3)
	.SetValue(limit)
	
	local row77 = UI.CreateHorizontalLayoutGroup(vert) -- Scale
	UI.CreateButton(row77).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("increase power for Forts by this number every (Setting below) turns\nSet to 0 to disable\nOnly works when your troops needed to remove fort value is above 0") end)
	UI.CreateLabel(row77).SetText('Power Scaling')
	Scalefield = UI.CreateNumberInputField(row77)
	.SetSliderMinValue(0)
	.SetSliderMaxValue(100)
	.SetValue(scale)

	local row99 = UI.CreateHorizontalLayoutGroup(vert) -- Turn
	UI.CreateButton(row99).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How many Turns between each power increase for forts\nSet the value above to 0 to disable\nOnly works when your troops needed to remove fort value is above 0") end)
	UI.CreateLabel(row99).SetText('Turns For power Scaling')
	Turnfield = UI.CreateNumberInputField(row99)
	.SetSliderMinValue(0)
	.SetSliderMaxValue(100)
	.SetValue(turn)

	local row101 = UI.CreateHorizontalLayoutGroup(vert) -- Cost upkeep
	UI.CreateButton(row101).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("If power scaling is turned on, do you want the cost to keep up with the power increase\nOnly works when your troops needed to remove fort value is above 0") end)
	UI.CreateLabel(row101).SetText('Cost keeps up with turn Scaling')
	Marketfield = UI.CreateCheckBox(row101).SetText("").SetIsChecked(market)

		local row5 = UI.CreateHorizontalLayoutGroup(vert) -- Autoplacer for Forts
		UI.CreateButton(row5).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Go into custom scenrio, change the army value of a tile to this value. when the game starts it will have this territory\nMax Forts you can auto place is 50") end)
	UI.CreateLabel(row5).SetText('Auto place Structure')
	Autofield = UI.CreateNumberInputField(row5)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1234)
		.SetValue(auto)
end