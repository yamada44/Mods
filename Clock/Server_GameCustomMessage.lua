require('Utilities')



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)

  pub = Mod.PublicGameData

  local type = payload.entrytype
  local data1 = payload.data1

  if type == 1 then
    local temp = pub.template

    temp.year = data1["Years"]
    temp.month = data1["Months"]
    temp.day = data1["Days"]
    temp.hour = data1["Hours"]
    temp.mintue = data1["Mintues"]
    temp.second = data1["Seconds"]
    temp.abb = data1["Abbreviation"]
    temp.monthday = data1["'Month Names"]
    temp.DayName = data1["Week Day Names"]

  end

  

  Mod.PublicGameData = pub
end