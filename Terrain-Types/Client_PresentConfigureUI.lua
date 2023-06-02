
function Client_PresentConfigureUI(rootParent)
    Maplimit = 3
    Modlimit = 2


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