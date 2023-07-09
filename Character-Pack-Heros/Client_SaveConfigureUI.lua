



function Client_SaveConfigureUI(alert)

    local noUnitsOn = 0
    local tomanyunits = 0
    local Unitsallowed = 15





	if UnitTypeMax == nil or UnitTypeMax < 1 or UnitTypeMax > 6 then  -- make sure unit types are between 1 and 6
        UI.Alert('you need to create some unit types by pressing the refresh Button')
        UnitTypeMax = 0
    end
   for i = 1, UnitTypeMax do  -- Start of new unit cycle
        if InputFieldTable[i].TempCreated == false then alert("Did not initialize Template ".. i) 
        else 

            SaveData(i)

            Mod.Settings.Unitdata[i].TempCreated = InputFieldTable[i].TempCreated

        local cost = InputFieldTable[i].unitcost
        if cost < 1 then alert("Mod set up failed\nCost to buy this Unit must be positive\nReset to default settings"); 
            Mod.Settings.Unitdata[i].unitcost = 1
        else
        Mod.Settings.Unitdata[i].unitcost = cost; end 


        local power = InputFieldTable[i].unitpower
        if power < 0 then alert("Mod set up failed\n Units cannot have a Minimum attack Range below 0\nReset to default settings"); 
            Mod.Settings.Unitdata[i].unitpower = 1
        else Mod.Settings.Unitdata[i].unitpower = power; end

        local maxatt = InputFieldTable[i].AttackMax
        if maxatt < 0 or maxatt < power then alert("Mod set up failed\nUnits cannot have a Maximum attack power below 0 or below Minimum attack Range\nReset to default settings"); 
            Mod.Settings.Unitdata[i].AttackMax = Mod.Settings.Unitdata[i].unitpower
        else Mod.Settings.Unitdata[i].AttackMax = maxatt; end
    
        local maxunits = InputFieldTable[i].Maxunits
        if maxunits > 5 or maxunits < 1 then alert("Mod set up failed\nMax Units cannot be greater then 5\nReset to default settings"); 
            Mod.Settings.Unitdata[i].Maxunits = 1
        else
        Mod.Settings.Unitdata[i].Maxunits = maxunits; end

        local image = InputFieldTable[i].image
        if image < 0 or image > Maxpictures then alert("Mod set up failed\nOnly images between 0 -".. Maxpictures..'\nReset to default settings'); 
            Mod.Settings.Unitdata[i].image = 1
        else
        Mod.Settings.Unitdata[i].image = image; end

        if (InputFieldTable[i].Name ~= '' and InputFieldTable[i].Name ~= nil)then
        local name = InputFieldTable[i].Name
        Mod.Settings.Unitdata[i].Name = name;
        elseif(maxunits ~= 0)then
         Mod.Settings.Unitdata[i].Name = " (( NO NAME GIVEN ))" 
            UI.Alert("NO NAME GIVEN TO UNIT TYPE(S) that are enabled\nTo disable Unit Types set their Maxunit's to 0\nReset to default settings")
        end

        local shared = InputFieldTable[i].Shared
        Mod.Settings.Unitdata[i].Shared = shared

        local visible = InputFieldTable[i].Visible
        Mod.Settings.Unitdata[i].Visible = visible
        
        local maxserver = InputFieldTable[i].MaxServer
        if (maxserver > 50 or maxserver < 0 )then maxserver = 0 alert("Max amount over entire server input outside data range. min: 0, Max: 50")
        else Mod.Settings.Unitdata[i].MaxServer = maxserver end

 
        local minlife = InputFieldTable[i].Minlife
       if minlife < 0 or minlife > 99 then 
        alert('Minimum amount for life is 0\nReset to default settings')
        Mod.Settings.Unitdata[i].Minlife = 0
       else Mod.Settings.Unitdata[i].Minlife = minlife end

       local maxlife = InputFieldTable[i].Maxlife 
       if maxlife < minlife or maxlife > 100 then 
        alert('Minimum amount for Max life is equal to "Minimum Turns alive" setting\n Max amount is 100 \nReset to default settings')
        Mod.Settings.Unitdata[i].Maxlife = Mod.Settings.Unitdata[i].Minlife
       else Mod.Settings.Unitdata[i].Maxlife = maxlife end

       --transfer
       local transfer = InputFieldTable[i].Transfer
       if (transfer > 25 or transfer < -1 )then transfer = 0 alert("Transfer input outside data range. min: 0, Max: 25")
       else Mod.Settings.Unitdata[i].Transfer = transfer end

       --leveling
       local level = InputFieldTable[i].Level
       if (level > 5000 or level < 0 )then level = 0 alert("level input outside data range. min: 0, Max: 5000")
       else Mod.Settings.Unitdata[i].Level = level end

       --Active
       local active = InputFieldTable[i].Active
       if (active > 200 or active < 0 )then active = 0 alert("unit Active input outside data range. min: 0, Max: 200")
       else Mod.Settings.Unitdata[i].Active = active end

       --defence
       local defend = InputFieldTable[i].Defend
       if (defend < 0 )then defend = 0 alert("Mod set up failed\n Units cannot have a defence power below 0\nReset to default settings")
       else Mod.Settings.Unitdata[i].Defend = defend end

       local altmoves = InputFieldTable[i].Altmoves
       Mod.Settings.Unitdata[i].Altmoves = altmoves

       --cooldown
       local cooldown = InputFieldTable[i].Cooldown
       if (cooldown < 0 or cooldown > 100)then cooldown = 0 alert("Mod set up failed\n Units cannot have a cool down timer longer then 100 or below 0\n(set to 0 to disable)")
       else Mod.Settings.Unitdata[i].Cooldown = cooldown end

       --host Rules
        local hostrules = InputFieldTable[i].HostRules
        Mod.Settings.Unitdata[i].HostRules = hostrules;

        --Assassnation
        local assass = InputFieldTable[i].Assassination
        if (assass < 0 or assass > 5)then assass = 0 alert("Mod set up failed\n Assassination level must be between 0 and 5\n(set to 0 to disable)")
        else Mod.Settings.Unitdata[i].Assassination = assass end

        tomanyunits = tomanyunits + maxunits -- check if they exceeded the max units i wanna allow
         noUnitsOn = noUnitsOn + maxunits -- to check if any units were turned on

         if Mod.Settings.Unitdata[i].TempGroupcopy == nil then Mod.Settings.Unitdata[i].TempGroupcopy = {} end
      --   Mod.Settings.Unitdata[i].TempGroupcopy = InputFieldTable[i]

    end
    print('problem 4')
   end
       print('problem 5')
   if (noUnitsOn <= 0)then alert("Failed to add any Unit types")  end 
   if (tomanyunits > Unitsallowed)then alert("You are only allowed ".. Unitsallowed .. " total units across all unit types") end
   print('problem 6')
   Mod.Settings.access = 3
   Mod.Settings.BeforeMax = InputFieldTable.BeforeMax

   print('problem 7')
