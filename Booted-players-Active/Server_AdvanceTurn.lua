require('Utilities')


function Server_AdvanceTurn_Start(game, addNewOrder)

  publicdata = Mod.PublicGameData
  if publicdata.Action == nil then publicdata.Action = {} end
  local ActivePlayers = 0
  local NeedPercent = Mod.Settings.Percentthreshold
  NeutralValue = Mod.Settings.WastelandAmount
  for playerID, player in pairs(game.Game.PlayingPlayers) do
    if (not player.IsAIOrHumanTurnedIntoAI) then 
        ActivePlayers = ActivePlayers + 1
    end
end

--"Swapped","Swap & Wasteland", "Eliminate as is","Eliminate to Wasteland","Absorb"
local array = {}

local i = 1
  while i <= #publicdata.Action do -- Action logic
    print(i,"i ===")
    if publicdata.Action[i].NewPlayerID == publicdata.Action[i].OrigPlayerID then table.remove(publicdata.Action,i) break end
    local percentVote = (#publicdata.Action[i].VotingIDs / ActivePlayers) * 100
    if percentVote >= NeedPercent then
        local temp = publicdata.Action[i].NewPlayerID
        if temp ~= "Neutral" then temp = game.Game.PlayingPlayers[publicdata.Action[i].NewPlayerID].State 
            print("yes")
        else temp = 2 print("no") end
       print(temp,"temp")
        if game.Game.PlayingPlayers[publicdata.Action[i].OrigPlayerID].State ~= 2 or temp ~= 2 then
            table.remove(publicdata.Action,i)
            i = i-1
            print("point 2",game.Game.PlayingPlayers[publicdata.Action[i].OrigPlayerID].State,temp)
            goto jump
        end



        if publicdata.Action[i].Actiontype == "Swapped" then
        SwitchingLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID) 
        elseif publicdata.Action[i].Actiontype == "Swap & Wasteland" then
            SwapThenWasteland(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID)
        elseif publicdata.Action[i].Actiontype == "Eliminate as is" then
            EliminateasisLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID)
        elseif publicdata.Action[i].Actiontype == "Eliminate to Wasteland" then
            EliminateWasteLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID)
        elseif publicdata.Action[i].Actiontype == "Absorb" then
            Absorblogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID)
        end
        table.remove(publicdata.Action,i)
        i = i-1
        print("point 1")
        ::jump::
    end

    i = i + 1
  end

Mod.PublicGameData = publicdata

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
function SUDelete(land,neworder)

    local terrMod = WL.TerritoryModification.Create(land.ID)
    for i,v in pairs (land.NumArmies.SpecialUnits)do 


            terrMod.RemoveSpecialUnitsOpt = {v.ID}
            neworder(WL.GameOrderEvent.Create(0, 'Delete SU', {}, {terrMod}))
 
    end

end

function SwitchingLogic(game,addNewOrder,OrigID,NewID)
    --645468
    local boot = {} 
    local Switch = {} 
     boot.ID = OrigID 
    Switch.ID = NewID 
    boot.Commander = 0 
    Switch.Commander = 0 
    boot.bootedTerr = {} 
    Switch.SwitchTerr = {} 

    local ArmyStackBoot
    local ArmystackSwitch
    local Terr = game.ServerGame.LatestTurnStanding.Territories

   for _,ts in pairs(Terr)do -- getting the Territories of each player
    if ts.OwnerPlayerID == boot.ID then -- boot

        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                boot.Commander = ts.ID
                ArmyStackBoot = ts.NumArmies
            end
        end
        table.insert(boot.bootedTerr,ts.ID)

    elseif ts.OwnerPlayerID == Switch.ID then -- switch
        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                Switch.Commander = ts.ID
                ArmystackSwitch = ts.NumArmies
            end
        end
        table.insert(Switch.SwitchTerr,ts.ID)
    end
   end

--- Moving commander logic



   local idAirlift = 0
   for i,ts in pairs (Switch.SwitchTerr) do --turning first spot switch into boot 
    if #Terr[ts].NumArmies.SpecialUnits == 0 then 

        local mod1 = WL.TerritoryModification.Create(ts)
        mod1.SetOwnerOpt = boot.ID
        idAirlift = Terr[ts].ID
        addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', {}, {mod1}));
        break
    end
   end
   if  boot.Commander ~= 0 then
   local cardinstance = {}
   table.insert(cardinstance,WL.NoParameterCardInstance.Create(WL.CardID.Airlift))
    addNewOrder(WL.GameOrderReceiveCard.Create(boot.ID, cardinstance))
     addNewOrder(WL.GameOrderPlayCardAirlift.Create(cardinstance[1].ID, boot.ID, boot.Commander, idAirlift, ArmyStackBoot))
   end
