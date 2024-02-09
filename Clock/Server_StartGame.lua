require('Utilities');

function Server_StartGame (game,standing)
    Pub = Mod.PublicGameData
    Game = game
    Datecreation()



    Mod.PublicGameData = Pub
end

function Datecreation()
	local short = Mod.Settings
    local total = 0

    Pub.Date = {}
    Pub.TimePassing = {}
    Pub.History = {}

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

    Pub.Date.abb = Pub.After
if Pub.Date.year < 0 then Pub.Date.abb = Pub.Before end
--finding weekname
local totaldays = Finddayofweek(Pub.Daysinmonths,Pub.Date.month,Pub.Date.day)
local nameindex = Calculateweek(totaldays,Pub.NumberofWeekdays)

    --History

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

    for playerID, player in pairs(Game.Game.PlayingPlayers)do
    for i = 1, #short.Monthdays do
    
        total = total + short.Monthdays[i]
    end
    Pub[playerID] = {} 
    Pub[playerID].template = {}

--Templates
    Pub[playerID].template.year = true
    Pub[playerID].template.monthname = true
	Pub[playerID].template.month = true
    Pub[playerID].template.DayName = true
	Pub[playerID].template.day = true
	Pub[playerID].template.hour = true
    Pub[playerID].template.mintue = true
	Pub[playerID].template.second = true
    Pub[playerID].template.abb = true

    Pub[playerID].template.Display = {}
    Pub[playerID].template.Display[1] = {value = "year",see = true,text = "Year",order = 1}
    Pub[playerID].template.Display[2] = {value = "month",see = true,text = "Month",order = 2}
    Pub[playerID].template.Display[3] = {value = "day",see = true,text = "Day",order = 3}
    Pub[playerID].template.Display[4] = {value = "hour",see = true,text = "Hour",order = 4}
    Pub[playerID].template.Display[5] = {value = "mintue",see = true,text = "Mintue",order = 5}
    Pub[playerID].template.Display[6] = {value = "second",see = true,text = "Second",order = 6}
 

--Continued Templates
    Pub[playerID].template.Display[7] = {text = "Month Name",see = true,value = "monthname",order = 7}
    Pub[playerID].template.Display[8] = {text =  "Week Day",see = true,value = "DayName",order = 8}
end

end