end

function SaveData(i)

    InputFieldTable[i].unitcost = TempUI[i].unitcost.GetValue()
InputFieldTable[i].unitpower = TempUI[i].unitpower.GetValue()
InputFieldTable[i].AttackMax = TempUI[i].AttackMax.GetValue()
InputFieldTable[i].Defend = TempUI[i].Defend.GetValue()
InputFieldTable[i].Maxunits = TempUI[i].Maxunits.GetValue()
InputFieldTable[i].Minlife = TempUI[i].Minlife.GetValue()
InputFieldTable[i].Maxlife = TempUI[i].Maxlife.GetValue()
InputFieldTable[i].image = TempUI[i].image.GetValue()
InputFieldTable[i].Transfer = TempUI[i].Transfer.GetValue()
InputFieldTable[i].Level = TempUI[i].Level.GetValue()
InputFieldTable[i].Active = TempUI[i].Active.GetValue()
InputFieldTable[i].MaxServer = TempUI[i].MaxServer.GetValue()
InputFieldTable[i].Cooldown = TempUI[i].Cooldown.GetValue()
InputFieldTable[i].Assassination = TempUI[i].Assassination.GetValue()
InputFieldTable[i].Shared = TempUI[i].Shared.GetIsChecked()
InputFieldTable[i].Visible = TempUI[i].Visible.GetIsChecked()
InputFieldTable[i].Altmoves = TempUI[i].Altmoves.GetIsChecked()
InputFieldTable[i].Name = TempUI[i].Name.GetText()
InputFieldTable[i].HostRules = TempUI[i].HostRules.GetText()
end
