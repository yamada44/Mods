require('Utilities')



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)

  Pub = Mod.PublicGameData
print(playerID)
  local type = payload.entrytype
  local data1 = payload.data1
	for i,v in pairs(data1)do
		print(i,v.text,"test 2")
	end
  for i,v in pairs(Pub[playerID].template.Display)do
		print(i,v.text,"test 3")
	end
  if type == 1 then --changing what is viewed


    Pub[playerID].template.year = data1["Years"]
    Pub[playerID].template.month = data1["Months"]
    Pub[playerID].template.day = data1["Days"]
    Pub[playerID].template.hour = data1["Hours"]
    Pub[playerID].template.mintue = data1["Minutes"]
    Pub[playerID].template.second = data1["Seconds"]
    Pub[playerID].template.abb = data1["Abbreviation"]
    Pub[playerID].template.monthname = data1["Month Names"]
    Pub[playerID].template.DayName = data1["Week Day Names"]


  elseif type == 2 then --changing viewing order

    for i = 1, #Pub[playerID].template.Display do
    
      Pub[playerID].template.Display[i].value = data1[i].value
      Pub[playerID].template.Display[i].text = data1[i].text
      Pub[playerID].template.Display[i].order = #Pub[playerID].template.Display - (i - 1)

    end

  end

  for Bi = 1, #Pub[playerID].template.Display do   
    for i,v in pairs (Pub[playerID].template) do
      if Pub[playerID].template.Display[Bi].value == i then
        Pub[playerID].template.Display[Bi].see = v
        break
      end

    end
  end
  for i,v in pairs(Pub[playerID].template.Display)do
		print(i,v.text,"test 4")
	end

  Mod.PublicGameData = Pub
end