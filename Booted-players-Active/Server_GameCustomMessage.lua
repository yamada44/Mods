require('Utilities')



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)
  publicdata = Mod.PublicGameData

  local type = Nonill(payload.entrytype)
  local data1 = payload.data1
  local data2 = payload.data2

  local typetext = Nonill(payload.text)


  if type == 1 then -- Creating a new option from scrath  
    if publicdata.Action == nil then publicdata.Action = {} end
    if publicdata.Action[#publicdata.Action + 1] == nil then publicdata.Action[#publicdata.Action + 1] = {} end
      local short = publicdata.Action[#publicdata.Action]
    if short.OrigPlayerID == nil then short.OrigPlayerID = data1 end
    if short.NewPlayerID == nil then short.NewPlayerID = data2 end
    if short.VotingIDs == nil then short.VotingIDs = {} end
    if short.TurnCreated == nil then short.TurnCreated = game.Game.TurnNumber end -- 5 turns then its deleted

    short.VotingIDs[#short.VotingIDs + 1] = playerID
    short.Actiontype = typetext


  elseif type == 2 then -- Adding Vote
  
  end
  
    Mod.PublicGameData = publicdata

end