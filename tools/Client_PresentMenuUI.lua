require('Utilities')

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	publicdata = Mod.PublicGameData

	Game = game;
	Close = close;
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local short = Mod.PublicGameData
	local Time = Mod.PublicGameData.Date
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
	print(nameindex,#short.Daysofweek)
	UI.CreateLabel(vert).SetText("Year " .. year.. " " .. Abb.. "\nMonth name "..short.NameofMonths[Time.month] .. "\nMonth ".. Time.month.."\nDay name ".. short.Daysofweek[nameindex] .. "\nDays "..Time.day .."\nHour ".. Time.hour .. "\nMintue "..Time.mintue.."\nsecond "..Time.second)



end

function Serverload(type, text,data1, data2,close)
	if close ~= nil then
		close()
	end

	local payload = {}
	Pass = nil

		payload.entrytype = type
		payload.text = text
		payload.data1 = Nonill(data1)
		payload.data2 = Nonill(data2)
		payload.data3 = 100
		if TurnedBtn ~= nil then
		local data3 = TurnedBtn.GetValue()
		if data3 > 100 or data3 < 5 then data3 = 100 end
		payload.data3 = data3
		end

		Game.SendGameCustomMessage("new " .. "playerControl" .. "...", payload, function(returnValue)
			publicdata = Mod.PublicGameData
			if returnValue.Message ~= nil then 
				UI.Alert(returnValue.Message)
			end
		

		end)	
end
