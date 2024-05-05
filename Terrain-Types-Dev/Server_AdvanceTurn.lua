require('Utilities')


function Server_AdvanceTurn_End(game, addNewOrder)


   -- print (Mod.Settings.maplist[1], Mod.Settings.maplist)

--game.Game.TurnNumber 

    if Mod.Settings.Landdata == nil then -- Old format (discontinued)

        local publicdata = Mod.PublicGameData
        if (publicdata.solidlist == nil)then publicdata.solidlist = {} end
        local Ww2maplist = {}
        local Ww2maplist = Mod.Settings.maplist
        local moddata = Mod.Settings.Modlist
        NeutralValue = Mod.Settings.Neutral

        for _,ts in pairs(publicdata.solidlist) do
                local land = game.ServerGame.LatestTurnStanding.Territories[ts]
                if land.OwnerPlayerID ~= 0 then
                    if (WhatmodAllowed(land, moddata,addNewOrder) == false )then
                        
                       local mod = WL.TerritoryModification.Create(ts)
                        mod.SetOwnerOpt  = 0
                        mod.SetArmiesTo = NeutralValue
                        local UnitdiedMessage = ''
                        addNewOrder(WL.GameOrderEvent.Create(0, 'Terrain type found. Changing', {}, {mod}));
                    end 
                end
        end
        Mod.PublicGameData = publicdata





    else -- New format
        Pub = Mod.PublicGameData
        local modtable = {}

        for i,v in pairs(Pub.Terrain)do

            if (v.values.turnstart ~= nil and game.Game.TurnNumber >= v.values.turnstart and game.Game.TurnNumber < v.values.turnend) or v.values.turnstart == 0 then

                local mod = WL.TerritoryModification.Create(i)
                --specil unit immune/remove
                local SUdata = {}
                SUdata = SUImmuneOrNot(game.ServerGame.LatestTurnStanding.Territories[i],v.values.ModControl,mod,v.values.BaseSettings)
                if SUdata.Immune_logic == false then
                    mod.RemoveSpecialUnitsOpt = SUdata.SU

                    --ownership change
                    if v.values.OwnerID ~= nil and v.values.OwnerID ~= game.ServerGame.LatestTurnStanding.Territories[i].OwnerPlayerID  then
                        mod.SetOwnerOpt = v.values.OwnerID
                    end

                    --army change
                    print("test 1")
                    if v.values.armyValueChange ~= -1 and v.values.armyValueChange ~= game.ServerGame.LatestTurnStanding.Territories[i].NumArmies.NumArmies then
                        mod.SetArmiesTo = v.values.armyValueChange
                    end

                    --remove buildings
                    if v.values.Removebuild == true then
                        local Cities = {}
                        Cities[WL.StructureType.City] = 0
                        Cities[WL.StructureType.MercenaryCamp] = 0
                        Cities[WL.StructureType.ArmyCamp] = 0

                        mod.SetStructuresOpt = Cities
                    end
                    table.insert(modtable,mod)
                end
            end
    
        end
        addNewOrder(WL.GameOrderEvent.Create(0, "Terrain types applied", {}, modtable))
            Mod.PublicGameData = Pub
    end
    




end

--Old Special unit finder
function WhatmodAllowed (land,modused,neworder)
local correctunit = false
local t = {}

    if (#land.NumArmies.SpecialUnits > 0 ) then
        for i,v in pairs (land.NumArmies.SpecialUnits)do 
            if v.proxyType == "CustomSpecialUnit" or modused == 0  then
                table.insert(t, v.ID);
                if v.ModData ~= nil  then
                    if startsWith(v.ModData, modused)then
                        correctunit = true
                    end
                
                elseif modused == 0 then 
                    correctunit = true
                end
            end
        end
        if correctunit == false then
            local mod = WL.TerritoryModification.Create(land.ID)
            mod.SetOwnerOpt  = 0
            mod.SetArmiesTo = NeutralValue
            local UnitdiedMessage = ''
            mod.RemoveSpecialUnitsOpt = t
            neworder(WL.GameOrderEvent.Create(0, 'Terrain type found. Changing', {}, {mod}))
        end 
    end


return correctunit
end

function SUImmuneOrNot (land,modused,mod,Basesetting,neworder)
    local t = {correctunit = false,SU = {},Immune_logic = false} 
    
        if (#land.NumArmies.SpecialUnits > 0 ) then -- looking for SU to determine logic
            for i,v in pairs (land.NumArmies.SpecialUnits)do 
                if v.proxyType == "CustomSpecialUnit" or modused == 0  then
                    table.insert(t.SU, v.ID)
                    if v.ModData ~= nil or modused == 0 then
                        if startsWith(v.ModData, modused)then
                            t.correctunit = true
                            
                        
                        elseif modused == 0 then 
                        t.correctunit = true
                        end
                    end
                end
            end
            if t.correctunit == true then

                if Basesetting == 1 or Basesetting == 4 then -- Immune logic
                        t.Immune_logic = true
                end
            end 
        end
    
    
    return t
    end