
function Client_SaveConfigureUI(alert)

    local Tax = TaxInputField.GetValue();
    local hidden = HiddenGoldField.GetIsChecked()
    local percent = PercentInputField.GetValue()
    local plan = Paymentfield.GetValue()

    if Tax < 0 then alert('Tax must be positive'); end

    Mod.Settings.GoldTax = Tax;
    Mod.Settings.Hidden = hidden

    if (percent > 100 or percent < 0)then percent = 0
    else 
    Mod.Settings.Percent = PercentInputField.GetValue()
    end
    if (plan > 25 or percent < 1)then plan = 20
    else 
    Mod.Settings.Plan = Paymentfield.GetValue()
    end
    
end