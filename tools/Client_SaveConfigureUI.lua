require('Utilities')


function Client_SaveConfigureUI(alert)

--mapping data
  
local monthdays2 = split(monthdayfield.GetText(), '/')
local weeknames = split(weeknamesfield.GetText(), '/')
local monthnames = split(monthnamefield.GetText(), '/')
local monthdays = {}
    --Month days checker
    for i,v in pairs (monthdays2) do
        if string.match(v, '%D+') then
            alert("Mod set up failed\nCan only inlcude numbers for month days") 
        
        elseif string.len(v) > 2 or string.len(v) < 1 then
            alert("Mod set up failed\nEach month day count must remain between 1-99 for each month") 
        end
        table.insert(monthdays,tonumber(v))
        
    end


    if #monthdays ~= #monthnames then alert("Mod set up failed\nThe amount of days per month do not match the amount of month names") 
    elseif monthdays == nil or #monthdays == 0 then alert("Mod set up failed\nyou have no days for each month") 
    elseif weeknames == nil or #weeknames == 0 then alert("Mod set up failed\nyou have no week day names") 
    elseif monthnames == nil or #monthnames == 0 then alert("Mod set up failed\nyou have no month names")         
    else
        
        Mod.Settings.Monthdays = monthdays
        Mod.Settings.Weeknames = weeknames
        Mod.Settings.Monthnames = monthnames
        
        --Saving data
        Mod.Settings.HMonthdays = monthdayfield.GetText()
        Mod.Settings.HWeeknames = weeknamesfield.GetText()
        Mod.Settings.HMonthnames = monthnamefield.GetText()

    end
--After
    local after = afterfield.GetText()
    if after == '' or after == nil then alert("Mod set up failed\nMust give your after 0 Abbreviation") 
    else 
         Mod.Settings.After = after
    end

--Before
    local before = beforefield.GetText()
    if before == '' or before == nil then alert("Mod set up failed\nMust give your Before 0 Abbreviation") 
    else 
         Mod.Settings.Before = before
    end
    
--ISecond
    local isec = Isecfield.GetValue()
    if isec > 500 or isec < 0 then alert("Mod set up failed\nYour Seconds per turn value Must be between 0-500")
    else 
        Mod.Settings.ISecond = isec
    end 

 --IMintue
    local iMin = Iminfield.GetValue()
    if iMin > 500 or iMin < 0 then alert("Mod set up failed\nYour Mintues per turn value Must be between 0-500")
    else 
        Mod.Settings.IMinute = iMin
    end 
    
--IHour
     local ihour = Ihourfield.GetValue()
     if ihour > 200 or ihour < 0 then alert("Mod set up failed\nYour Hours per turn value Must be between 0-200")
     else 
         Mod.Settings.IHour = ihour
     end 

--IDay
     local iday = Idayfield.GetValue()
     if iday > 500 or iday < 0 then alert("Mod set up failed\nYour Days per turn value Must be between 0-500")
     else 
         Mod.Settings.IDay = iday
     end 
    
--IMonth
    local imonth = Imonthfield.GetValue()
    if imonth > 40 or imonth < 0 then alert("Mod set up failed\nYour months per turn value Must be between 0-40")
    else 
        Mod.Settings.IMonth = imonth
    end 

--Iyear
    local iyear = IYearfield.GetValue()
    if iyear < 0 then alert("Mod set up failed\nYour months per turn value Must be between 0-??")
    else 
        Mod.Settings.IYear = iyear
    end 
--Current Time at game start 
--Second
    local sec = Secfield.GetValue()
    if sec > MinSec or sec < 1 then alert("Mod set up failed\nCurrent Second value Must be between 1-"..MinSec)
    else 
        Mod.Settings.Second = sec
    end 
    
--Mintue
    local min = Minfield.GetValue()
    if min > MinSec or min < 1 then alert("Mod set up failed\nCurrent Mintue value Must be between 1-"..MinSec)
    else 
        Mod.Settings.Mintue = min
    end 
    
--Hour
    local hour = Hourfield.GetValue()
    if hour > HoursinDay or min < 1 then alert("Mod set up failed\nCurrent Hour value Must be between 1-"..HoursinDay)
    else 
        Mod.Settings.Hour = hour
    end 


--Month
    local month = Monthfield.GetValue() -- getting month value
    if month > #monthdays or month < 1 then alert("Mod set up failed\nCurrent Month value Must be between 1-"..#monthdays) return
    else 
        Mod.Settings.Month = month
    end 

--Day
    local day = Dayfield.GetValue()
    if monthdays[month] < day then alert("Mod set up failed\nCurrent Day must stay within your starting month length, which is between 1-"..monthdays[month]) return end
    if day > HoursinDay or day < 1 then alert("Mod set up failed\nCurrent Day value Must be between 0-99")
    else 
        Mod.Settings.Day = day
    end 

--Year
    local year = yearfield.GetValue()
    if year == nil then alert("Mod set up failed\nCurrent Year value must not be nil")
    else 
        Mod.Settings.Year = year
    end 
    
    
    

end
