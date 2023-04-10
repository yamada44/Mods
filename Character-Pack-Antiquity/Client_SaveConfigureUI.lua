



function Client_SaveConfigureUI(alert)

    local noUnitsOn = 0








   for i = 1, UnitTypeMax do
        print (i)
        local cost = InputFieldTable[i].costInputField.GetValue();
        if cost < 1 then alert("Mod set up failed\nCost to buy this Unit must be positive\nReset to default settings"); 
            Mod.Settings.Unitdata[i].unitcost = 1
        else
        Mod.Settings.Unitdata[i].unitcost = cost; end 
    

        local power = InputFieldTable[i].powerInputField.GetValue();
        if power < 1 then alert("Mod set up failed\nUnit must have at least one power\nReset to default settings"); 
            Mod.Settings.Unitdata[i].unitpower = 1
        else Mod.Settings.Unitdata[i].unitpower = power; end
    
        local maxunits = InputFieldTable[i].maxUnitsField.GetValue();
        if maxunits > 5 or maxunits < 0 then alert("Mod set up failed\nMax Units cannot be greater then 5\nReset to default settings"); 
            Mod.Settings.Unitdata[i].Maxunits = 1
        else
        Mod.Settings.Unitdata[i].Maxunits = maxunits; end

        local image = InputFieldTable[i].Image.GetValue();
        if image < 1 or image > Maxpictures then alert("Mod set up failed\nOnly images between 1-".. Maxpictures..'\nReset to default settings'); 
            Mod.Settings.Unitdata[i].image = 1
        else
        Mod.Settings.Unitdata[i].image = image; end


        if (InputFieldTable[i].Name.GetText() ~= '' and InputFieldTable[i].Name.GetText() ~= nil)then
        local name = InputFieldTable[i].Name.GetText()
        Mod.Settings.Unitdata[i].Name = name;
        
        elseif(maxunits ~= 0)then
         Mod.Settings.Unitdata[i].Name = " (( NO NAME GIVEN ))" 
            UI.Alert("NO NAME GIVEN TO UNIT TYPE(S) that are enabled\nTo disable Unit Types set their Maxunit's to 0\nReset to default settings")
        end
        
        print (InputFieldTable[i].Visible.GetIsChecked(), InputFieldTable[i].Shared.GetIsChecked())
        local shared = InputFieldTable[i].Shared.GetIsChecked()
        Mod.Settings.Unitdata[i].Shared = shared

        local visible = InputFieldTable[i].Visible.GetIsChecked()
        Mod.Settings.Unitdata[i].Visible = visible
        
        local maxserver = InputFieldTable[i].MaxServer.GetIsChecked()
        Mod.Settings.Unitdata[i].MaxServer = maxserver
 
        local minlife = InputFieldTable[i].Minlife.GetValue() 
       if minlife < 0 or minlife > 100 then 
        alert('Minimum amount for life is 1\nReset to default settings')
        Mod.Settings.Minlife = 1
       else Mod.Settings.Minlife = minlife end

       local maxlife = InputFieldTable[i].Maxlife.GetValue()  
       if maxlife < minlife or maxlife > 100 then 
        alert('Minimum amount for Max life is = to Minimum Turns alive\n Max amount is 100 \nReset to default settings')
        Mod.Settings.Maxlife = minlife + 1
       else Mod.Settings.Maxlife = maxlife end


         noUnitsOn = noUnitsOn + maxunits -- to check if any units were turned on
   end

   if (noUnitsOn <= 0)then Alert("Failed to add any Unit types")  end 

   Mod.Settings.access = 3
   Mod.Settings.BeforeMax = InputFieldTable.BeforeMax


end
