
function Client_PresentConfigureUI(rootParent)
    Maplimit = 8
    Modlimit = 5


	local mapvalue = Mod.Settings.mapreturnvalue;
	if mapvalue == nil then
		mapvalue = 1;
	end

	local modpicker = Mod.Settings.modinputreturn;
	if modpicker == nil then
		modpicker = 1;
	end

	local neutralamount = Mod.Settings.Neutral;
	if neutralamount == nil then
		neutralamount = 0;
	end
    
	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row0 = UI.CreateHorizontalLayoutGroup(vert); -- adding the correct map
	UI.CreateLabel(row0).SetText(
	[[
		
	This mod only works with select maps.
	This is how Map select works :
	by choosing the Map Value you decide which map is used
	
	1 - IS: Europe World War Supergame
	2 - Baconsizzle's Big World
	3 - IS - Star Wars RP Map - B-Wing Edition
	4 - The Peloponnesian War
	5 - Liverpool City Centre
	6 - Avatar - The Last Airbender
	7 - France Large
	8 - Huge Westeros
	
	This is how Mod select works :
	by choosing your mod value, you decide which special units are immune from the affects of this mod.
	
	0 - All special units including commanders
	1 - I.S. Character Pack ( Antiquity ) special units
	2 - I.S. Character Pack ( Ship Props ) special units
	3 - I.S. Character Pack ( Three kingdom Heros ) special units]]);

    local row1 = UI.CreateHorizontalLayoutGroup(vert); -- adding the correct map
	UI.CreateLabel(row1).SetText('What map format to use for sea territories');
    InputMap = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(Maplimit)
		.SetValue(mapvalue);

	local row2 = UI.CreateHorizontalLayoutGroup(vert); -- adding in the correct mod used
	UI.CreateLabel(row2).SetText('what mod`s special units are immune to territory changes');
	InputModpicker = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(Modlimit)
		.SetValue(modpicker);

		local row3 = UI.CreateHorizontalLayoutGroup(vert); -- adding in the correct mod used
		UI.CreateLabel(row3).SetText('When territoriy is changed to neutral. what army value will the territory be changed to');
		InputNeutralamount = UI.CreateNumberInputField(row3)
			.SetSliderMinValue(0)
			.SetSliderMaxValue(20)
			.SetValue(neutralamount);


end