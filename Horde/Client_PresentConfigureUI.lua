
function Client_PresentConfigureUI(rootParent)

	--Troop converted to horde
	local slot = Mod.Settings.Slot
	if slot == nil then
		slot = "1"
	else 
		slot = Mod.Settings.Slotstore 
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
	local trdeploy = Mod.Settings.TDep -- 1 = no limits, 2 == only on StructureType, 3 == never 
	if trdeploy == nil then
		trdeploy = 1
	end	

	-- can play Reinforcement
	local ref = Mod.Settings.PlayRef
	if ref == nil then
		ref = false
	end	

	-- cities are removed if owned by this slot
	local cityremoved = Mod.Settings.CityG
	if cityremoved == nil then
		cityremoved = 1
	end

	--This slot cannot build cities
	local city9 = Mod.Settings.Nocities
	if city9 == nil then
		city9 = false
	end	

	--This slot Attack Rules
	local attack = Mod.Settings.Attack
	if attack == nil then
		attack = 1
	end	

	--This slot Fort attack Rules
	local fort = Mod.Settings.Fort
	if fort == nil then
		fort = 0
	end	

		--This slot Fort attack Rules
		local agg = Mod.Settings.Agg
		if agg == nil then
			agg = false
		end	

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row0 = UI.CreateHorizontalLayoutGroup(vert); -- Slot
	UI.CreateButton(row0).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Only these slot's in game will have these effects applied to it\n use '/' to define a new slot without spaces or numbers\nleave blank to affect no slots and just use auto placer") end)
	UI.CreateLabel(row0).SetText('Which Slot`s is the Zombies/bandits/ect.')
    Slotfield = UI.CreateTextInputField(vert)
	.SetPlaceholderText("Slots").SetText(slot)
	.SetFlexibleWidth(1)
	.SetCharacterLimit(300)

    local row1 = UI.CreateHorizontalLayoutGroup(vert) -- troops converted
	UI.CreateButton(row1).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("After each kill what percentage of troops are transfered to your side. this works while defending and attacking\nSet to 0 to disable") end)
	UI.CreateLabel(row1).SetText('Percentage of troops converted after each kill')
    Convfield = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(100)
		.SetValue(troopscon)

	local row2 = UI.CreateHorizontalLayoutGroup(vert) -- structure type
	UI.CreateButton(row2).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("What Structure type can this slot build\n0 - Feature disabled\n1 - Cities\n2 - Army Camp\n3 - Mine\n4 - Smelter\n5 - Crafter\n6 - Market\n7 - Army Cache\n8 - Money Cache\n9 - Resource Cache\n10 - Mercenary Camp\n11 - DNA \n12 - Man and gun\n13 - Arena\n14 - Hospital\n15 - Dig Site\n16 - Artillery\n17 - Mortar\n18 - Book") end)
	UI.CreateLabel(row2).SetText('Building type')
	Buildfield = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(18)
		.SetValue(struc)

	local row3 = UI.CreateHorizontalLayoutGroup(vert); -- Hive Cost
	UI.CreateButton(row3).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("The cost of each Structure type") end)
	UI.CreateLabel(row3).SetText('Cost of each Structure')
	Costfield = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1000)
		.SetValue(hivecost)

	local row4 = UI.CreateHorizontalLayoutGroup(vert) -- Max Hives
	UI.CreateButton(row4).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How many Structures of this type can you have\nSet to 0 to disable while still having the auto placer work") end)
	UI.CreateLabel(row4).SetText('Max Structures allowed')
	Maxfield = UI.CreateNumberInputField(row4)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(20)
		.SetValue(maxH)

		local row5 = UI.CreateHorizontalLayoutGroup(vert) -- Autoplacer for Hives
		UI.CreateButton(row5).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Go into custom scenrio, change the army value of a tile to this value. when the game starts it will have this territory") end)
	UI.CreateLabel(row5).SetText('Auto place Structure')
	Autofield = UI.CreateNumberInputField(row5)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1234)
		.SetValue(auto)

	local row55 = UI.CreateHorizontalLayoutGroup(vert) -- City removed for Hives
	UI.CreateButton(row55).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How many cities removed when controlled by this slot") end)
	UI.CreateLabel(row55).SetText('Cities removed if Owned')
	CityGone = UI.CreateNumberInputField(row55)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(10)
		.SetValue(cityremoved)

	local row6 = UI.CreateHorizontalLayoutGroup(vert) -- Can Deploy troops
	UI.CreateButton(row6).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("1 - no limits on deployment\n2 - only on Structure Type\n3 - Cannot deploy at all") end)
	UI.CreateLabel(row6).SetText('Deploy Rules')
	Deployfield = UI.CreateNumberInputField(row6)
	.SetSliderMinValue(1)
	.SetSliderMaxValue(3)
	.SetValue(trdeploy)

	local row66 = UI.CreateHorizontalLayoutGroup(vert) -- attack Rules
	UI.CreateButton(row66).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("1 - no Rules on Attacks\n2 - Cannot attack neutral\n3 - does not gain troops from attacks on neutral\nNumber Above 3 - Does not attack neutrals with this number only, also does not attack neutrals with 0") end)
	UI.CreateLabel(row66).SetText('Attack Rules')
	Attackfield = UI.CreateNumberInputField(row66)
	.SetSliderMinValue(1)
	.SetSliderMaxValue(1000)
	.SetValue(attack)

	local row07 = UI.CreateHorizontalLayoutGroup(vert) -- Fort Rules
	UI.CreateButton(row07).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("How many attacks can a Fort (from fort tactics mod) take before being destroyed. This setting makes these mods compatible and makes the AI smarter\nSet to 0 to disable") end)
	UI.CreateLabel(row07).SetText('Fort attacks before destroyed')
	Fortfield = UI.CreateNumberInputField(row07)
	.SetSliderMinValue(0)
	.SetSliderMaxValue(5)
	.SetValue(fort)

	local row7 = UI.CreateHorizontalLayoutGroup(vert) -- can play airlift cards
	UI.CreateButton(row7).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Can this slot play Airlift cards") end)
	UI.CreateLabel(row7).SetText('Can this slot play Airlift cards')
	Airfield = UI.CreateCheckBox(row7).SetText("").SetIsChecked(playA)

	local row8 = UI.CreateHorizontalLayoutGroup(vert) -- can play sanction cards
	UI.CreateButton(row8).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Can this slot play Sanction cards") end)
	UI.CreateLabel(row8).SetText('Can this slot play Sanction cards')
	Sanfield = UI.CreateCheckBox(row8).SetText("").SetIsChecked(playS)

	local row9 = UI.CreateHorizontalLayoutGroup(vert) -- can play Diplo cards
	UI.CreateButton(row9).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Can this slot play Diplomacy cards") end)
	UI.CreateLabel(row9).SetText('Can this slot play Diplomacy cards')
	Dipfield = UI.CreateCheckBox(row9).SetText("").SetIsChecked(playD)

	local row11 = UI.CreateHorizontalLayoutGroup(vert) -- can play Refin cards
	UI.CreateButton(row11).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Can this slot play Reinforcement cards") end)
	UI.CreateLabel(row11).SetText('Can this slot play Reinforcement cards')
	Reffield = UI.CreateCheckBox(row11).SetText("").SetIsChecked(ref)

	local row10 = UI.CreateHorizontalLayoutGroup(vert) -- cannot build cities if true
	UI.CreateButton(row10).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Can this slot build cities") end)
	UI.CreateLabel(row10).SetText('Can this Slot build cities')
	Nocities = UI.CreateCheckBox(row10).SetText("").SetIsChecked(city9)

	local row11 = UI.CreateHorizontalLayoutGroup(vert) -- cannot build cities if true
	UI.CreateButton(row11).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This setting makes the AI more Aggressive when on local deployment and its ability to use income is turned off\nThis is archived by giving the Zombie AI 1000 income. if the AI cannot deploy troops or build cities it will think it has troops, making him attack more often. This affect happens naturally when not in local deployment\nThis Setting can be used when not in local deployment for mixed results\nWill not work unless these slots cannot build cities or armies") end)
	UI.CreateLabel(row11).SetText('Aggressive AI on Local deployment (Read ? button)')
	Aggfield = UI.CreateCheckBox(row11).SetText("").SetIsChecked(agg)

	
end