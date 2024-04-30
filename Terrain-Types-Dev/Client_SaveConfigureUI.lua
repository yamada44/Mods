require('Utilities')

function Client_SaveConfigureUI(alert)
    local noUnitsOn = 0
    local tomanyunits = 0
    local Unitsallowed = 15
    local num = 'number'
    local boo = 'bool'
    local tex = 'text'

	if TerrainTypeMax == nil or TerrainTypeMax < 1 or TerrainTypeMax > TerrainTypeMax then  -- make sure unit types are between 1 and 6
        UI.Alert('you need to create some unit types by pressing the refresh Button')
        TerrainTypeMax = 0
    end
    for i = 1, TerrainTypeMax do  -- Start of new unit cycle
        if InputFieldTable[i].TempCreated == false then alert("Did not initialize Template ".. i) 
        else 
            Mod.Settings.Landdata[i].TempCreated = InputFieldTable[i].TempCreated

            --AutoFind
            local auto = TableFormat(InputFieldTable[i].C_Autofind ,num)
            if auto < 3 then alert('Mod set up failed\nAutofinder value must be above 3\nReset to default settings')
                Mod.Settings.Landdata[i].C_Autofind = 3
            else
            Mod.Settings.Landdata[i].C_Autofind = auto end
            
	  -- Autofind for ports (second autoFind)
            local autoP = TableFormat(InputFieldTable[i].C_AutoP ,num)
            if autoP < 0 or auto == autoP then alert('Mod set up failed\nAutofinder Port value must be above 0 and cannot be the same value of Autofinder\nSet to 0 to disable')
                Mod.Settings.Landdata[i].C_AutoP = 0
            else
            Mod.Settings.Landdata[i].C_AutoP = autoP end

        --[[Port Logic
            local portL = TableFormat(InputFieldTable[i].C_Portlogic ,num)
            if (portL < 1 or portL > 2)then combat = 2 alert("Mod set up failed\nPort Logic value must be between 1-2")
                Mod.Settings.Landdata[i].C_Portlogic = 1
            else
            Mod.Settings.Landdata[i].C_Portlogic = portL end
]]--
	  --Value land turned to
            local value = TableFormat(InputFieldTable[i].C_Value ,num)
             if (value < 1 or value > 2)then combat = 2 alert("Mod set up failed\nCombat order value must be between 1-2")
                Mod.Settings.Landdata[i].C_Value = 1
            else
            Mod.Settings.Landdata[i].C_Value = value; end

	  --Start turn
            local turnS = TableFormat(InputFieldTable[i].C_Turnstart ,num)
             if (turnS < 1 or turnS > 2)then combat = 2 alert("Mod set up failed\nCombat order value must be between 1-2")
            else
            Mod.Settings.Landdata[i].C_Turnstart = turnS; end

	  --End turn
            local turnE = TableFormat(InputFieldTable[i].C_Turnend ,num)
             if (turnE < 1 or turnE > 2)then turnE = 2 alert("Mod set up failed\nCombat order value must be between 1-2")
            else
            Mod.Settings.Landdata[i].C_Turnend = turnE end

            --OwnerID
            local ownerID = TableFormat(InputFieldTable[i].C_TerrainTypeID ,num)
             if (ownerID < 1 or ownerID > 2)then ownerID = 2 alert("Mod set up failed\nCombat order value must be between 1-2")
            else
            Mod.Settings.Landdata[i].C_TerrainTypeID = ownerID end

            --Mod Settings
            local modsetting = TableFormat(InputFieldTable[i].C_Modsetting ,num)
             if (modsetting < 1 or modsetting > 2)then modsetting = 2 alert("Mod set up failed\nCombat order value must be between 1-2")
            else
            Mod.Settings.Landdata[i].C_Modsetting = modsetting end

            --Unit Type
            local unitT = TableFormat(InputFieldTable[i].C_Unittype ,num)
             if (unitT < 1 or unitT > 2)then unitT = 2 alert("Mod set up failed\nCombat order value must be between 1-2")
                Mod.Settings.Landdata[i].C_Unittype = 1
            else
            Mod.Settings.Landdata[i].C_Unittype = unitT end

            --Inverse
            local inverse = TableFormat(InputFieldTable[i].C_Inverse,boo)
            Mod.Settings.Landdata[i].C_Inverse = inverse
            
            --Name
            if (TableFormat(InputFieldTable[i].C_Name,tex) ~= '' and TableFormat(InputFieldTable[i].C_Name,tex) ~= nil)then
            local name = TableFormat(InputFieldTable[i].C_Name,tex)
            Mod.Settings.Landdata[i].C_Name = name;
            elseif(TerrainTypeMax ~= 0)then
            Mod.Settings.Landdata[i].C_Name = " (( NO NAME GIVEN ))" 
                UI.Alert("NO NAME GIVEN TO terrain TYPE(S) that are enabled\nReset to default settings")
            end


            noUnitsOn = noUnitsOn + TerrainTypeMax -- to check if any units were turned on


        end
    Mod.Settings.Landdata[i].TemplateStored = InputFieldTable[i].TemplateStored -- storing and saving of unit type
    end

    if (noUnitsOn <= 0) then alert("Failed to add any Terrain types") end 
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