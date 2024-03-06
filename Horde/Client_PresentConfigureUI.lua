
function Client_PresentConfigureUI(rootParent)

	--Troop converted to horde
	local slot = Mod.Settings.Slot
	if slot == nil then
		slot = 1
	end

	local troopscon = Mod.Settings.TConv
	if troopscon == nil then
		troopscon = 80
	end

	--structure type
	local struc = Mod.Settings.StructureType
	if struc == nil then
		struc = 0
	end

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

	--auto place hibes
	local auto = Mod.Settings.Auto
	if auto == nil then
		auto = 0
	end

	--can play diplos cards
	local playD = Mod.Settings.PlayDip
	if playD == nil then
		playD = false
	end

	-- can play airlift cards
	local playA = Mod.Settings.PlayAir
	if playA == nil then
		playA = false
	end

	-- can play sanctions
	local playS = Mod.Settings.PlaySan
	if playS == nil then
		playS = false
	end

	--can/cannot deploy troops
	local trdeploy = Mod.Settings.TDep
	if trdeploy == nil then
		trdeploy = true
	end	

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row0 = UI.CreateHorizontalLayoutGroup(vert); -- adding the correct map
	

	local row1 = UI.CreateHorizontalLayoutGroup(vert); -- Slot
	UI.CreateLabel(row1).SetText('Which Slot is the Horde')
    Slotfield = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(40)
		.SetValue(slot)

    local row1 = UI.CreateHorizontalLayoutGroup(vert) -- troops converted
	UI.CreateLabel(row1).SetText('Troops converted after each kill')
    Convfield = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(100)
		.SetValue(troopscon)

	local row2 = UI.CreateHorizontalLayoutGroup(vert) -- structure type
	UI.CreateLabel(row2).SetText('Building type')
	Buildfield = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(18)
		.SetValue(struc)

	local row3 = UI.CreateHorizontalLayoutGroup(vert); -- Hive Cost
	UI.CreateLabel(row3).SetText('Cost of each Hive')
	Costfield = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1000)
		.SetValue(hivecost)

	local row4 = UI.CreateHorizontalLayoutGroup(vert) -- Max Hives
	UI.CreateLabel(row4).SetText('Max Hive amount')
	Maxfield = UI.CreateNumberInputField(row4)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(maxH)

		local row5 = UI.CreateHorizontalLayoutGroup(vert) -- Autoplacer for Hives
	UI.CreateLabel(row5).SetText('Auto place Hives')
	Autofield = UI.CreateNumberInputField(row5)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1234)
		.SetValue(auto)

		local row6 = UI.CreateHorizontalLayoutGroup(vert) -- Can Deploy troops
	UI.CreateLabel(row6).SetText('Can this slot Deploy Troops')
	Deployfield = UI.CreateCheckBox(row6).SetText("").SetIsChecked(trdeploy)

	-- incrementing Time --
		local row7 = UI.CreateHorizontalLayoutGroup(vert) -- can play airlift cards
	UI.CreateLabel(row7).SetText('Can this slot play Airlift cards')
	Airfield = UI.CreateCheckBox(row7).SetText("").SetIsChecked(playA)

		local row8 = UI.CreateHorizontalLayoutGroup(vert) -- can play sanction cards
	UI.CreateLabel(row8).SetText('Can this slot play Sanction cards')
	Sanfield = UI.CreateCheckBox(row8).SetText("").SetIsChecked(playS)

		local row9 = UI.CreateHorizontalLayoutGroup(vert) -- can play Diplo cards
	UI.CreateLabel(row9).SetText('Can this slot play Diplomacy cards')
	Dipfield = UI.CreateCheckBox(row9).SetText("").SetIsChecked(playD)


end