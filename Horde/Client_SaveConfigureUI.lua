require('Utilities')


function Client_SaveConfigureUI(alert)



--Slot
     local slot = Slotfield.GetValue()
     if slot > 40 or slot < 1 then alert("Mod set up failed\nYour Slot value Must be between 1-40")
     else 
        slot = slot -1
        Mod.Settings.Slot = slot
     end 

--troop converstion
local tcon = Convfield.GetValue()
if tcon > 100 or slot < 0 then alert("Mod set up failed\nYour Troop converstion value Must be between 0-100")
else 

   Mod.Settings.TConv = tcon
end 

--build
local build = Buildfield.GetValue()
if build > 18 or build < 0 then alert("Mod set up failed\nYour Build value Must be between 0-18")
else 

   Mod.Settings.StructureType = Buildtype(build)
end 

--Cost
local cost = Costfield.GetValue()
if cost < 0 then alert("Mod set up failed\nYour Hive Cost value Must be 0 or above")
else 

   Mod.Settings.HiveCost = cost
end 

--Max
local max = Maxfield.GetValue()
if max > 50 or max < 0 then alert("Mod set up failed\nYour Max Hive value Must be between 0-50")
else 

   Mod.Settings.Maxhives = max
end 

--Auto
local auto = Autofield.GetValue()
if auto < 0 then alert("Mod set up failed\nYour Autoplace value Must be 0 or above")
else 

   Mod.Settings.Auto = auto
end 

--Can Deploy troops
   Mod.Settings.TDep = Deployfield.GetIsChecked()

--Airlift card
   Mod.Settings.PlayAir = Airfield.GetIsChecked()
 

--Sanction Card
   Mod.Settings.PlaySan = Sanfield.GetIsChecked()
 

--Diplo Card
   Mod.Settings.PlayDip = Dipfield.GetIsChecked() 
    

end
