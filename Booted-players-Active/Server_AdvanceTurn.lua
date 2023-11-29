require('Utilities')


function Server_AdvanceTurn_Start(game, addNewOrder)

  publicdata = Mod.PublicGameData
    if publicdata.boot == nil then publicdata.boot = {} end
    if publicdata.Switch == nil then publicdata.Switch = {} end
    if publicdata.boot.ID == nil then publicdata.boot.ID = 1 end
    if publicdata.Switch.ID == nil then publicdata.Switch.ID = 645468 end
    if publicdata.boot.Commander == nil then publicdata.boot.Commander = 0 end
    if publicdata.Switch.Commander == nil then publicdata.Switch.Commander = 0 end
    if publicdata.boot.bootedTerr == nil then publicdata.boot.bootedTerr = {} end
    if publicdata.Switch.SwitchTerr == nil then publicdata.Switch.SwitchTerr = {} end

    if game.Game.TurnNumber == 1 then
        print(game.Game.PlayingPlayers[2])
        for i,v in pairs(game.Game.PlayingPlayers)do
    print(i,v)
            end

    local ArmyStackBoot
    local ArmystackSwitch
    local Terr = game.ServerGame.LatestTurnStanding.Territories

   for _,ts in pairs(Terr)do -- getting the Territories of each player
    if ts.OwnerPlayerID == publicdata.boot.ID then -- boot

        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                publicdata.boot.Commander = ts.ID
                ArmyStackBoot = ts.NumArmies
            end
        end
        table.insert(publicdata.boot.bootedTerr,ts.ID)

    elseif ts.OwnerPlayerID == publicdata.Switch.ID then -- switch
        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                publicdata.Switch.Commander = ts.ID
                ArmystackSwitch = ts.NumArmies
            end
        end
        table.insert(publicdata.Switch.SwitchTerr,ts.ID)
    end
   end

--- Moving commander logic



   local idAirlift = 0
   for i,ts in pairs (publicdata.Switch.SwitchTerr) do --turning first spot switch into boot 
    if #Terr[ts].NumArmies.SpecialUnits == 0 then 

        local mod1 = WL.TerritoryModification.Create(ts)
        mod1.SetOwnerOpt = publicdata.boot.ID
        idAirlift = Terr[ts].ID
        addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', {}, {mod1}));
        break
    end
   end
   if  publicdata.boot.Commander ~= 0 then
   local cardinstance = {}
   table.insert(cardinstance,WL.NoParameterCardInstance.Create(WL.CardID.Airlift))
    addNewOrder(WL.GameOrderReceiveCard.Create(publicdata.boot.ID, cardinstance))
     addNewOrder(WL.GameOrderPlayCardAirlift.Create(cardinstance[1].ID, publicdata.boot.ID, publicdata.boot.Commander, idAirlift, ArmyStackBoot))
   end
---------------------------------
     local idAirlift2 = 0
     for i,ts in pairs (publicdata.boot.bootedTerr) do --turning first spot switch into boot 
      if #Terr[ts].NumArmies.SpecialUnits == 0 then
        local mod = WL.TerritoryModification.Create(ts)
        mod.SetOwnerOpt = publicdata.Switch.ID
        idAirlift2 = Terr[ts].ID
        addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', {}, {mod}));
        break
      end
     end
     if publicdata.Switch.Commander ~= 0 then
     local cardinstance = {}
     table.insert(cardinstance,WL.NoParameterCardInstance.Create(WL.CardID.Airlift))
      addNewOrder(WL.GameOrderReceiveCard.Create(publicdata.Switch.ID, cardinstance))
       addNewOrder(WL.GameOrderPlayCardAirlift.Create(cardinstance[1].ID, publicdata.Switch.ID, publicdata.Switch.Commander, idAirlift2, ArmystackSwitch))
     end


   for i,ts in pairs (publicdata.boot.bootedTerr) do
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt  = publicdata.Switch.ID
    addNewOrder(WL.GameOrderEvent.Create(0, "Switching", {}, {mod}))
    SUcompatibility(Terr[ts],addNewOrder,publicdata.Switch.ID)
   end
   for i,ts in pairs (publicdata.Switch.SwitchTerr) do
    local mod1 = WL.TerritoryModification.Create(ts)
     mod1.SetOwnerOpt = publicdata.boot.ID
     addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', {}, {mod1}))
     SUcompatibility(Terr[ts],addNewOrder,publicdata.boot.ID)
    end

    
    
Mod.PublicGameData = publicdata
end
end

function SUcompatibility(land,neworder,newowner)
    for i,v in pairs (land.NumArmies.SpecialUnits)do 
        if v.proxyType == "CustomSpecialUnit" then 
            local builder = WL.CustomSpecialUnitBuilder.CreateCopy(v)
            local terrMod = WL.TerritoryModification.Create(land.ID)
            print(newowner)
            builder.OwnerID = newowner
            terrMod.AddSpecialUnits = {builder.Build()}
            terrMod.RemoveSpecialUnitsOpt = {v.ID}
            neworder(WL.GameOrderEvent.Create(0, 'Switching SU ID', {}, {terrMod}))
        end
    end
end
