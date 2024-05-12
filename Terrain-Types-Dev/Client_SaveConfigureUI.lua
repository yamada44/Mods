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
            if autoP < 3 then alert('Mod set up failed\nAutofinder Port value must be above 3\nSet to base autofind to disable')
                Mod.Settings.Landdata[i].C_AutoP = 0
            else
            Mod.Settings.Landdata[i].C_AutoP = autoP end

	  --Value land turned to
            local value = TableFormat(InputFieldTable[i].C_Value ,num)
             if (value < -1 or value > 10000)then alert("Mod set up failed\nValue value(haha) must be between -1 - 10,000")
                Mod.Settings.Landdata[i].C_Value = 0
            else
            Mod.Settings.Landdata[i].C_Value = value; end

	  --Start turn
            local turnS = TableFormat(InputFieldTable[i].C_Turnstart ,num)
             if (turnS < -1 or turnS > 150)then alert("Mod set up failed\n Start turn value must be between -1 - 150")
            else
            Mod.Settings.Landdata[i].C_Turnstart = turnS; end

	  --End turn
            local turnE = TableFormat(InputFieldTable[i].C_Turnend ,num)
             if (turnE < 0 or turnE > 150 or turnE < turnS)then alert("Mod set up failed\n End turn value must be between 1-150")
            else
            Mod.Settings.Landdata[i].C_Turnend = turnE end

            --OwnerID
            local ownerID = TableFormat(InputFieldTable[i].C_TerrainTypeID ,num)
             if (ownerID < -3 or ownerID > 99999999)then alert("Mod set up failed\n ownerID value must be between -3 - 99,999,999")
            else
            Mod.Settings.Landdata[i].C_TerrainTypeID = ownerID end

            --Mod Settings
            local modsetting = TableFormat(InputFieldTable[i].C_Modsetting ,num)
             if (modsetting < 0 or modsetting > 18)then alert("Mod set up failed\n mod setting value must be between 0-18")
            else
            Mod.Settings.Landdata[i].C_Modsetting = modsetting end

            --Unit Type
            local unitT = TableFormat(InputFieldTable[i].C_Unittype ,num)
             if (unitT < 0 or unitT > 8)then  alert("Mod set up failed\nunit type value must be between 0-8")
                Mod.Settings.Landdata[i].C_Unittype = 1
            else
            Mod.Settings.Landdata[i].C_Unittype = unitT end

            --Base Settings
            local inverse = TableFormat(InputFieldTable[i].C_Inverse ,num)
             if (inverse < 1 or inverse > 4)then alert("Mod set up failed\nStandard settings value must be between 1-4")
                Mod.Settings.Landdata[i].C_Inverse = 1
            else
            Mod.Settings.Landdata[i].C_Inverse = inverse end

            --Buildings
            local build = TableFormat(InputFieldTable[i].C_RemoveBuild,boo)
            Mod.Settings.Landdata[i].C_RemoveBuild = build

            
            --Name
            if (TableFormat(InputFieldTable[i].C_Name,tex) ~= '' and TableFormat(InputFieldTable[i].C_Name,tex) ~= nil)then
            local name = TableFormat(InputFieldTable[i].C_Name,tex)
            Mod.Settings.Landdata[i].C_Name = name;
            elseif(TerrainTypeMax ~= 0)then
            Mod.Settings.Landdata[i].C_Name = " (( NO NAME GIVEN ))" 
                UI.Alert("NO NAME GIVEN TO terrain TYPE(S) that are enabled\nReset to default settings")
            end
            
------------Add on
            if (TableFormat(InputFieldTable[i].C_Defined,tex) ~= '' and TableFormat(InputFieldTable[i].C_Defined,tex) ~= nil)then
                local Preformat = TableFormat(InputFieldTable[i].C_Defined,tex)
                local Specialunitgroup = split(Preformat, '/')
                local Specialunitdetails = {}
                for i = 1, #Specialunitgroup do
                    Specialunitdetails[i].rawdata = split(Specialunitgroup[i], '-')
                end

                local SUgroup = {}
                for index, value in ipairs(Specialunitdetails) do
                    table.insert(SUgroup,{})
                    for i,v in pairs (value) do
                        if string.match(v, '%D+') then
                            alert("Mod set up failed\nCan only inlcude numbers for Mod defined") 
                            return
                        elseif string.len(v) > 2 or string.len(v) < 1 then
                            alert("Mod set up failed\nMod define format must remain between 0-99 ") 
                            return
                        end
                        table.insert(SUgroup[index][i],tonumber(v))
                    
                    end 
                end
         --Slot
         
                 Mod.Settings.Landdata[i].C_Definegroup = SUgroup
                 Mod.Settings.Landdata[i].C_DefinedStored = InputFieldTable[i].C_Defined
            end
        end
    Mod.Settings.Landdata[i].TemplateStored = InputFieldTable[i].TemplateStored -- storing and saving of unit type
    end

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

    return returnvalue
end