---------------------------------
     local idAirlift2 = 0
     for i,ts in pairs (boot.bootedTerr) do --turning first spot switch into boot 
      if #Terr[ts].NumArmies.SpecialUnits == 0 then
        local mod = WL.TerritoryModification.Create(ts)
        mod.SetOwnerOpt = Switch.ID
        idAirlift2 = Terr[ts].ID
        addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', {}, {mod}));
        break
      end
     end
     if Switch.Commander ~= 0 then
     local cardinstance = {}
     table.insert(cardinstance,WL.NoParameterCardInstance.Create(WL.CardID.Airlift))
      addNewOrder(WL.GameOrderReceiveCard.Create(Switch.ID, cardinstance))
       addNewOrder(WL.GameOrderPlayCardAirlift.Create(cardinstance[1].ID, Switch.ID, Switch.Commander, idAirlift2, ArmystackSwitch))
     end


   for i,ts in pairs (boot.bootedTerr) do
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt  = Switch.ID
    addNewOrder(WL.GameOrderEvent.Create(0, "Switching", {}, {mod}))
    SUcompatibility(Terr[ts],addNewOrder,Switch.ID)
   end
   for i,ts in pairs (Switch.SwitchTerr) do
    local mod1 = WL.TerritoryModification.Create(ts)
     mod1.SetOwnerOpt = boot.ID
     addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', {}, {mod1}))
     SUcompatibility(Terr[ts],addNewOrder,boot.ID)
    end

end


function SwapThenWasteland(game,addNewOrder,OrigID,NewID)
    --645468
    local boot = {} 
    local Switch = {} 
     boot.ID = OrigID 
    Switch.ID = NewID 
    boot.Commander = 0 
    Switch.Commander = 0 
    boot.bootedTerr = {} 
    Switch.SwitchTerr = {} 

    local ArmyStackBoot
    local ArmystackSwitch
    local Terr = game.ServerGame.LatestTurnStanding.Territories

   for _,ts in pairs(Terr)do -- getting the Territories of each player
    if ts.OwnerPlayerID == boot.ID then -- boot

        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                boot.Commander = ts.ID
                ArmyStackBoot = ts.NumArmies
                SUDelete(ts,addNewOrder)
            end
        end
        table.insert(boot.bootedTerr,ts.ID)

    elseif ts.OwnerPlayerID == Switch.ID then -- switch
        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                Switch.Commander = ts.ID
                ArmystackSwitch = ts.NumArmies
            end
        end
        table.insert(Switch.SwitchTerr,ts.ID)
    end
   end

--- Moving commander logic




---------------------------------
     local idAirlift2 = 0
     for i,ts in pairs (boot.bootedTerr) do --turning first spot switch into boot 
      if #Terr[ts].NumArmies.SpecialUnits == 0 then
        local mod = WL.TerritoryModification.Create(ts)
        mod.SetOwnerOpt = Switch.ID
        idAirlift2 = Terr[ts].ID
        addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', {}, {mod}));
        break
      end
     end
     if Switch.Commander ~= 0 then
     local cardinstance = {}
     table.insert(cardinstance,WL.NoParameterCardInstance.Create(WL.CardID.Airlift))
      addNewOrder(WL.GameOrderReceiveCard.Create(Switch.ID, cardinstance))
       addNewOrder(WL.GameOrderPlayCardAirlift.Create(cardinstance[1].ID, Switch.ID, Switch.Commander, idAirlift2, ArmystackSwitch))
     end


   for i,ts in pairs (boot.bootedTerr) do
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt  = Switch.ID
    addNewOrder(WL.GameOrderEvent.Create(0, "Switching", {}, {mod}))
    SUcompatibility(Terr[ts],addNewOrder,Switch.ID)
   end
   for i,ts in pairs (Switch.SwitchTerr) do
    local mod1 = WL.TerritoryModification.Create(ts)
    local Cities = {}
    Cities[WL.StructureType.City] = 0
     mod1.SetOwnerOpt = 0
     mod1.SetArmiesTo = NeutralValue
     mod1.SetStructuresOpt = Cities
     addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', {}, {mod1}))
     SUDelete(Terr[ts],addNewOrder)
    end

