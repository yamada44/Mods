



function Client_SaveConfigureUI(alert)

    local noUnitsOn = 0
    local tomanyunits = 0
    local Unitsallowed = 15





	if UnitTypeMax == nil or UnitTypeMax < 1 or UnitTypeMax > 6 then  -- make sure unit types are between 1 and 6
        UI.Alert('you need to create some unit types by pressing the refresh hButton')
        UnitTypeMax = 0
        end
   for i = 1, UnitTypeMax do
        print (i)
        if InputFieldTable[i].Template == nil or InputFieldTable[i].Template.GetIsChecked() == nil then alert("Did not initialize Template ".. i) 
            
        else 
    print (InputFieldTable[i].Template.GetIsChecked(), 'template value')
    InputFieldTable[i].Template.SetIsChecked(false) -- when you reopen the mod menu, it will save your data and remember you already opened it


        local cost = InputFieldTable[i].costInputField.GetValue();
        if cost < 1 then alert("Mod set up failed\nCost to buy this Unit must be positive\nReset to default settings"); 
            Mod.Settings.Unitdata[i].unitcost = 1
        else
        Mod.Settings.Unitdata[i].unitcost = cost; end 
    

        local power = InputFieldTable[i].powerInputField.GetValue();
        if power < 0 then alert("Mod set up failed\n Units cannot have a Minimum attack Range below 0\nReset to default settings"); 
            Mod.Settings.Unitdata[i].unitpower = 1
        else Mod.Settings.Unitdata[i].unitpower = power; end

        local maxatt = InputFieldTable[i].AttackMax.GetValue();
        if maxatt < 0 or maxatt < power then alert("Mod set up failed\nUnits cannot have a Maximum attack power below 0 or below Minimum attack Range\nReset to default settings"); 
            Mod.Settings.Unitdata[i].AttackMax = Mod.Settings.Unitdata[i].unitpower
        else Mod.Settings.Unitdata[i].AttackMax = maxatt; end
    
        local maxunits = InputFieldTable[i].maxUnitsField.GetValue();
        if maxunits > 5 or maxunits < 1 then alert("Mod set up failed\nMax Units cannot be greater then 5\nReset to default settings"); 
            Mod.Settings.Unitdata[i].Maxunits = 1
        else
        Mod.Settings.Unitdata[i].Maxunits = maxunits; end

        local image = InputFieldTable[i].Image.GetValue();
        if image < 0 or image > Maxpictures then alert("Mod set up failed\nOnly images between 0 -".. Maxpictures..'\nReset to default settings'); 
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
        
        local shared = InputFieldTable[i].Shared.GetIsChecked()
        Mod.Settings.Unitdata[i].Shared = shared

        local visible = InputFieldTable[i].Visible.GetIsChecked()
        Mod.Settings.Unitdata[i].Visible = visible
        
        local maxserver = InputFieldTable[i].MaxServer.GetValue()
        if (maxserver > 50 or maxserver < 0 )then maxserver = 0 alert("Max amount over entire server input outside data range. min: 0, Max: 50")
        else Mod.Settings.Unitdata[i].MaxServer = maxserver end

 
        local minlife = InputFieldTable[i].Minlife.GetValue() 
       if minlife < 0 or minlife > 99 then 
        alert('Minimum amount for life is 0\nReset to default settings')
        Mod.Settings.Unitdata[i].Minlife = 0
       else Mod.Settings.Unitdata[i].Minlife = minlife end

       local maxlife = InputFieldTable[i].Maxlife.GetValue()  
       if maxlife < minlife or maxlife > 100 then 
        alert('Minimum amount for Max life is equal to "Minimum Turns alive" setting\n Max amount is 100 \nReset to default settings')
        Mod.Settings.Unitdata[i].Maxlife = Mod.Settings.Unitdata[i].Minlife
       else Mod.Settings.Unitdata[i].Maxlife = maxlife end

       local transfer = InputFieldTable[i].Transfer.GetValue()
       if (transfer > 25 or transfer < -1 )then transfer = 0 alert("Transfer input outside data range. min: 0, Max: 25")
       else Mod.Settings.Unitdata[i].Transfer = transfer end

       local level = InputFieldTable[i].Level.GetValue()
       if (level > 5000 or level < 0 )then level = 0 alert("level input outside data range. min: 0, Max: 5000")
       else Mod.Settings.Unitdata[i].Level = level end

       local active = InputFieldTable[i].Active.GetValue()
       if (active > 200 or active < 0 )then active = 0 alert("unit Active input outside data range. min: 0, Max: 200")
       else Mod.Settings.Unitdata[i].Active = active end

       local defend = InputFieldTable[i].Defend.GetValue()
       if (defend < 0 )then defend = 0 alert("Mod set up failed\n Units cannot have a defence power below 0\nReset to default settings")
       else Mod.Settings.Unitdata[i].Defend = defend end

       local altmoves = InputFieldTable[i].Altmoves.GetIsChecked()
       Mod.Settings.Unitdata[i].Altmoves = altmoves

       --cooldown
       local cooldown = InputFieldTable[i].Cooldown.GetValue()
       if (cooldown < 0 or cooldown > 100)then cooldown = 0 alert("Mod set up failed\n Units cannot have a cool down timer longer then 100 or below 0\n(set to 0 to disable)")
       else Mod.Settings.Unitdata[i].Cooldown = cooldown end

       --host Rules
        local hostrules = InputFieldTable[i].HostRules.GetText()
        Mod.Settings.Unitdata[i].HostRules = hostrules;

        --Assassnation
        local assass = InputFieldTable[i].Assassination.GetValue()
        if (assass < 0 or assass > 5)then assass = 0 alert("Mod set up failed\n Assassination level must be between 0 and 5\n(set to 0 to disable)")
        else Mod.Settings.Unitdata[i].Assassination = assass end

        tomanyunits = tomanyunits + maxunits -- check if they exceeded the max units i wanna allow
         noUnitsOn = noUnitsOn + maxunits -- to check if any units were turned on
    end

   end
   if (noUnitsOn <= 0)then alert("Failed to add any Unit types")  end 
   if (tomanyunits > Unitsallowed)then alert("You are only allowed ".. Unitsallowed .. " total units across all unit types") end

   Mod.Settings.access = 3
   Mod.Settings.BeforeMax = InputFieldTable.BeforeMax


end
