require('Utilities')


function Server_AdvanceTurn_End(game, addNewOrder)
    local publicdata = Mod.PublicGameData
    local playergroup = {}
    local goldhave
    local MaxGold = 20
    for playerID, player in pairs(game.Game.PlayingPlayers) do
        if (not player.IsAIOrHumanTurnedIntoAI) then 
            if playergroup[playerID] == nil then playergroup[playerID] = {} end
          --  player.Income(0, standing GameStanding, true, true) 
            goldhave = game.ServerGame.LatestTurnStanding.NumResources(playerID, WL.ResourceType.Gold)
           if goldhave <= MaxGold then
            game.ServerGame.SetPlayerResource(playerID, WL.ResourceType.Gold, goldhave - typecost)
           end
        end
    end
    for playerID, player in pairs(game.Game.PlayingPlayers) do 
        if playergroup[playerID].GoldperTurn >
    end
  --game.Settings.CustomScenario.SlotsAvailable
        

Mod.PublicGameData = publicdata
end

