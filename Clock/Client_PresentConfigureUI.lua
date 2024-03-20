
function Client_PresentConfigureUI(rootParent)
	HoursinDay = 24
	MinSec = 60
	Templates = 4


	local weekname = Mod.Settings.HWeeknames
	if weekname == nil then
		weekname = "Monday/Tuesday/Wednesday/Thursday/Friday/Saturday/Sunday"
	end
	local monthnames = Mod.Settings.HMonthnames
	if monthnames == nil then
		monthnames = "January/February/March/April/May/June/July/Augest/September/October/November/December"
	end	
	local monthdays = Mod.Settings.HMonthdays
	if monthdays == nil then
		monthdays = "31/28/31/30/31/30/31/31/30/31/30/31"
	end

	--Current Date
	local year = Mod.Settings.Year
	if year == nil then
		year = 1
	end
	local month = Mod.Settings.Month
	if month == nil then
		month = 1
	end
	local day = Mod.Settings.Day
	if day == nil then
		day = 1
	end
	local hour = Mod.Settings.Hour
	if hour == nil then
		hour = 1
	end
	local min = Mod.Settings.Minute
	if min == nil then
		min = 1
	end
	local second = Mod.Settings.Second
	if second == nil then
		second = 1
	end
	local after = Mod.Settings.After
	if after == nil then
		after = "C.E."
	end
	local before = Mod.Settings.Before
	if before == nil then
		before = "B.C.E."
	end
--incrementing by set amount each turned
local iyear = Mod.Settings.IYear
	if iyear == nil then
		iyear = 0
	end
	local imonth = Mod.Settings.IMonth
	if imonth == nil then
		imonth = 0
	end
	local iday = Mod.Settings.IDay
	if iday == nil then
		iday = 0
	end
	local ihour = Mod.Settings.IHour
	if ihour == nil then
		ihour = 0
	end
	local imin = Mod.Settings.IMinute
	if imin == nil then
		imin = 0
	end
	local isecond = Mod.Settings.ISecond
	if isecond == nil then
		isecond = 0
	end



	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row0 = UI.CreateHorizontalLayoutGroup(vert); -- adding the correct map
	

    local row1 = UI.CreateHorizontalLayoutGroup(vert) -- Years
	UI.CreateLabel(row1).SetText('Starting Year')
    yearfield = UI.CreateNumberInputField(row1)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(5)
		.SetValue(year)

	local row2 = UI.CreateHorizontalLayoutGroup(vert) -- Months
	UI.CreateLabel(row2).SetText('Starting Month')
	Monthfield = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(12)
		.SetValue(month)

	local row3 = UI.CreateHorizontalLayoutGroup(vert); -- Days
	UI.CreateLabel(row3).SetText('Starting Day in month')
	Dayfield = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(365)
		.SetValue(day)

	local row4 = UI.CreateHorizontalLayoutGroup(vert) -- hours
	UI.CreateLabel(row4).SetText('Starting Hour')
	Hourfield = UI.CreateNumberInputField(row4)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(HoursinDay)
		.SetValue(hour)

		local row5 = UI.CreateHorizontalLayoutGroup(vert) -- Mintue
	UI.CreateLabel(row5).SetText('Starting Mintue')
	Minfield = UI.CreateNumberInputField(row5)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(MinSec)
		.SetValue(min)

		local row6 = UI.CreateHorizontalLayoutGroup(vert) -- Second
	UI.CreateLabel(row6).SetText('Starting Second')
	Secfield = UI.CreateNumberInputField(row6)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(MinSec)
		.SetValue(second)

	-- incrementing Time --
		local row7 = UI.CreateHorizontalLayoutGroup(vert) -- Incrementing Year
	UI.CreateLabel(row7).SetText('Years per turn')
	IYearfield = UI.CreateNumberInputField(row7)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(5)
		.SetValue(iyear)

		local row8 = UI.CreateHorizontalLayoutGroup(vert) -- I Month
	UI.CreateLabel(row8).SetText('Months per turn')
	Imonthfield = UI.CreateNumberInputField(row8)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(12)
		.SetValue(imonth)

		local row9 = UI.CreateHorizontalLayoutGroup(vert) -- I Days
	UI.CreateLabel(row9).SetText('Days per turn')
	Idayfield = UI.CreateNumberInputField(row9)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(365)
		.SetValue(iday)

		local row10 = UI.CreateHorizontalLayoutGroup(vert) -- I Hours
	UI.CreateLabel(row10).SetText('Hours per turn')
	Ihourfield = UI.CreateNumberInputField(row10)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(HoursinDay)
		.SetValue(ihour)

		local row11 = UI.CreateHorizontalLayoutGroup(vert); -- I Minute
	UI.CreateLabel(row11).SetText('Mintues per turn')
	Iminfield = UI.CreateNumberInputField(row11)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(MinSec)
		.SetValue(imin)

		local row12 = UI.CreateHorizontalLayoutGroup(vert) -- I Seconds
	UI.CreateLabel(row12).SetText('Seconds per turn')
	Isecfield = UI.CreateNumberInputField(row12)
		.SetSliderMinValue(0)
		.SetSliderMaxValue(MinSec)
		.SetValue(isecond)

		--Text
