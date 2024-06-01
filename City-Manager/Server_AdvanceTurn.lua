require('Utilities')


function Server_AdvanceTurn_End(game, addNewOrder)
    local publicdata = Mod.PublicGameData
    Game = game
local cityGroups = publicdata.cityGroups

if cityGroups == nil then cityGroups = {} end



    for _, bonus in pairs(game.Map.Bonuses) do

        if cityGroups[bonus.ID] == nil then
            cityGroups[bonus.ID] = {} 
            cityGroups[bonus.ID].Hascity = false
        end 

        local Noskip = Bonuschecker(game.Settings.OverriddenBonuses[bonus.ID], bonus.Amount)

        if Noskip == true  then

            for _, t in pairs(bonus.Territories) do

                local terr = game.ServerGame.LatestTurnStanding.Territories[t]
                local Cities = terr.Structures
                if (Cities == nil) then Cities = {}; end;

                
                if cityGroups[bonus.ID].Hascity == true and cityGroups[bonus.ID].citylocation ~= t and Cities[WL.StructureType.City] ~= nil and Cities[WL.StructureType.City] > 0 then
                    Cities[WL.StructureType.City] = 0

                    local mod = WL.TerritoryModification.Create(t)
                    mod.SetStructuresOpt = Cities
                    local UnitdiedMessage = ''
                    addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID , 'Illegal city placed. Removing\nOnly 1 city stack per bonus\nplace your city in '.. game.Map.Territories[cityGroups[bonus.ID].citylocation].Name , {}, {mod}))
                elseif cityGroups[bonus.ID].Hascity == false and Cities[WL.StructureType.City] ~= nil and Cities[WL.StructureType.City] > 0 then
                    local Control = WholeControl(bonus,t.OwnerPlayerID)
                    print(t.OwnerPlayerID,"owner")
                    --Checking to see if the player controls the whole bonus if their placing their first city
                    if Control then
                        cityGroups[bonus.ID].Hascity = true
                        cityGroups[bonus.ID].citylocation = t
                    else 
                        Cities[WL.StructureType.City] = 0

                        local mod = WL.TerritoryModification.Create(t)
                        mod.SetStructuresOpt = Cities
                        local UnitdiedMessage = ''
                        addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID , 'Illegal city placed. Removing\nYou must control the entire bonus(except neutrals around 1000 armies) to place the first city in a bonus' , {}, {mod}))
                   
                    end



                end

            end 
        end
    end

  --game.Settings.CustomScenario.SlotsAvailable
        

    publicdata.cityGroups = cityGroups
Mod.PublicGameData = publicdata
end

function Bonuschecker(over,base)
local dontskip = false
local holdskipvalue = 0

    if over ~= holdskipvalue then
        dontskip = true
    end
    if base == holdskipvalue and over == nil then
        dontskip = false
    end

return dontskip
end

function WholeControl(bonus,ID)

    for _, t in pairs(bonus.Territories) do
        print(t.OwnerPlayerID ,"inside func", ID)
        if t.OwnerPlayerID ~= ID then
            if t.OwnerPlayerID ~= 0 then
                return false
            elseif t.NumArmies.NumArmies < 900 and t.NumArmies.NumArmies > 1000 then
                return false
            end
 
        end
    end
    return true
end