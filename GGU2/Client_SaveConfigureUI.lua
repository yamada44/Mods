
function Client_SaveConfigureUI(alert)

    local Tax = TaxInputField.GetValue();
    local hidden = HiddenGoldField.GetIsChecked()
    local percent = PercentInputField.GetValue()
    local plan = Paymentfield.GetValue()
    local atax = ATaxfield.GetValue()
    local acost = ACostfield.GetValue()


    Mod.Settings.Hidden = hidden
    --Base Tax
    if Tax < 0 then alert('Tax value not supported. please stay above 0') 
    else 
        Mod.Settings.GoldTax = Tax
    end
    --Percent
    if (percent > 100 or percent < 0)then percent = 0 alert('Percent value not supported. please stay within 0 - 100')
    else 
    Mod.Settings.Percent = percent
    end
    --Plan
    if (plan > 25 or plan < 1)then plan = 20 alert('Payment plan value not supported. please stay within 1 - 25')
    else 
    Mod.Settings.Plan = plan
    end
    -- Account Tax
    if (atax < 0 )then alert('Account Tax value not supported. please stay above 0')
    else 
    Mod.Settings.ATax = atax
    end
    --Account Cost
    if (acost < 0)then alert('Account Cost value not supported. please stay above 0')
    else 
    Mod.Settings.ACost = acost
    end
   
    
end