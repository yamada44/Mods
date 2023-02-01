
function Client_PresentConfigureUI(rootParent)


	local goldtax = Mod.Settings.GoldTax;
	if goldtax == nil then goldtax = 0; end
    
	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row1 = UI.CreateHorizontalLayoutGroup(vert)


    local row1 = UI.CreateHorizontalLayoutGroup(vert);
	UI.CreateLabel(row1).SetText('- Gold Taxed amount Multipler: \n-0 means no tax');
    TaxInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(5000)
		.SetValue(goldtax);

end