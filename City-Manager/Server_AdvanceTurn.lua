require('Utilities')


function Server_AdvanceTurn_End(game, addNewOrder)
    local publicdata = Mod.PublicGameData
local cityGroups = publicdata.cityGroups
print (cityGroups )
if cityGroups == nil then cityGroups = {} end



    for _, bonus in pairs(game.Map.Bonuses) do
       -- print('bonus ------ ', bonus.Name)
        if cityGroups[bonus.ID] == nil then
            cityGroups[bonus.ID] = {} 
            cityGroups[bonus.ID].Hascity = false
        end 
local Noskip = Bonuschecker(game.Settings.OverriddenBonuses[bonus.ID], bonus.Amount)
        if Noskip == true  then
print ('did you print value')
            for _, t in pairs(bonus.Territories) do

                local terr = game.ServerGame.LatestTurnStanding.Territories[t]
                local Cities = terr.Structures;
                if (Cities == nil) then Cities = {}; end;

                if(terr.Structures ~= nil)then
                print (terr.Structures[WL.StructureType.City])
                end
                
                if cityGroups[bonus.ID].Hascity == true and cityGroups[bonus.ID].citylocation ~= t and Cities[WL.StructureType.City] ~= nil and Cities[WL.StructureType.City] > 0 then
                    Cities[WL.StructureType.City] = 0

                    local mod = WL.TerritoryModification.Create(t)
                    mod.SetStructuresOpt = Cities
                    local UnitdiedMessage = ''
                    addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID , 'Illegal city placed. Removing\nOnly 1 city stack per bonus', {}, {mod}));
                elseif cityGroups[bonus.ID].Hascity == false and Cities[WL.StructureType.City] ~= nil and Cities[WL.StructureType.City] > 0 then
                    cityGroups[bonus.ID].Hascity = true
                    cityGroups[bonus.ID].citylocation = t

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
local holdskipvalue = 14

    if over ~= holdskipvalue then
        dontskip = true
    end
    if base == holdskipvalue and over == base then
        dontskip = false
    end

return dontskip
end

