require('Utilities');

function Server_StartGame (game,standing)
    local unitdata = {}
    local maxauto = 0

     unitdata = Mod.Settings.Unitdata
     local typeamount = Mod.Settings.BeforeMax


     for type=1, typeamount do
        for _,ts in pairs(standing.Territories) do
            if ts.NumArmies.NumArmies == unitdata[type].Autovalue and unitdata[type].Autovalue > 0 and maxauto <= 60 then
                maxauto = maxauto + 1

                local unitpower = Mod.Settings.Unitdata[type].unitpower
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
                local assass = Nonill(Mod.Settings.Unitdata[type].Assassination)

                if (Mod.Settings.Unitdata[type].Altmoves ~= nil and Mod.Settings.Unitdata[type].Altmoves ~= false)then -- adding values after mod launched
                    altmove = 1
                end 
                local filename = Filefinder(image) -- sort through images to find the correct one
                if (maxlife ~= 0)then
                Turnkilled = math.random(minlife,maxlife) + game.Game.TurnNumber 
                end
                if (levelamount > 0)then
                    typename = 'LV0 ' .. typename
                end
                if Nonill(Mod.Settings.Unitdata[type].CombatOrder) == 1 then
                    combatorder = combatorder * -1
                    end

                local absoredDamage = AbsoredDecider(unitpower,defence)
                local startinglevel = 0
        
                local builder = WL.CustomSpecialUnitBuilder.Create(ts.OwnerPlayerID);
                builder.Name = typename;
                builder.IncludeABeforeName = true;
                builder.ImageFilename = filename;
                builder.AttackPower = unitpower;
                builder.DefensePower = defence;
                builder.CombatOrder = combatorder
                builder.DamageToKill = absoredDamage
                builder.DamageAbsorbedWhenAttacked = absoredDamage * 0.5
                builder.CanBeGiftedWithGiftCard = true
                builder.CanBeTransferredToTeammate = false
                builder.CanBeAirliftedToSelf = true
                builder.CanBeAirliftedToTeammate = true
                builder.TextOverHeadOpt = charactername
                builder.IsVisibleToAllPlayers = visible;
                builder.ModData = ModSign(0) .. Turnkilled .. ';;' .. transfer .. ';;' .. levelamount .. ';;' .. currentxp .. ';;' .. unitpower .. ';;' .. startinglevel .. ';;'.. defence .. ';;'.. altmove .. ';;'.. assass
                local unit = builder.Build()

                local S = {}
                table.insert(S,unit)
                ts.NumArmies = WL.Armies.Create(0,S);

            end
    end
end
end