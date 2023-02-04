
function Client_SaveConfigureUI(alert)

    local Tax = TaxInputField.GetValue();
    local hidden = HiddenGoldField.GetIsChecked()

    if Tax < 0 then alert('Tax must be positive'); end

    Mod.Settings.GoldTax = Tax;
    Mod.Settings.Hidden = hidden

end