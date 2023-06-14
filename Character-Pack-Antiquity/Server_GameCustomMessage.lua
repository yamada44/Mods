



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)
local type = payload.type
  local playerdata = Mod.PlayerGameData
    if playerdata[playerID][type] == nil then playerdata[playerID][type] = {} end
      playerdata[playerID][type] = {readrules = true}

    Mod.PlayerGameData = playerdata

    setReturnTable({});

end