require('Utilities')

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	publicdata = Mod.PublicGameData

	Game = game;
	Close = close;
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateVerticalLayoutGroup(row3)
	short = Mod.PublicGameData
	local Time = Mod.PublicGameData.Date
	ViewValues = {}
	ID = game.Us.ID

	
	setMaxSize(400, 400)
	if (game.Us == nil or game.Us.State ~= WL.GamePlayerState.Playing) then
		UI.CreateLabel(vert).SetText("You cannot Vote since you're not in the game")
		return
	end
	--Time = {y = short.Year,m=short.Month,d=short.Day,mm=short.Mintue,s=short.Second}
	
	--print (Time.y.."/"..short.Monthnames[Time.m] .. ": ".. Time.m.."/"..Time.d.."--"..Time.mm..":"..Time.s)
	local year = Time.year
	local Abb = short.After
	if year < 0 then year = year * -1 Abb = short.Before end

	local totaldays = Finddayofweek(short.Daysinmonths,Time.month,Time.day)
	local nameindex = Calculateweek(totaldays,short.NumberofWeekdays)
	UI.CreateLabel(row1).SetText("Year " .. year.. " " .. Abb.. "\nMonth name "..short.NameofMonths[Time.month] .. "\nMonth ".. Time.month.."\nDay name ".. short.Daysofweek[nameindex] .. "\nDays "..Time.day .."\nHour ".. Time.hour .. "\nMintue "..Time.mintue.."\nsecond "..Time.second)
	UI.CreateEmpty(row2)
	UI.CreateButton(row4).SetText("Settings").SetOnClick(function () Dialogwindow(1,close,"") end) -- Settings option

end
function Dialogwindow(window, close, data) -- middle function to open up new windows
	publicdata = Mod.PublicGameData


	if window == 1 then --buying an agency
		close()
		Game.CreateDialog(Settingoptions) 
	elseif window == 2 then
		close()
		Game.CreateDialog(Viewing) 
	elseif window == 3 then
		close()
		Game.CreateDialog(History) 
	elseif window == 4 then
		close()
		Game.CreateDialog(Template) 
	end
	
end
function Settingoptions(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(400, 300)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)

	UI.CreateButton(vert).SetText("Template Style").SetOnClick(function () Dialogwindow(4,close,"") end) -- Templates
	UI.CreateButton(vert).SetText("Viewing options").SetOnClick(function () Dialogwindow(2,close,"") end) -- Viewing
	UI.CreateButton(vert).SetText("History").SetOnClick(function () Dialogwindow(3,close,"") end) -- History



end
function Viewing(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(400, 500)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local Temp = short.template
	UI.CreateLabel(row1).SetText("Viewing options for main menu")


	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.year).SetText('Years')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.month).SetText('Months')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.day).SetText('Days')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.hour).SetText('Hours')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.mintue).SetText('Mintues')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.second).SetText('Seconds')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.abb).SetText('Abbreviation')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.monthday).SetText('Month Names')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.DayName).SetText('Week Day Names')


	UI.CreateButton(vert).SetText("Submit Changes").SetOnClick(function () Serverload(1,ViewValues,close) end) -- Settings option

