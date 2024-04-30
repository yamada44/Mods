require('Utilities')

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)

	Game = game;
	Close = close;
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateVerticalLayoutGroup(row3)
	ID = game.Us.ID
	short = Mod.PublicGameData
	ViewValues = {}


	

	if (game.Us == nil or game.Us.State ~= WL.GamePlayerState.Playing) then
		UI.CreateLabel(vert).SetText("You cannot Vote since you're not in the game")
		return
	end

	print(short)
	print(short.Date,"date")
--	local totaldays = Finddayofweek(short.Daysinmonths,Time.month,Time.day)
--	local nameindex = Calculateweek(totaldays,short.NumberofWeekdays)
	ShowLayout(vert,rootParent,setMaxSize)

	UI.CreateEmpty(row2) 
	UI.CreateButton(row4).SetText("Settings").SetOnClick(function () Dialogwindow(1,close,"") end).SetColor("#1274A4") -- Settings option




end
function Dialogwindow(window, close, data) -- middle function to open up new windows
	publicdata = Mod.PublicGameData


	if window == 1 then --buying an agency
		close()
		Game.CreateDialog(Settingoptions) 
	elseif window == 2 then

		Game.CreateDialog(Viewing) 
	elseif window == 3 then

		Game.CreateDialog(History) 
	elseif window == 4 then
		
		Game.CreateDialog(Layout) 
	end
	
end
function ShowLayout(vert2,rootParent,setMaxSize)


	local year = short.Date.year
	local Abb = short.After
	if year < 0 then year = year * -1 Abb = short.Before end
	
	local ViewableTable = oldtableNewformat(short[ID].template.Display,"value",false)
	local ViewableTable2 = oldtableNewformat(short[ID].template.Display,"text",false)
	local ViewableTable3 = oldtableNewformat(short[ID].template.Display,"",true)
for i,v in pairs(short[ID].template.Display.text)do
	print(i,v,"messed up test")