----------------

		local row13 = UI.CreateHorizontalLayoutGroup(vert)
		UI.CreateButton(row13).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert('This will be your B.C/B.C.E. replacement. your Era tracker after 0 for your world') end)
		UI.CreateLabel(row13).SetText('Before 0 Abbreviations')
		beforefield = UI.CreateTextInputField(vert)
		.SetPlaceholderText("Before 0 Abbreviations").SetText(before)
		.SetFlexibleWidth(1)
		.SetCharacterLimit(10)

		local row14 = UI.CreateHorizontalLayoutGroup(vert)
		UI.CreateButton(row14).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert('This will be your A.D./C.E. replacement. your Era tracker after 0 for your world') end)
		UI.CreateLabel(row14).SetText('After 0 Abbreviations')
		afterfield = UI.CreateTextInputField(vert)
		.SetPlaceholderText("After 0 Abbreviations").SetText(after)
		.SetFlexibleWidth(1)
		.SetCharacterLimit(10)

		local row15 = UI.CreateHorizontalLayoutGroup(vert)
		UI.CreateButton(row15).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert('This will determine how many months are in the year\nUse "/" between Month names to give each month a Name. the amount of months are determine by how many names you give.') end)
		UI.CreateLabel(row15).SetText('Names of Months')
		monthnamefield = UI.CreateTextInputField(vert)
		.SetPlaceholderText("Names of Months").SetText(monthnames)
		.SetFlexibleWidth(1)
		.SetCharacterLimit(300)

		local row16 = UI.CreateHorizontalLayoutGroup(vert)
		UI.CreateButton(row16).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert('This will determine the days in each month and how many days are in the year by adding them up\nUse "/" between days to give each month a day. the amount of months are determine by Month names not by this metric') end);
		UI.CreateLabel(row16).SetText('Days in each month')
		monthdayfield = UI.CreateTextInputField(vert)
		.SetPlaceholderText("Days in each month").SetText(monthdays)
		.SetFlexibleWidth(1)
		.SetCharacterLimit(300)

		local row17 = UI.CreateHorizontalLayoutGroup(vert)
		UI.CreateButton(row17).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert('This will determine how many days are in a week\nUse "/" between week names to give each day of the week a Name. the amount of days in week are determine by how many names you give here') end)
		UI.CreateLabel(row17).SetText('Names of each day of the week')
		weeknamesfield = UI.CreateTextInputField(vert)
		.SetPlaceholderText("Names of each day of the week").SetText(weekname)
		.SetFlexibleWidth(1)
		.SetCharacterLimit(300)

end