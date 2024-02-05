require('Utilities')

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
		
--[[
  if order.proxyType == "GameOrderAttackTransfer" then 
    --for _,terr in pairs (game.Map.Territories)do
      terr = game.Map.Territories[1]
      print(terr.ConnectedTo)
      for i,v in pairs (terr.ConnectedTo)do
        print(game.Map.Territories[game.Map.Territories[i].ID].Name)
      --PlayerID
      end
   -- end

   
  end]]



end
function Server_AdvanceTurn_End(game, addNewOrder)
  local Time = Mod.PublicGameData.Date
  local TP = Mod.PublicGameData.TimePassing
  local pub = Mod.PublicGameData

  --second
    Time = ProcessTime("second","second",pub.baseMin,"mintue",Time,TP)
  --Mintue
    Time = ProcessTime("mintue","mintue",pub.baseMin,"hour",Time,TP)
  --hour
    Time = ProcessTime("hour","hour",pub.Basehour,"day",Time,TP)
  --day

    Time = ProcessTimeCalender("day","day",pub.Daysinmonths ,"month",Time,TP)

  --Month
    Time = ProcessTime("month","month",pub.NumberofMonths,"year",Time,TP)
  --Year
    Time.year = Time.year + TP.year

    Time.abb = pub.After
    if Time.year < 0 then Time.abb = pub.Before end
    --finding weekname
    local totaldays = Finddayofweek(pub.Daysinmonths,Time.month,Time.day)
    local nameindex = Calculateweek(totaldays,pub.NumberofWeekdays)
    Time.DayName = pub.Daysofweek[nameindex]
    table.insert(pub.History,{})
    pub.History = Addhistroy(pub.History[#pub.History],Time,game.Game.TurnNumber)
   


  pub.Date = Time
  Mod.PublicGameData = pub
  
  --[[
    local publicdata = Mod.PublicGameData
    --local playergroup = {}
    local goldhave
    local MaxGold = 19
    local added = 100
    local standing = game.ServerGame.LatestTurnStanding
    for playerID, player in pairs(game.Game.PlayingPlayers) do
        if (not player.IsAIOrHumanTurnedIntoAI) then 
           -- if playergroup[playerID] == nil then playergroup[playerID] = {} end
            local income = player.Income(0, standing, true, true) 
            goldhave = game.ServerGame.LatestTurnStanding.NumResources(playerID, WL.ResourceType.Gold)
           if income.Total <= MaxGold then
            local incomeMod = WL.IncomeMod.Create(playerID, added, 'Income for being weak')
            addNewOrder(WL.GameOrderEvent.Create(playerID, "Added income " , nil, {},nil,{incomeMod}));
            --game.ServerGame.SetPlayerResource(playerID, WL.ResourceType.Gold, goldhave + 100)
            --
           end
        end
    end



  --game.Settings.CustomScenario.SlotsAvailable
        

Mod.PublicGameData = publicdata]]
end

function ProcessTime(Ctime,InTime,base,overload,Time,TP)
print(Time[Ctime])
  if Time[Ctime] + TP[InTime] >= base then
    local Timehold = Time[Ctime] + TP[InTime]
      print(Timehold)
    local group = math.floor(Timehold / base)
    print(group)
    local remainder = Timehold - (group*base)
    print(remainder)
    Time[overload] = Time[overload] + group
    Time[Ctime] = remainder
  else 
  Time[Ctime] = Time[Ctime] + TP[InTime]
  end
  print(Time[Ctime],Ctime)
  if Time[Ctime] == 0 then Time[Ctime] = 1 end

  return Time
end

function ProcessTimeCalender(Ctime,InTime,basetable,overload,Time,TP)
  local newtable = {}
    if Time[Ctime] + TP[InTime] >= basetable[Time.month] then

      newtable = AddingMonthVAlues(basetable,Time[Ctime],TP[InTime],Time.month)

      Time[overload] = Time[overload] + newtable.Group
      Time[Ctime] = newtable.Current
    else 
    Time[Ctime] = Time[Ctime] + TP[InTime]
    end
    print(Time[Ctime])
    if Time[Ctime] == 0 then Time[Ctime] = 1 end
    return Time
  end

  function AddingMonthVAlues(Daystable,Cday,Idays,Month)
    local group = 0

    while Idays > 0 do
      for i = Month, #Daystable do

        if Cday + Idays > Daystable[i] then

          Idays = Idays - (Daystable[i] - Cday)
          group = group + 1
          Cday = 0
        elseif Cday + Idays < Daystable[i] then 
          Cday = Cday + Idays
          Idays = 0
        end 
      end
      Month = 1
    end
    
    local table = {Group = group, Current = Cday}

    return table
  end