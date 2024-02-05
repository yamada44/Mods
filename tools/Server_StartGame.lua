require('Utilities');

function Server_StartGame (game,standing)
    Pub = Mod.PublicGameData

    Datecreation()



    Mod.PublicGameData = Pub
end

function Datecreation()

	local short = Mod.Settings
    local total = 0


    for i = 1, #short.Monthdays do
    
        total = total + short.Monthdays[i]
    end

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
    pub.Date.abb = ""
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

end