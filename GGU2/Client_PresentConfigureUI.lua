
function Client_PresentConfigureUI(rootParent)


	local goldtax = Mod.Settings.GoldTax
	local hiddengold = Mod.Settings.Hidden
	local percent = Mod.Settings.Percent
	local plan = Mod.Settings.Plan
	local atax = Mod.Settings.ATax
	local acost = Mod.Settings.ACost

	if goldtax == nil then goldtax = 0; end
	if percent == nil then percent = 0 end
	if plan == nil then plan = 20 end
	if atax == nil then atax = 0 end
	if acost == nil then acost = 100 end

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

	local row23 = UI.CreateHorizontalLayoutGroup(vert)
	UI.CreateLabel(row23).SetText('Tax for accounts.\nwould recommand setting to free or much higher than other Tax\nif percent is on no tax for accounts\nif both multipler and percent are turned off, Account tax will stil apply').SetColor('#615DDF')
	ATaxfield = UI.CreateNumberInputField(row23)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(200)
		.SetValue(atax)

	local row24 = UI.CreateHorizontalLayoutGroup(vert)
	UI.CreateLabel(row24).SetText('Cost to create a account').SetColor('#615DDF')
	ACostfield = UI.CreateNumberInputField(row24)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(25)
		.SetValue(acost)

	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	HiddenGoldField = UI.CreateCheckBox(row3).SetText('Hidden gold orders on').SetIsChecked(hiddengold)

	print(HiddenGoldField)

end