



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)
local type = payload.type
  local publicdata = Mod.PublicGameData
  if publicdata[type] == nil then publicdata[type] = {} end
  if publicdata[type][playerID] == nil then publicdata[type][playerID] = {} end 
  publicdata[type][playerID].readrules = true

    Mod.PublicGameData = publicdata

    setReturnTable({});

end