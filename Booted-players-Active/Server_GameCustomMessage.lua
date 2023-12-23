require('Utilities')



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)
  publicdata = Mod.PublicGameData

  local type = Nonill(payload.entrytype)
  local data1 = payload.data1
  local data2 = payload.data2
  local data3 = payload.data3

  local typetext = Nonill(payload.text)
  if publicdata.CreatedActionID == nil then publicdata.CreatedActionID = {} end
  if publicdata.Turn ==  nil then publicdata.Turn = game.Game.TurnNumber end
    
    if publicdata.Turn ~= game.Game.TurnNumber then
    publicdata.CreatedActionID = {}
    publicdata.Turn = game.Game.TurnNumber
  end  



  if type == 1 then -- Creating a new option from scrath  
    
    if publicdata.Action == nil then publicdata.Action = {} end
    if #publicdata.Action >= 5 then     

      setReturnTable({ Message = "Cannot have more then 5 actions at a time\nActions fall off after 3 turns"})
      return end
    if data1 == data2 then setReturnTable({ Message = "Cannot pick the same player twice"})  return end
    table.insert(publicdata.CreatedActionID,playerID)
    

      if typetext == ActionTypeNames(3) or typetext == ActionTypeNames(4) or typetext == ActionTypeNames(6) then data2 = "Neutral" end 
print(data2,"data2")
    if publicdata.Action[#publicdata.Action + 1] == nil then publicdata.Action[#publicdata.Action + 1] = {} end
      local short = publicdata.Action[#publicdata.Action]
    if short.OrigPlayerID == nil then short.OrigPlayerID = data1 end
    if short.NewPlayerID == nil then short.NewPlayerID = data2 end
    if short.VotingIDs == nil then short.VotingIDs = {} end
    if short.TurnCreated == nil then short.TurnCreated = game.Game.TurnNumber end -- 3 turns then its deleted

    short.VotingIDs[#short.VotingIDs + 1] = playerID
    short.Actiontype = typetext
    short.Todelete = false
    short.turned = data3
    short.playerWhoCreated = playerID


  elseif type == 2 then -- Adding Vote
    table.insert(publicdata.Action[data1].VotingIDs,playerID)
  elseif type == 3 then -- removing
    table.remove(publicdata.Action[data1].VotingIDs,data2)
    if #publicdata.Action[data1].VotingIDs == 0 then
      table.remove(publicdata.Action,data1) -- remove the action if no one votes for it
    end
  elseif type == 4 then -- removing Action
    table.remove(publicdata.Action,data1)

  end
  

    Mod.PublicGameData = publicdata
end