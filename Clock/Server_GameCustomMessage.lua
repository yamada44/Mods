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

    Pub[playerID].template.Display[1].value = data1[1].value
    Pub[playerID].template.Display[1].text = data1[1].text
    Pub[playerID].template.Display[1].order = 1
    Pub[playerID].template.Display[2].value = data1[2].value
    Pub[playerID].template.Display[2].text = data1[2].text
    Pub[playerID].template.Display[2].order = 2
    Pub[playerID].template.Display[3].value = data1[3].value
    Pub[playerID].template.Display[3].text = data1[3].text
    Pub[playerID].template.Display[3].order = 3
    Pub[playerID].template.Display[4].value = data1[4].value
    Pub[playerID].template.Display[4].text = data1[4].text
    Pub[playerID].template.Display[4].order = 4
    Pub[playerID].template.Display[5].value = data1[5].value
    Pub[playerID].template.Display[5].text = data1[5].text
    Pub[playerID].template.Display[5].order = 5
    Pub[playerID].template.Display[6].value = data1[6].value
    Pub[playerID].template.Display[6].text = data1[6].text
    Pub[playerID].template.Display[6].order = 6
    Pub[playerID].template.Display[7].value = data1[7].value
    Pub[playerID].template.Display[7].text = data1[7].text
    Pub[playerID].template.Display[7].order = 7
    Pub[playerID].template.Display[8].value = data1[8].value
    Pub[playerID].template.Display[8].text = data1[8].text
    Pub[playerID].template.Display[8].order = 8


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