require('Utilities')



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)

  publicdata = Mod.PublicGameData

  local type = Nonill(payload.entrytype)
  local data1 = payload.data1
  local data2 = payload.data2
  local data3 = payload.data3
  local data4 = payload.data4
  local data5 = payload.data5

  local typetext = Nonill(payload.text)
  if publicdata.CreatedActionID == nil then publicdata.CreatedActionID = {} end
  if publicdata.CreatedHostchangeID == nil then publicdata.CreatedHostchangeID = {} end
  if publicdata.Turn ==  nil then publicdata.Turn = game.Game.TurnNumber end
  if publicdata.History == nil then publicdata.History = {} end
  if publicdata.HostID == nil then publicdata.HostID = 0 end
    

  if type == 1 then -- Creating a new option from scrath  
    
    if publicdata.Action == nil then publicdata.Action = {} end
    if #publicdata.Action >= 5 then     

      setReturnTable({ Message = "Cannot have more then 5 actions at a time\nActions fall off after 3 turns"})
      return end
    if typetext ~= ActionTypeNames(7) then
    if data1 == data2 then setReturnTable({ Message = "Cannot pick the same player twice"})  return end end
    table.insert(publicdata.CreatedActionID,playerID) 
    

      if typetext == ActionTypeNames(3) or typetext == ActionTypeNames(4) or typetext == ActionTypeNames(6) or typetext == ActionTypeNames(9) -- condition continues
       or  typetext == ActionTypeNames(10) or typetext == ActionTypeNames(11) then data2 = "Neutral" end 

    if publicdata.Action[#publicdata.Action + 1] == nil then publicdata.Action[#publicdata.Action + 1] = {} end
      local short = publicdata.Action[#publicdata.Action]

      short.incomebump = data3
      short.Cutoff = data4
      if short.OrigPlayerID == nil then short.OrigPlayerID = data1 end
      if short.NewPlayerID == nil then short.NewPlayerID = data2 end


    if short.VotingIDs == nil then short.VotingIDs = {} end
    if short.TurnCreated == nil then short.TurnCreated = game.Game.TurnNumber end -- 3 turns then its deleted

    short.VotingIDs[#short.VotingIDs + 1] = playerID
    short.Actiontype = typetext
    short.Todelete = false
    short.turned = data3
    short.playerWhoCreated = playerID
    short.Bonus = data5
    short.Armycut = data4


  elseif type == 2 then -- Adding Vote
    table.insert(publicdata.Action[data1].VotingIDs,playerID)

  elseif type == 3 then -- removing vote
    table.remove(publicdata.Action[data1].VotingIDs,data2)
    if #publicdata.Action[data1].VotingIDs == 0 then
      table.remove(publicdata.Action,data1) -- remove the action if no one votes for it
    end


  elseif type == 4 then -- removing Action
    table.remove(publicdata.Action,data1)
  
  elseif type == 5 then -- creating Host change
    
  
    if publicdata.ChangeAction == nil then publicdata.ChangeAction = {} end
    if #publicdata.ChangeAction >= 3 then     

      setReturnTable({ Message = "Cannot have more then 3 Host Votes at a time\nHost votes fall off after 2 turns"})
      return end
      table.insert(publicdata.CreatedHostchangeID,playerID) 

    if publicdata.ChangeAction[#publicdata.ChangeAction+1] == nil then publicdata.ChangeAction[#publicdata.ChangeAction+1] = {}
      local short = publicdata.ChangeAction[#publicdata.ChangeAction]
      short.NewHostID = data1
      short.VotedPlayers = {}
      short.VotedPlayers[#short.VotedPlayers+1] = playerID
      short.TurnCreated = game.Game.TurnNumber
      short.Createdby = playerID

    end
  elseif type == 6 then -- Adding Vote for host
    table.insert(publicdata.ChangeAction[data1].VotedPlayers,playerID)

  elseif type == 7 then -- removing for host
    table.remove(publicdata.ChangeAction[data4].VotingIDs,data2)
    if #publicdata.ChangeAction[data4].VotingIDs == 0 then
      table.remove(publicdata.ChangeAction,data4) -- remove the action if no one votes for it
    end
  elseif type == 8 then -- removing action and updating action creation list
    local place = FindmatchID(publicdata.CreatedActionID, data2,1)
    table.remove(publicdata.CreatedActionID,place)
    table.remove(publicdata.Action,data1)
  end

    Mod.PublicGameData = publicdata
end