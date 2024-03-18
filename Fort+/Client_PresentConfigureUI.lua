
function Client_PresentConfigureUI(rootParent)


	--gold cost of hive
	local hivecost = Mod.Settings.HiveCost
	if hivecost == nil then
		hivecost = 500
	end

	-- max hivies
	local maxH = Mod.Settings.Maxhives
	if maxH == nil then
		maxH = 0
	end

	--Cost increase 
	local CostX = Mod.Settings.Costincrease
	if CostX == nil then
		CostX = 0
	end

	--Troops needed to remove 
	local needattack = Mod.Settings.Need
	if needattack == nil then
		needattack = 0
	end
	--Forts per tile
	local limit = Mod.Settings.Limit
	if limit == nil then
		limit = 1
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
	UI.CreateButton(row6).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How much attacking power does someone need to remove a fort. The units needed to delete this fort will be destroyed in the attack") end)
	UI.CreateLabel(row6).SetText('Troops needed to remove Fort')
	Needfield = UI.CreateNumberInputField(row6)
	.SetSliderMinValue(1)
	.SetSliderMaxValue(100)
	.SetValue(needattack)
--\nSet to -1 for manned forts. Meaning instead of destroying attacking armies by default. Attacks on forts are cancelled unless the attacking army has twice the amount of armies attacking compared to defenders

	local row66 = UI.CreateHorizontalLayoutGroup(vert) -- How many forts per Tile
	UI.CreateButton(row66).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How many Forts per tile allowed\nSet to 0 to disable") end)
	UI.CreateLabel(row66).SetText('Forts per Territroy')
	Limitfield = UI.CreateNumberInputField(row66)
	.SetSliderMinValue(0)
	.SetSliderMaxValue(3)
	.SetValue(limit)
	
end