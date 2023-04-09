



function Client_SaveConfigureUI(alert)

    local noUnitsOn = 0



    local test = InputFieldTable.test.GetIsChecked()
    Mod.Settings.test = test




   for i = 1, UnitTypeMax do
        print (i)
        local cost = InputFieldTable[i].costInputField.GetValue();
        if cost < 1 then alert("Cost to buy this Unit must be positive"); end
        Mod.Settings.Unitdata[i].unitcost = cost;
    
        local power = InputFieldTable[i].powerInputField.GetValue();
        if power < 1 then alert("Unit must have at least one power"); end
        Mod.Settings.Unitdata[i].unitpower = power;
    
        local maxunits = InputFieldTable[i].maxUnitsField.GetValue();
        if maxunits > 5 or maxunits < 0 then alert("Max Units cannot be greater then 5"); end
        Mod.Settings.Unitdata[i].Maxunits = maxunits;

        local image = InputFieldTable[i].Image.GetValue();
        if image < 1 or image > Maxpictures then alert("Only images between 1-".. Maxpictures); end
        Mod.Settings.Unitdata[i].image = image;


        if (InputFieldTable[i].Name.GetText() ~= '' and InputFieldTable[i].Name.GetText() ~= nil)then
        local name = InputFieldTable[i].Name.GetText()
        Mod.Settings.Unitdata[i].Name = name;
        
        elseif(maxunits ~= 0)then
         Mod.Settings.Unitdata[i].Name = " (( NO NAME GIVEN ))" 
            UI.Alert("NO NAME GIVEN TO UNIT TYPE(S) that are enabled\nTo disable Unit Types set their Maxunit's to 0 ")
        end
        
        print (InputFieldTable[i].Visible.GetIsChecked(), InputFieldTable[i].Shared.GetIsChecked())
        local shared = InputFieldTable[i].Shared.GetIsChecked()
        Mod.Settings.Unitdata[i].Shared = shared

        local visible = InputFieldTable[i].Visible.GetIsChecked()
        Mod.Settings.Unitdata[i].Visible = visible
        
        local maxserver = InputFieldTable[i].MaxServer.GetIsChecked()
        Mod.Settings.Unitdata[i].MaxServer = maxserver
 
       
         noUnitsOn = noUnitsOn + maxunits
   end

   if (noUnitsOn <= 0)then UI.Alert("Failed to add any Unit types")  end 

   Mod.Settings.Maxunittype = UnitTypeMax
   Mod.Settings.access = InputFieldTable.unitInit

end
