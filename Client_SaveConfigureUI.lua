
function Client_SaveConfigureUI(alert)
    local Tax = TaxInputField.GetValue();

    if Tax < 1 then alert('Tax must be positive'); end

    Mod.Settings.GoldTax = Tax;
end