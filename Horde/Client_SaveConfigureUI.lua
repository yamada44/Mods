require('Utilities')


function Client_SaveConfigureUI(alert)

   local slotamount = split(Slotfield.GetText(), '/')

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

        Mod.Settings.Slot = slotnumbers
        Mod.Settings.Slotstore = Slotfield.GetText()
      

--troop converstion
local tcon = Convfield.GetValue()
if tcon > 200 or tcon < 0 then alert("Mod set up failed\nYour Troop converstion value Must be between 0-200")
else 

   Mod.Settings.TConv = tcon
end 

--build
local build = Buildfield.GetValue()
if build > 18 or build < 0 then alert("Mod set up failed\nYour Build value Must be between 0-18\nSet to 0 to disable Structures")
else 

   Mod.Settings.StructureType = Buildtype(build)
   Mod.Settings.Buildname = Buildname(build)
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

--Cities removed if owned
local cityg = CityGone.GetValue()
if cityg < 0 or cityg > 20 then alert("Mod set up failed\nYour City Removed value Must be between 0 and 20")
else 
   Mod.Settings.CityGone = cityg
end 


--Can Deploy troops
   local dtroop= Deployfield.GetValue()
   if dtroop > 3 or dtroop < 1 then alert("Mod set up failed\nYour Deployment value Must be between 1 and 3")
   else 
      Mod.Settings.TDep = dtroop
   end 

--Attack rules
   local attack= Attackfield.GetValue()
   if attack > 5000 or attack < 1 then alert("Mod set up failed\nYour Deployment value Must be between 1 and 5000")
   else 
      Mod.Settings.Attack = attack
   end 

--Fort rules
local fort = Fortfield.GetValue()
if fort > 5 or fort < 0 then alert("Mod set up failed\nYour Fort attack value Must be between 0 and 5")
else 
   Mod.Settings.Fort = fort
end 
   
   
--Airlift card
   Mod.Settings.PlayAir = Airfield.GetIsChecked()
 

--Sanction Card
   Mod.Settings.PlaySan = Sanfield.GetIsChecked()
 

--Diplo Card
   Mod.Settings.PlayDip = Dipfield.GetIsChecked() 

--Ref Card
   Mod.Settings.PlayRef = Reffield.GetIsChecked() 

--No cities
   Mod.Settings.Nocities = Nocities.GetIsChecked() 
    
   --Aggresive AI
   Mod.Settings.Agg = Aggfield.GetIsChecked() 

end
