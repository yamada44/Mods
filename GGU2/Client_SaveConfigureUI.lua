
function Client_SaveConfigureUI(alert)

    local Tax = TaxInputField.GetValue();
    local hidden = HiddenGoldField.GetIsChecked()
    local percent = PercentInputField.GetValue()
    local plan = Paymentfield.GetValue()


    Mod.Settings.Hidden = hidden

    if Tax < 0 then alert('Tax value not supported. please stay within 0 - Go') 
    else 
        Mod.Settings.GoldTax = Tax
    end
    if (percent > 100 or percent < 0)then percent = 0 alert('Percent value not supported. please stay within 0 - 100')
    else 
    Mod.Settings.Percent = percent
    end
    if (plan > 25 or percent < 1)then plan = 20 alert('Payment plan value not supported. please stay within 1 - 25')
    else 
    Mod.Settings.Plan = plan
    end
   
    
end