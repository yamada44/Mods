
function Client_SaveConfigureUI(alert)

    local waste = WastelandInput.GetValue()
    if waste > 5000 or waste < 0 then alert('Wasteland value not supported. please stay within 0-10')
        Mod.Settings.WastelandAmount = 10
    else 
        Mod.Settings.WastelandAmount = waste 
    end

    local percent = PercentInput.GetValue()
    if percent > 100 or percent < 50 then alert('Percent value not supported. please stay within 50-100')
        Mod.Settings.Percentthreshold = 66
    else 
        Mod.Settings.Percentthreshold = percent 
    end

end