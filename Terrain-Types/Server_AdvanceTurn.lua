require('Utilities')

function Server_AdvanceTurn_Start(game, addNewOrder)
    Pub = Mod.PublicGameData				
	Game1 = game


end

function Server_AdvanceTurn_End(game, addNewOrder)
    Pub = Mod.PublicGameData

   -- print (Mod.Settings.maplist[1], Mod.Settings.maplist)

--game.Game.TurnNumber 

    if Pub.Terrain == nil then -- Old format (discontinued)

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

        local modtable = {}


        for i,v2 in pairs(Pub.Terrain)do

            
            local v = Pub.Type[v2.Type]

            if v ~= nil and ((game.Game.TurnNumber >= v.turnstart and game.Game.TurnNumber < v.turnend) or v.turnstart == -1) then

                local mod = WL.TerritoryModification.Create(i)
                --specil unit immune/remove
                local SUdata = {}

                --Hot fix logic
                local hotfix = v.BaseSettings

                SUdata = SUImmuneOrNot(game.ServerGame.LatestTurnStanding.Territories[i],v.ModFormat,hotfix)
                if SUdata.Immune_logic == false then
                    mod.RemoveSpecialUnitsOpt = SUdata.SU -- remove SU

                    --ownership change
                    print(v2.ownerID, game.ServerGame.LatestTurnStanding.Territories[i].OwnerPlayerID, "ID's" )
                    if v2.OwnerID ~= nil and v2.OwnerID ~= game.ServerGame.LatestTurnStanding.Territories[i].OwnerPlayerID  then
                        mod.SetOwnerOpt = v2.OwnerID
                    end

                    --army change
                    print("test 1")
                    if v.armyValueChange ~= -1 and v.armyValueChange ~= game.ServerGame.LatestTurnStanding.Territories[i].NumArmies.NumArmies then
                        mod.SetArmiesTo = v.armyValueChange
                    end

                    --remove buildings
                    if v.Removebuild == true then
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