end

	local tpyename = ViewableTable --accesses the field
	if #tpyename <= 3 then setMaxSize(680-350, 400) else setMaxSize(720, 400) end
	local Namegroups = {UI.CreateHorizontalLayoutGroup(vert2)}
	--First layout group
	for i = 1, #tpyename do
	table.insert(Namegroups, UI.CreateHorizontalLayoutGroup(Namegroups[#Namegroups]))
	end
--Second layout group
	local reverse = #tpyename
	local Rowtable = {}
	for i = 1, #tpyename do
		print(reverse)
		table.insert(Rowtable, UI.CreateVerticalLayoutGroup(Namegroups[reverse]))

		reverse = reverse - 1
	end
--Third layout group
	for i = 1, #tpyename do
	UI.CreateLabel(Rowtable[i]).SetText(ViewableTable2[i]).SetColor("#FF697A")
	end


	local color = "#BABABC"
	for i = 1, 1 do 
		for i2 = 1, #tpyename do 
		local row1 = UI.CreateVerticalLayoutGroup(Rowtable[i2])
		local spacerText = ""
		local spacerCore = short.History[#short.History][ViewableTable3[i2].value]
		--local color = 

		if ViewableTable3[i2].value == "year" and spacerCore < 0 then spacerCore = spacerCore * -1 end
		if short[ID].template.abb == true and ViewableTable3[i2].value == "year" then spacerText = " " ..  short.History[#short.History].abb end
		print(tpyename[i2],spacerCore,#ViewableTable3)
			UI.CreateLabel(row1).SetText(spacerCore .. spacerText).SetColor(color)

		end
	end

end
function Settingoptions(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(400, 300)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)

	Choose = UI.CreateButton(row1).SetText("Create New Template").SetOnClick(function ()Dialogwindow(4,close,"")end).SetInteractable(true) -- Settings option
	UI.CreateButton(vert).SetText("Viewing options").SetOnClick(function () Dialogwindow(2,close,"") end) -- Viewing
	UI.CreateButton(vert).SetText("History").SetOnClick(function () Dialogwindow(3,close,"") end) -- History



end
function Viewing(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(400, 500)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local Temp = short[ID].template
	UI.CreateLabel(row1).SetText("Viewing options for main menu")


	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.year).SetText('Years')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.month).SetText('Months')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.day).SetText('Days')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.hour).SetText('Hours')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.mintue).SetText('Minutes')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.second).SetText('Seconds')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.abb).SetText('Abbreviation')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.monthname).SetText('Month Names')
	ViewValues[#ViewValues+1] = UI.CreateCheckBox(vert).SetIsChecked(Temp.DayName).SetText('Week Day Names')


	UI.CreateButton(vert).SetText("Submit Changes").SetOnClick(function () Serverload(1,ViewValues,close) end).SetColor("#1274A4") -- Settings option

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
		if i2 == 1 then spacerText = " " ..  SortedAgency[i].abb end
		
			UI.CreateLabel(row1).SetText(spacerCore .. spacerText).SetColor(color)

		end
	if color == "#BABABC" then color = "#FFFFFF" else color =  "#BABABC" end
	end

end

function Serverload(type,data1,close)
	if close ~= nil then
		close()
	end
	local viewdata = data1

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

--Prompted list for Order
function TargetOrderClicked(order)
	--close()
	OrderRank = order

	local options = map(ViewingOptions(0), Ordersetup)
	UI.PromptFromList("Select the Order Element you'd like to have", options)
end
function Ordersetup(view)

	local name = view
	local ret = {}
	ret["text"] = name
	ret["selected"] = function() 
		print(view,"tell",OrderRank)
		if view == ViewingOptions(1)then
			OrderList[OrderRank].value = "year"
			OrderList[OrderRank].text = ViewingOptions(1)
		elseif view == ViewingOptions(2) then	
			OrderList[OrderRank].value = "month"
			OrderList[OrderRank].text = ViewingOptions(2)
		elseif view == ViewingOptions(3) then
			OrderList[OrderRank].value = "day"
			OrderList[OrderRank].text = ViewingOptions(3)
		elseif view == ViewingOptions(4) then
			OrderList[OrderRank].value = "hour"	
			OrderList[OrderRank].text = ViewingOptions(4)
		elseif view == ViewingOptions(5) then
			OrderList[OrderRank].value = "mintue"	
			OrderList[OrderRank].text = ViewingOptions(5)
		elseif view == ViewingOptions(6) then
			OrderList[OrderRank].value = "second"	
			OrderList[OrderRank].text = ViewingOptions(6)
		elseif view == ViewingOptions(7) then
			OrderList[OrderRank].value = "monthname"
			OrderList[OrderRank].text = ViewingOptions(7)	
		elseif view == ViewingOptions(8) then
			OrderList[OrderRank].value = "DayName"	
			OrderList[OrderRank].text = ViewingOptions(8)		
		elseif view == ViewingOptions(9) then
			OrderList[OrderRank].value = nil
			OrderList[OrderRank].text = ViewingOptions(9)	
		end	
		orderelement[OrderRank].SetColor("#00755E")
		orderelement[OrderRank].SetText(name)
	end

	return ret
end
function Layout(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(300, 450)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)

	UI.CreateLabel(row1).SetText("Choose the layout/order in which your calender will display")
	
	OrderList = {{},{},{},{},{},{},{},{}}
	orderelement = {}
	for i = 1, 8 do
		orderelement[i] = UI.CreateButton(vert).SetText("Select").SetOnClick(function () TargetOrderClicked(i) end) -- Order Ranking

	end
	UI.CreateButton(vert).SetText("Submit").SetOnClick(function () Serverload(2,OrderList,close) end).SetColor("#1274A4") -- Order Ranking
end

function oldtableNewformat(Otable,Get,sortOn)
	local Ntable = {}
	for i,v in pairs (Otable)do 
		if v.value ~= nil then
			if v.see == true and sortOn == false then
				table.insert(Ntable,v[Get])
			elseif v.see == true then 
				table.insert(Ntable,v)
			end
		end
	end

	return Ntable
end