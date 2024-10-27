function Server_GameCustomMessage(game, playerID, payload, setReturnTable)
local type = payload.type
local publicdata = Mod.PublicGameData
if publicdata.Access == nil then publicdata.Access = false end
publicdata.Access = false

if type > 0 then 
  if publicdata[type] == nil then publicdata[type] = {} end
  if publicdata[type][playerID] == nil then publicdata[type][playerID] = {} end 
  publicdata[type][playerID].readrules = true
elseif type == 0 then -- upkeep access loop

  local totalupkeep = {}
  for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do
    for i,v in pairs (ts.NumArmies.SpecialUnits)do -- search all Territories and see if it has a speical unit
      if v.proxyType == "CustomSpecialUnit" then
        if v.ModData ~= nil then -- 
          if startsWith(v.ModData, modSign(0)) then -- make sure the speical unit is only from I.S. mods
            local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
            local upkeep = tonumber(payloadSplit[11]) or 0
            if upkeep > 0 then -- check to see if it has upkeep functions
              if totalupkeep[ts.OwnerPlayerID] == nil then totalupkeep[ts.OwnerPlayerID] = 0 end
              totalupkeep[ts.OwnerPlayerID] = totalupkeep[ts.OwnerPlayerID] + upkeep 
            end
            
            
          end
        end
      end
    end
  end

  -- upkeep gold update loop
  for upkeepID, upkeep in pairs(totalupkeep) do
    local goldHave = game.ServerGame.LatestTurnStanding.NumResources(upkeepID, WL.ResourceType.Gold)
    local newgold = goldHave - upkeep
    if upkeep >= goldHave then newgold = 0 end -- making sure upkeep does not surpass current gold
    game.ServerGame.SetPlayerResource(upkeepID, WL.ResourceType.Gold, newgold)
  end

end
  Mod.PublicGameData = publicdata
  setReturnTable({});
end