end
function Absorblogic(game,addNewOrder,OrigID,NewID)
    --645468
    local boot = {} 
    local Switch = {} 
     boot.ID = OrigID 
    Switch.ID = NewID 
    boot.Commander = 0 
    Switch.Commander = 0 
    boot.bootedTerr = {} 
    Switch.SwitchTerr = {} 


    local ArmyStackBoot
    local ArmystackSwitch
    local Terr = game.ServerGame.LatestTurnStanding.Territories

   for _,ts in pairs(Terr)do -- getting the Territories of each player
    if ts.OwnerPlayerID == boot.ID then -- boot

        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                boot.Commander = ts.ID
                ArmyStackBoot = ts.NumArmies
                SUDelete(ts,addNewOrder)
            end
        end
        table.insert(boot.bootedTerr,ts.ID)

    elseif ts.OwnerPlayerID == Switch.ID then -- switch
        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                Switch.Commander = ts.ID
                ArmystackSwitch = ts.NumArmies
            end
        end
        table.insert(Switch.SwitchTerr,ts.ID)
    end
   end

--- Moving commander logic




---------------------------------
     local idAirlift2 = 0
     for i,ts in pairs (boot.bootedTerr) do --turning first spot switch into boot 
      if #Terr[ts].NumArmies.SpecialUnits == 0 then
        local mod = WL.TerritoryModification.Create(ts)
        mod.SetOwnerOpt = Switch.ID
        idAirlift2 = Terr[ts].ID
        addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', {}, {mod}));
        break
      end
     end
     if Switch.Commander ~= 0 then
     local cardinstance = {}
     table.insert(cardinstance,WL.NoParameterCardInstance.Create(WL.CardID.Airlift))
      addNewOrder(WL.GameOrderReceiveCard.Create(Switch.ID, cardinstance))
       addNewOrder(WL.GameOrderPlayCardAirlift.Create(cardinstance[1].ID, Switch.ID, Switch.Commander, idAirlift2, ArmystackSwitch))
     end


   for i,ts in pairs (boot.bootedTerr) do
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt  = Switch.ID
    addNewOrder(WL.GameOrderEvent.Create(0, "Switching", {}, {mod}))
    SUcompatibility(Terr[ts],addNewOrder,Switch.ID)
   end


end
function EliminateasisLogic(game,addNewOrder,OrigID)
    --645468
    local boot = {} 
     boot.ID = OrigID 
    boot.Commander = 0 
    boot.bootedTerr = {} 

    local ArmyStackBoot
    local ArmystackSwitch
    local Terr = game.ServerGame.LatestTurnStanding.Territories

   for _,ts in pairs(Terr)do -- getting the Territories of each player
    if ts.OwnerPlayerID == boot.ID then -- boot
        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                boot.Commander = ts.ID
                ArmyStackBoot = ts.NumArmies
            end
        end
        table.insert(boot.bootedTerr,ts.ID)
    end
   end

   for i,ts in pairs (boot.bootedTerr) do
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt = 0
    addNewOrder(WL.GameOrderEvent.Create(0, "Eliminating", {}, {mod}))

   end


end
function EliminateWasteLogic(game,addNewOrder,OrigID)
    --645468
    local boot = {} 
     boot.ID = OrigID 
    boot.Commander = 0 
    boot.bootedTerr = {} 


    local ArmyStackBoot
    local ArmystackSwitch
    local Terr = game.ServerGame.LatestTurnStanding.Territories

   for _,ts in pairs(Terr)do -- getting the Territories of each player
    if ts.OwnerPlayerID == boot.ID then -- boot
        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                boot.Commander = ts.ID
                ArmyStackBoot = ts.NumArmies
            end
        end
        table.insert(boot.bootedTerr,ts.ID)
    end
   end

   for i,ts in pairs (boot.bootedTerr) do
    local mod = WL.TerritoryModification.Create(ts)
    local Cities = {}
    Cities[WL.StructureType.City] = 0
     mod.SetOwnerOpt = 0
     mod.SetArmiesTo = NeutralValue
     mod.SetStructuresOpt = Cities
    addNewOrder(WL.GameOrderEvent.Create(0, "Eliminating", {}, {mod}))
    SUDelete(Terr[ts],addNewOrder)
   end


end