end
function History(rootParent, setMaxSize, setScrollable, game, close)
		setMaxSize(720, 400)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local SortedAgency = SortTable(short.History, "turn")

	print(#SortedAgency,"history")
	local vert2 = UI.CreateVerticalLayoutGroup(rootParent)


	local tpyename = {"year","month","day","hour","mintue","second","monthname","DayName","turn"} --accesses the field
	local Namegroups = {UI.CreateHorizontalLayoutGroup(vert2)}
	table.insert(Namegroups, UI.CreateHorizontalLayoutGroup(Namegroups[#Namegroups]))
	table.insert(Namegroups, UI.CreateHorizontalLayoutGroup(Namegroups[#Namegroups]))
	table.insert(Namegroups, UI.CreateHorizontalLayoutGroup(Namegroups[#Namegroups]))
	table.insert(Namegroups, UI.CreateHorizontalLayoutGroup(Namegroups[#Namegroups]))
	table.insert(Namegroups, UI.CreateHorizontalLayoutGroup(Namegroups[#Namegroups]))
	table.insert(Namegroups, UI.CreateHorizontalLayoutGroup(Namegroups[#Namegroups]))
	table.insert(Namegroups, UI.CreateHorizontalLayoutGroup(Namegroups[#Namegroups]))
	table.insert(Namegroups, UI.CreateHorizontalLayoutGroup(Namegroups[#Namegroups]))
	table.insert(Namegroups, UI.CreateHorizontalLayoutGroup(Namegroups[#Namegroups]))

	local Rowtable = {}
	table.insert(Rowtable, UI.CreateVerticalLayoutGroup(Namegroups[9]))
	table.insert(Rowtable, UI.CreateVerticalLayoutGroup(Namegroups[8]))
	table.insert(Rowtable, UI.CreateVerticalLayoutGroup(Namegroups[7]))
	table.insert(Rowtable, UI.CreateVerticalLayoutGroup(Namegroups[6]))
	table.insert(Rowtable, UI.CreateVerticalLayoutGroup(Namegroups[5]))
	table.insert(Rowtable, UI.CreateVerticalLayoutGroup(Namegroups[4]))
	table.insert(Rowtable, UI.CreateVerticalLayoutGroup(Namegroups[3]))
	table.insert(Rowtable, UI.CreateVerticalLayoutGroup(Namegroups[2]))
	table.insert(Rowtable, UI.CreateVerticalLayoutGroup(Namegroups[1]))
	--UI.CreateLabel(row11).SetText("\n\n")
	UI.CreateLabel(Rowtable[1]).SetText("Year").SetColor("#FF697A")
	UI.CreateLabel(Rowtable[2]).SetText("Month").SetColor("#FF697A")
	UI.CreateLabel(Rowtable[3]).SetText("Day").SetColor("#FF697A")
	UI.CreateLabel(Rowtable[4]).SetText("Hour").SetColor("#FF697A")
	UI.CreateLabel(Rowtable[5]).SetText("Minute").SetColor("#FF697A")
	UI.CreateLabel(Rowtable[6]).SetText("Second").SetColor("#FF697A")
	UI.CreateLabel(Rowtable[7]).SetText("Month name").SetColor("#FF697A")
	UI.CreateLabel(Rowtable[8]).SetText("Week Day").SetColor("#FF697A")
	UI.CreateLabel(Rowtable[9]).SetText("Turn").SetColor("#FF697A")


	local color = "#BABABC"
	for i = 1, #SortedAgency do 
		for i2 = 1, #tpyename do 
		local row1 = UI.CreateVerticalLayoutGroup(Rowtable[i2])
		local spacerText = ""
		local spacerCore = SortedAgency[i][tpyename[i2]]
		--local color = 
		if i2 == 1 then spacerText = " " ..  short.History[i].abb end
		
			UI.CreateLabel(row1).SetText(spacerCore .. spacerText).SetColor(color)

		end
	if color == "#BABABC" then color = "#FFFFFF" else color =  "#BABABC" end
	end

end




function Template(rootParent, setMaxSize, setScrollable, game, close)
		setMaxSize(450, 400)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)


end
function Serverload(type,data1,close)
	if close ~= nil then
		close()
	end
	local viewdata = 0

	if type == 1 then
		viewdata = {}
		for i = 1, #data1 do

			viewdata[data1[i].GetText()] = data1[i].GetIsChecked()

		end
	end

	local payload = {}
		payload.entrytype = type
		payload.data1 = viewdata
		

		Game.SendGameCustomMessage("ClockMod" .. "...", payload, function(returnValue)
			if returnValue.Message ~= nil then 
				UI.Alert(returnValue.Message)
			end
		

		end)	
end
