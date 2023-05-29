require('Utilities')


function Server_AdvanceTurn_Start(game, addNewOrder)

 local publicdata = Mod.PublicGameData


    if (publicdata.solidlist == nil)then publicdata.solidlist = {} end
    local Ww2maplist = {}
    local Ww2maplist = Mod.Settings.maplist
    local moddata = Mod.Settings.Modlist
    print (Mod.Settings.maplist[1], Mod.Settings.maplist)



    if game.Game.TurnNumber == 1 then
        for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do -- first grab of territories
            for _,list in pairs(Ww2maplist) do -- looping through map name list

                if startsWith(game.Map.Territories[ts.ID].Name, list)then -- making sure the territory has a name from map name list
                    if (#ts.NumArmies.SpecialUnits == 0 )then -- mkaing sure it has special units
                        table.insert(publicdata.solidlist, ts.ID); 
                       local mod = WL.TerritoryModification.Create(ts.ID)
                        mod.SetOwnerOpt  = 0
                        mod.SetArmiesTo = 0	
                        local UnitdiedMessage = ''

                        addNewOrder(WL.GameOrderEvent.Create(0, 'Terrain type found. Changing', {}, {mod}));
                    end
                end
            end
            
        end

    else
        for _,ts in pairs(publicdata.solidlist) do
                local land = game.ServerGame.LatestTurnStanding.Territories[ts]
                if land.OwnerPlayerID ~= 0 then
                    if (WhatmodAllowed(land, moddata,addNewOrder) == false )then
                        
                       local mod = WL.TerritoryModification.Create(ts)
                        mod.SetOwnerOpt  = 0
                        mod.SetArmiesTo = 0	
                        local UnitdiedMessage = ''

                        addNewOrder(WL.GameOrderEvent.Create(0, 'Terrain type found. Changing', {}, {mod}));
                    end 
                end
        end
    end



Mod.PublicGameData = publicdata
end


function WhatmodAllowed (land,modused,neworder)
local correctunit = false
local t = {}

    if (#land.NumArmies.SpecialUnits > 0 ) then
        for i,v in pairs (land.NumArmies.SpecialUnits)do 
            if v.proxyType == "CustomSpecialUnit" then
                table.insert(t, v.ID);
                if v.ModData ~= nil or modused == 0  then -- 
                    if startsWith(v.ModData, modused) or modused == 0 then
                        correctunit = true
                    end
                end
            end
        end
        if correctunit == false then
            local mod = WL.TerritoryModification.Create(land.ID)
            mod.SetOwnerOpt  = 0
            mod.SetArmiesTo = 0	
            local UnitdiedMessage = ''
            mod.RemoveSpecialUnitsOpt = t
            neworder(WL.GameOrderEvent.Create(0, 'Terrain type found. Changing', {}, {mod}));
        end 
    end


return correctunit
end