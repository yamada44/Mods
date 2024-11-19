require('Utilities')

-- local function generateUnitAttributes(unit, gameTurnNumber)
--     return {
--         name = (unit.Level > 0 and "LV0 " or "") .. unit.Name,
--         image = unit.image,
--         attackPower = math.random(unit.unitpower, unit.AttackMax),
--         defensePower = unit.Defend,
--         combatOrder = unit.CombatOrder == 1 and -123 or 123,
--         damageToKill = (math.random(unit.unitpower, unit.AttackMax) + unit.Defend) / 2,
--         isVisible = unit.Visible,
--         modData = modSign(0) .. ";" .. (unit.Maxlife ~= 0 and math.random(unit.Minlife, unit.Maxlife) + gameTurnNumber or 0) .. ";" .. unit.Transfer .. ";" .. unit.Level .. ";" .. 0 .. ";" .. (unit.Altmoves and 1 or 0) .. ";" .. (unit.Assassination or 0),
--     }
-- end

-- function Server_StartGame(game, standing)
--     local count = 0
--     local MAX_UNITS_TO_DEPLOY_ON_MAP = 60
--     local unitData = Mod.Settings.Unitdata

--     for typeIndex = 1, Mod.Settings.BeforeMax do
--         if count > MAX_UNITS_TO_DEPLOY_ON_MAP then break end -- Early exit if max auto units created
--         local unit = unitData[typeIndex]

--         for _, territory in pairs(standing.Territories) do
--             if territory.NumArmies.NumArmies == unit.Autovalue and unit.Autovalue > 0 then
--                 local attributes = generateUnitAttributes(unit, game.Game.TurnNumber)
                
--                 -- Use the buildCustomUnit function to create and configure the unit builder
--                 local builder = buildCustomUnit(territory.OwnerPlayerID, attributes)
--                 local newUnit = builder.Build()

--                 territory.NumArmies = WL.Armies.Create(10, {newUnit})

--                 maxAuto = maxAuto + 1
--             end
--         end
--     end
-- end


function Server_StartGame (game,standing)
    local unitdata = {}
    local maxauto = 0

     unitdata = Mod.Settings.Unitdata
     local typeamount = Mod.Settings.BeforeMax


     for type=1, typeamount do
        for _,ts in pairs(standing.Territories) do
            if ts.NumArmies.NumArmies == unitdata[type].Autovalue and unitdata[type].Autovalue > 0 and maxauto <= 60 then
                maxauto = maxauto + 1
                
                local unitpower = math.random(Mod.Settings.Unitdata[type].unitpower,Mod.Settings.Unitdata[type].AttackMax)
                local typename = Mod.Settings.Unitdata[type].Name
                local image = Mod.Settings.Unitdata[type].image
                local visible = Mod.Settings.Unitdata[type].Visible
                local charactername = typename
                local minlife = Mod.Settings.Unitdata[type].Minlife
                local maxlife = Mod.Settings.Unitdata[type].Maxlife
                local Turnkilled = 0
                local transfer = Mod.Settings.Unitdata[type].Transfer
                local levelamount = Mod.Settings.Unitdata[type].Level
                local currentxp = 0 
                local defence = Mod.Settings.Unitdata[type].Defend
                local altmove = 0
                local combatorder = 123
                local assass = Mod.Settings.Unitdata[type].Assassination or 0
                local upkeep = Mod.Settings.Unitdata[type].Upkeep or 0
                local owner = ts.OwnerPlayerID
                
                if owner == 0 then owner = game.Game.Players[1] end
                if (Mod.Settings.Unitdata[type].Altmoves ~= nil and Mod.Settings.Unitdata[type].Altmoves ~= false)then -- adding values after mod launched
                    altmove = 1
                end 
                local filename = getImageFile(image) -- sort through images to find the correct one
                if (maxlife ~= 0)then
                Turnkilled = math.random(minlife,maxlife) + game.Game.TurnNumber 
                end
                if (levelamount > 0)then
                    typename = 'LV0 ' .. typename
                end
                if (Mod.Settings.Unitdata[type].CombatOrder or 0) == 1 then
                    combatorder = combatorder * -1
                    end

                local absoredDamage = (unitpower+defence)/2
                local startinglevel = 0
        
                local builder = WL.CustomSpecialUnitBuilder.Create(ts.OwnerPlayerID);
                builder.Name = typename;
                builder.IncludeABeforeName = true;
                builder.ImageFilename = filename;
                builder.AttackPower = unitpower;
                builder.DefensePower = defence;
                builder.CombatOrder = combatorder
                builder.DamageToKill = absoredDamage
                builder.DamageAbsorbedWhenAttacked = absoredDamage
                builder.CanBeGiftedWithGiftCard = true
                builder.CanBeTransferredToTeammate = false
                builder.CanBeAirliftedToSelf = true
                builder.CanBeAirliftedToTeammate = true
                builder.TextOverHeadOpt = charactername
                builder.IsVisibleToAllPlayers = visible;
                builder.ModData = modSign(0) .. Turnkilled .. ';;' .. transfer .. ';;' .. levelamount .. ';;' .. currentxp .. ';;' .. unitpower .. ';;' .. startinglevel .. ';;'.. defence .. ';;'.. altmove .. ';;'.. assass .. ';;' .. type .. ';;' .. upkeep
                local unit = builder.Build()

                local S = {}
                table.insert(S,unit)
                ts.NumArmies = WL.Armies.Create(ts.NumArmies.NumArmies,S)

            end
    end
end
end
