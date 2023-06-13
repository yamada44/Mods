



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)

   playerdata = Mod.PlayerGameData
    playerdata[playerID].readrules = true

    Mod.PlayerGameData = playerdata

    setReturnTable({});

end