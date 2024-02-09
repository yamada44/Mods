require('Utilities');

function Server_StartGame (game,standing)
    Pub = Mod.PublicGameData

    Datecreation()



    Mod.PublicGameData = Pub
end

function Datecreation()
local view = true
	local short = Mod.Settings
    local view = false
    local total = 0

    if short.Viewing == 1 then view = true end
    for i = 1, #short.Monthdays do
    
        total = total + short.Monthdays[i]
    end

	Pub.Date = {}
    Pub.TimePassing = {}
    Pub.History = {}
    Pub.template = {}
	Pub.Date.year = short.Year
	Pub.Date.month = short.Month
	Pub.Date.day = short.Day
	Pub.Date.hour = short.Hour
    Pub.Date.mintue = short.Mintue
	Pub.Date.second = short.Second
    Pub.Date.DayName = ""
    Pub.Date.abb = ""
--Storing Tables
    Pub.Daysofweek = short.Weeknames
    Pub.NameofMonths = short.Monthnames
    Pub.Daysinmonths = short.Monthdays
    Pub.Before = short.Before
    Pub.After = short.After
--Counting of values
    Pub.NumberofWeekdays = #short.Weeknames
    Pub.NumberofMonths = #short.Monthnames
    Pub.TotalDays = total
    Pub.CurrentDay = 0 --dont count
    Pub.baseMin = 60
    Pub.Basehour = 24
--Time passing per turn numbers
    Pub.TimePassing.year = short.IYear
	Pub.TimePassing.month = short.IMonth
	Pub.TimePassing.day = short.IDay
	Pub.TimePassing.hour = short.IHour
    Pub.TimePassing.mintue = short.IMinute
	Pub.TimePassing.second = short.ISecond
--Templates
    Pub.template.year = view
    Pub.template.monthname = false
	Pub.template.month = view
    Pub.template.DayName = false
	Pub.template.day = view
	Pub.template.hour = (not view)
    Pub.template.mintue = (not view)
	Pub.template.second = (not view)
    Pub.template.abb = view

    Pub.template.Display = {}
    Pub.template.Display[1] = {value = "year",see = view,text = "Year",order = 1}
    Pub.template.Display[2] = {value = "month",see = view,text = "Month",order = 2}
    Pub.template.Display[3] = {value = "day",see = view,text = "Day",order = 3}
    Pub.template.Display[4] = {value = "hour",see = (not view),text = "Hour",order = 4}
    Pub.template.Display[5] = {value = "mintue",see = (not view),text = "Mintue",order = 5}
    Pub.template.Display[6] = {value = "second",see = (not view),text = "Second",order = 6}
 

--History
Pub.Date.abb = Pub.After
if Pub.Date.year < 0 then Pub.Date.abb = Pub.Before end
--finding weekname
local totaldays = Finddayofweek(Pub.Daysinmonths,Pub.Date.month,Pub.Date.day)
local nameindex = Calculateweek(totaldays,Pub.NumberofWeekdays)

    table.insert(Pub.History,{})
    Pub.History[1].year = short.Year 
    Pub.History[1].month = short.Month 
    Pub.History[1].day = short.Day 
    Pub.History[1].hour = short.Hour 
    Pub.History[1].mintue = short.Mintue 
    Pub.History[1].second = short.Second 
    Pub.History[1].abb = Pub.Date.abb
    Pub.History[1].DayName =  Pub.Daysofweek[nameindex]
    Pub.History[1].turn = 1
    Pub.History[1].monthname = short.Monthnames[short.Month]

--Continued Templates
    Pub.template.Display[7] = {text = "Month Name",see = false,value = "monthname",order = 7}
    Pub.template.Display[8] = {text =  "Week Day",see = false,value = "DayName",order = 8}

end