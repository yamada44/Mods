
function Client_PresentConfigureUI(rootParent)
    Maplimit = 2
    Modlimit = 2


	local mapvalue = Mod.Settings.mapreturnvalue;
	if mapvalue == nil then
		mapvalue = 1;
	end

	local modpicker = Mod.Settings.modinputreturn;
	if modpicker == nil then
		modpicker = 1;
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


end