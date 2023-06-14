



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)
local type = payload.type
  local playerdata = Mod.PlayerGameData
    playerdata[playerID] = {type = {readrules = true}}

    Mod.PlayerGameData = playerdata

    setReturnTable({});

end