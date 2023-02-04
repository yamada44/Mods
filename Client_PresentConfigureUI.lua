
function Client_PresentConfigureUI(rootParent)


	local goldtax = Mod.Settings.GoldTax;
	local hiddengold = Mod.Settings.Hidden

	if goldtax == nil then goldtax = 0; end
    if (hiddengold == nil)then hiddengold = false end  

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row1 = UI.CreateHorizontalLayoutGroup(vert)


    local row1 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row1).SetText('- Gold Taxed amount Multipler: \n-0 means no tax');
    TaxInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(1500)
		.SetValue(goldtax);

		local row2 = UI.CreateHorizontalLayoutGroup(vert) -- creating space
		print(hiddengold)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	HiddenGoldField = UI.CreateCheckBox(row3).SetText('Hidden gold orders on').SetIsChecked(hiddengold)
	print(HiddenGoldField)

end