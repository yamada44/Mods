



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)

  local playerdata = Mod.PlayerGameData
    playerdata[playerID] = {readrules = true}

    Mod.PlayerGameData = playerdata

    setReturnTable({});

end