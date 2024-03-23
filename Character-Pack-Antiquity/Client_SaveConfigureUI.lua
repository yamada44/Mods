require('Utilities')



function Client_SaveConfigureUI(alert)

    local noUnitsOn = 0
    local tomanyunits = 0
    local Unitsallowed = 15
    local num = 'number'
    local boo = 'bool'
    local tex = 'text'




	if UnitTypeMax == nil or UnitTypeMax < 1 or UnitTypeMax > 6 then  -- make sure unit types are between 1 and 6
        UI.Alert('you need to create some unit types by pressing the refresh Button')
        UnitTypeMax = 0
    end
   for i = 1, UnitTypeMax do  -- Start of new unit cycle
        if InputFieldTable[i].TempCreated == false then alert("Did not initialize Template ".. i) 
        else 


            Mod.Settings.Unitdata[i].TempCreated = InputFieldTable[i].TempCreated

        --cost
        local cost = TableFormat(InputFieldTable[i].unitcost,num)
        if cost < 1 then alert("Mod set up failed\nCost to buy this Unit must be positive\nReset to default settings"); 
            Mod.Settings.Unitdata[i].unitcost = 1
        else
        Mod.Settings.Unitdata[i].unitcost = cost; end 

            --power
        local power = TableFormat(InputFieldTable[i].unitpower ,num)
        if power < 0 then alert("Mod set up failed\n Units cannot have a Minimum attack Range below 0\nReset to default settings")
            Mod.Settings.Unitdata[i].unitpower = 1
        else Mod.Settings.Unitdata[i].unitpower = power; end

        --max attack
        local maxatt = TableFormat(InputFieldTable[i].AttackMax ,num)
        if maxatt < 0 or maxatt < power then alert("Mod set up failed\nUnits cannot have a Maximum attack power below 0 or below Minimum attack Range\nReset to default settings"); 
            Mod.Settings.Unitdata[i].AttackMax = Mod.Settings.Unitdata[i].unitpower
        else Mod.Settings.Unitdata[i].AttackMax = maxatt; end
    
        --Max units
        local maxunits = TableFormat(InputFieldTable[i].Maxunits ,num)
        if maxunits > 5 or maxunits < 1 then alert("Mod set up failed\nMax Units cannot be greater then 5\nReset to default settings"); 
            Mod.Settings.Unitdata[i].Maxunits = 1
        else
        Mod.Settings.Unitdata[i].Maxunits = maxunits; end

        --image
        local image = TableFormat(InputFieldTable[i].image ,num)
        if image < 0 or image > Maxpictures then alert("Mod set up failed\nOnly images between 0 -".. Maxpictures..'\nReset to default settings'); 
            Mod.Settings.Unitdata[i].image = 1
        else
        Mod.Settings.Unitdata[i].image = image; end

        --Name
        if (TableFormat(InputFieldTable[i].Name,tex) ~= '' and TableFormat(InputFieldTable[i].Name,tex) ~= nil)then
        local name = TableFormat(InputFieldTable[i].Name,tex)
        Mod.Settings.Unitdata[i].Name = name;
        elseif(maxunits ~= 0)then
         Mod.Settings.Unitdata[i].Name = " (( NO NAME GIVEN ))" 
            UI.Alert("NO NAME GIVEN TO UNIT TYPE(S) that are enabled\nTo disable Unit Types set their Maxunit's to 0\nReset to default settings")
        end

        --shared
        local shared = TableFormat(InputFieldTable[i].Shared,boo)
        Mod.Settings.Unitdata[i].Shared = shared

        --Visible
        local visible = TableFormat(InputFieldTable[i].Visible,boo)
        Mod.Settings.Unitdata[i].Visible = visible
        
        -- Max on server
        local maxserver = TableFormat(InputFieldTable[i].MaxServer ,num)
        if (maxserver > 50 or maxserver < 0 )then maxserver = 0 alert("Max amount over entire server input outside data range. min: 0, Max: 50")
        else Mod.Settings.Unitdata[i].MaxServer = maxserver end

        --Min life
        local minlife = TableFormat(InputFieldTable[i].Minlife ,num)
       if minlife < 0 or minlife > 99 then 
        alert('Minimum amount for life is 0\nReset to default settings')
        Mod.Settings.Unitdata[i].Minlife = 0
       else Mod.Settings.Unitdata[i].Minlife = minlife end

       --Max life
       local maxlife = TableFormat(InputFieldTable[i].Maxlife ,num)
       if maxlife < minlife or maxlife > 100 then 
        alert('Minimum amount for Max life is equal to "Minimum Turns alive" setting\n Max amount is 100 \nReset to default settings')
        Mod.Settings.Unitdata[i].Maxlife = Mod.Settings.Unitdata[i].Minlife
       else Mod.Settings.Unitdata[i].Maxlife = maxlife end

       --transfer
       local transfer = TableFormat(InputFieldTable[i].Transfer ,num)
       if (transfer > 25 or transfer < -1 )then transfer = 0 alert("Transfer input outside data range. min: 0, Max: 25")
       else Mod.Settings.Unitdata[i].Transfer = transfer end

       --leveling
       local level = TableFormat(InputFieldTable[i].Level ,num)
       if (level > 5000 or level < 0 )then level = 0 alert("level input outside data range. min: 0, Max: 5000")
       else Mod.Settings.Unitdata[i].Level = level end

       --Active
       local active = TableFormat(InputFieldTable[i].Active ,num)
       if (active > 200 or active < 0 )then active = 0 alert("unit Active input outside data range. min: 0, Max: 200")
       else Mod.Settings.Unitdata[i].Active = active end

       --defence
       local defend = TableFormat(InputFieldTable[i].Defend ,num)
       if (defend < 0 )then defend = 0 alert("Mod set up failed\n Units cannot have a defence power below 0\nReset to default settings")
       else Mod.Settings.Unitdata[i].Defend = defend end

       local altmoves = TableFormat(InputFieldTable[i].Altmoves,boo)
       Mod.Settings.Unitdata[i].Altmoves = altmoves

       --cooldown
       local cooldown = TableFormat(InputFieldTable[i].Cooldown ,num)
       if (cooldown < 0 or cooldown > 100)then cooldown = 0 alert("Mod set up failed\n Units cannot have a cool down timer longer then 100 or below 0\n(set to 0 to disable)")
       else Mod.Settings.Unitdata[i].Cooldown = cooldown end

       --host Rules
        local hostrules = TableFormat(InputFieldTable[i].HostRules,tex)
        Mod.Settings.Unitdata[i].HostRules = hostrules;

        --Assassnation
        local assass = TableFormat(InputFieldTable[i].Assassination ,num)
        if (assass < 0 or assass > 5)then assass = 0 alert("Mod set up failed\n Assassination level must be between 0 and 5\n(set to 0 to disable)")
        else Mod.Settings.Unitdata[i].Assassination = assass end

        --Auto placer
        local auto = TableFormat(Nonill(InputFieldTable[i].Autovalue) ,num)
        if (auto < 0 )then auto = 0 alert("Mod set up failed\nAuto placer value cannot be below 0\n(set to 0 to disable)")
        else Mod.Settings.Unitdata[i].Autovalue = auto end

        --combat order
        local combat = TableFormat(Nonill(InputFieldTable[i].Combat) ,num)
        if (combat < 1 or combat > 2)then combat = 2 alert("Mod set up failed\nCombat order value must be between 1-2")
        else Mod.Settings.Unitdata[i].CombatOrder = combat end

        -- only on cities
        local cities = TableFormat(InputFieldTable[i].City,num)
        if type(cities) == "boolean" then cities = 1 end 
        print(cities, "city",type(cities))
        if (cities < 0 or cities > 18)then cities = 0 alert("Mod set up failed\nStructure value must be between 0-18\nSet to 0 to disable")
        else Mod.Settings.Unitdata[i].Oncity = cities end
        print ("bob",Mod.Settings.Unitdata[i].Oncity,cities,"City value")

        tomanyunits = tomanyunits + maxunits -- check if they exceeded the max units i wanna allow
         noUnitsOn = noUnitsOn + maxunits -- to check if any units were turned on

    --Slot Logic
    local slottex = TableFormat(InputFieldTable[i].Slot.GetText(),tex)
    local slotamount = split(slottex, '/')
    local slotnumbers = {}
    for i,v in pairs (slotamount) do
      if string.match(v, '%D+') then
       alert("Mod set up failed\nCan only inlcude numbers for slot days") 
      return
      elseif string.len(v) > 2 or string.len(v) < 1 then
       alert("Mod set up failed\nEach Slot must remain between 1-99 ") 
       return
      end
      table.insert(slotnumbers,tonumber(v - 1))
      
     end
    
    --Slot
    
    Mod.Settings.Unitdata[i].Slot = slotnumbers
    Mod.Settings.Unitdata[i].Slotstore = slottex

    end
    Mod.Settings.Unitdata[i].TemplateStored = InputFieldTable[i].TemplateStored -- storing and saving of unit type
   end

   if (noUnitsOn <= 0)then alert("Failed to add any Unit types")  end 
   if (tomanyunits > Unitsallowed)then alert("You are only allowed ".. Unitsallowed .. " total units across all unit types") end
   Mod.Settings.access = 3
   Mod.Settings.BeforeMax = InputFieldTable.BeforeMax
   

end

function TableFormat(templateValue,tabletype)
local returnvalue = nil

if type(templateValue) == "table" then -- to check type and make sure proper table format is being followed
    if tabletype == 'number' then 
        returnvalue = templateValue.GetValue()

    elseif tabletype == 'bool' then 
        returnvalue = templateValue.GetIsChecked()
    elseif tabletype == 'text' then 
        returnvalue = templateValue.GetText()
    end   

elseif templateValue ~= nil then
    returnvalue = templateValue
end

print('any access',templateValue, returnvalue)
    return returnvalue
end