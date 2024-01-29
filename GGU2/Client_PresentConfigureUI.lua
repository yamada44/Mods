
function Client_PresentConfigureUI(rootParent)


	local goldtax = Mod.Settings.GoldTax
	local hiddengold = Mod.Settings.Hidden
	local percent = Mod.Settings.Percent
	local plan = Mod.Settings.Plan

	if goldtax == nil then goldtax = 0; end
	if percent == nil then percent = 0 end
	if plan == nil then plan = 20 end

    if (hiddengold == nil)then hiddengold = false end  

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row1 = UI.CreateHorizontalLayoutGroup(vert)


    local row1 = UI.CreateHorizontalLayoutGroup(vert)
	UI.CreateLabel(row1).SetText('Gold Taxed amount Multipler: \n0 means no regular tax').SetColor('#615DDF')
    TaxInputField = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(200)
		.SetValue(goldtax)

	local row2 = UI.CreateHorizontalLayoutGroup(vert)
		UI.CreateLabel(row2).SetText('Gold Taxed by Percent instead: \n0 means no percent tax').SetColor('#615DDF')
		PercentInputField = UI.CreateNumberInputField(row2)
			.SetSliderMinValue(0)
			.SetSliderMaxValue(100)
			.SetValue(percent)

	local row22 = UI.CreateHorizontalLayoutGroup(vert)
	UI.CreateLabel(row22).SetText('How many turns a payment plan can last').SetColor('#615DDF')
	Paymentfield = UI.CreateNumberInputField(row22)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(25)
		.SetValue(plan)

	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	HiddenGoldField = UI.CreateCheckBox(row3).SetText('Hidden gold orders on').SetIsChecked(hiddengold)

	print(HiddenGoldField)

end