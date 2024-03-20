require('Utilities')


function Client_SaveConfigureUI(alert)

--Cost
local cost = Costfield.GetValue()
if cost < 0 then alert("Mod set up failed\nYour Fort Cost value Must be 0 or above")
else 

   Mod.Settings.HiveCost = cost
end 

--Max
local max = Maxfield.GetValue()
if max > 25 or max < 1 then alert("Mod set up failed\nYour Max Fort value Must be between 1-25")
else 

   Mod.Settings.Maxhives = max
end 

--Cost increase
local inX = increaseXfield.GetValue()
if inX > 1000 or inX < 0 then alert("Mod set up failed\nYour Cost increase value Must be between 0 and 1000")
else 

   Mod.Settings.Costincrease = inX
end 

--Needed troops
local need = Needfield.GetValue()
if need < -1 then alert("Mod set up failed\nYour Needed troops value Must be -1 or above")
else 
   Mod.Settings.Need = need
end 

--Limit
local limit = Limitfield.GetValue()
if limit < 0 or limit > 5 then alert("Mod set up failed\nYour Limit on tile per Fort value Must be between 0 and 5")
else 
   Mod.Settings.Limit = limit
end 

--Limit
local scale = Scalefield.GetValue()
if scale < 0  then alert("Mod set up failed\nYour Turn scale value Must be 0 or higher")
else 
   Mod.Settings.Scale = scale
end 

--Turn
local turn = Turnfield.GetValue()
if turn < 1  or turn > 100 then alert("Mod set up failed\nYour Turn scale value Must be between 1 and 100\nSet Turn scale to 0 to disable")
else 
   Mod.Settings.Turn = turn
end 

--Market value
   Mod.Settings.Market = Marketfield.GetIsChecked()

end
