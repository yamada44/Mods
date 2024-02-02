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

  local cardinhand = game.ServerGame.LatestTurnStanding.Cards[1].WholeCards
  for i,v in pairs (cardinhand)do
    print(" i -- ".. i,"\n V -- " .. v.CardID)

    addNewOrder(WL.GameOrderDiscard.Create(1, v.ID) )

  end
  
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

