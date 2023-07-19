function Server_StartGame (game,standing)
    local unitdata = {}

     unitdata = Mod.Settings.Unitdata
     local typeamount = Mod.Settings.BeforeMax
if false then
     -- loop through all territories, find value and add special unit type
     for i=1, typeamount do
        for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do
            if ts.NumArmies.NumArmies == unitdata[i].Autovalue then
            --   standing.NumArmies.NumArmies = 9999 
            end
        end
    end
end
end