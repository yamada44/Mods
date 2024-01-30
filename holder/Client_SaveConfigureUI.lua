
function Client_SaveConfigureUI(alert)

    local Tax = TaxInputField.GetValue();
    local hidden = HiddenGoldField.GetIsChecked()
    local percent = PercentInputField.GetValue()

    if Tax < 0 then alert('Tax must be positive'); end

    Mod.Settings.GoldTax = Tax;
    Mod.Settings.Hidden = hidden

    if (percent > 100 or percent < 0)then percent = 0
    else 
    Mod.Settings.Percent = PercentInputField.GetValue()
    end

end