require('Utilities')


function Server_AdvanceTurn_Start(game, addNewOrder)
-- only for 1 or two turns
  --[[  local goldhave
    local MaxGold = 19
    local added = 100
    local standing = game.ServerGame.LatestTurnStanding
    for playerID, player in pairs(game.Game.PlayingPlayers) do
        if (not player.IsAIOrHumanTurnedIntoAI) then 
           -- if playergroup[playerID] == nil then playergroup[playerID] = {} end
            local income = player.Income(0, standing, true, true) 
            goldhave = game.ServerGame.LatestTurnStanding.NumResources(playerID, WL.ResourceType.Gold)
           if income.Total <= MaxGold then
            local incomeMod = WL.IncomeMod.Create(playerID, added, 'Income for being weak')
            addNewOrder(WL.GameOrderEvent.Create(playerID, "Added income " , nil, nil,nil,{incomeMod}));
            --game.ServerGame.SetPlayerResource(playerID, WL.ResourceType.Gold, goldhave + 100)
            --
           end
        end
    end--]]


  publicdata = Mod.PublicGameData
  InActionAlready = {}


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

    local percentVote = (#publicdata.Action[i].VotingIDs / ActivePlayers) * 100
    if percentVote >= NeedPercent and InAction(publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID) then
        TurnPercent = publicdata.Action[i].turned


        if publicdata.Action[i].Actiontype == ActionTypeNames(1) then
        SwitchingLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID) 
        elseif publicdata.Action[i].Actiontype == ActionTypeNames(2) then
            SwapThenWasteland(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID)
        elseif publicdata.Action[i].Actiontype == ActionTypeNames(3) then
            EliminateasisLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID)
        elseif publicdata.Action[i].Actiontype == ActionTypeNames(4) then
            EliminateWasteLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID)
        elseif publicdata.Action[i].Actiontype == ActionTypeNames(5) then
            Absorblogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID)
        elseif publicdata.Action[i].Actiontype == ActionTypeNames(6) then
            ArmiesGone(game,addNewOrder,publicdata.Action[i].OrigPlayerID)
        end
        table.remove(publicdata.Action,i)
        i = i-1

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
            neworder(WL.GameOrderEvent.Create(0, 'Switching SU ID', nil, {terrMod}))
        end
    end
end
function SUDelete(land,neworder)

    local terrMod = WL.TerritoryModification.Create(land.ID)
    for i,v in pairs (land.NumArmies.SpecialUnits)do 


            terrMod.RemoveSpecialUnitsOpt = {v.ID}
            neworder(WL.GameOrderEvent.Create(0, 'Delete SU', nil, {terrMod}))
 
    end

end
function InAction( origID,newID) -- checks to see if a player in one action has already participated at all
    local notyet = true
    for i = 1, #InActionAlready do
        if origID == InActionAlready[i] or newID == InActionAlready[i] then
            notyet = false 
        end
    end
    return notyet
end
function Turnlogic(origlandamount)
    local percent = math.floor(origlandamount * (TurnPercent / 100))
    

    return percent
end
function SwitchingLogic(game,addNewOrder,OrigID,NewID) --- Swapping
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
    table.insert(InActionAlready,OrigID)
    table.insert(InActionAlready,NewID)

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
        addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', nil, {mod1}));
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
        addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', nil, {mod}));
        break
      end
     end
     if Switch.Commander ~= 0 then
     local cardinstance = {}
     table.insert(cardinstance,WL.NoParameterCardInstance.Create(WL.CardID.Airlift))
      addNewOrder(WL.GameOrderReceiveCard.Create(Switch.ID, cardinstance))
       addNewOrder(WL.GameOrderPlayCardAirlift.Create(cardinstance[1].ID, Switch.ID, Switch.Commander, idAirlift2, ArmystackSwitch))
     end


     local amountTurned = Turnlogic(#boot.bootedTerr)

   for i,ts in pairs (boot.bootedTerr) do
    if amountTurned < i then break end
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt  = Switch.ID
    addNewOrder(WL.GameOrderEvent.Create(0, "Switching", nil, {mod}))
    SUcompatibility(Terr[ts],addNewOrder,Switch.ID)
   end
   local amountTurned = Turnlogic(#Switch.SwitchTerr)
   for i,ts in pairs (Switch.SwitchTerr) do
    if amountTurned < i then break end
    local mod1 = WL.TerritoryModification.Create(ts)
     mod1.SetOwnerOpt = boot.ID
     addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', nil, {mod1}))
     SUcompatibility(Terr[ts],addNewOrder,boot.ID)
    end

end

function SwapThenWasteland(game,addNewOrder,OrigID,NewID) --- Swapping to wasteland
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
    table.insert(InActionAlready,OrigID)
    table.insert(InActionAlready,NewID)

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

local amountTurned = Turnlogic(#boot.bootedTerr)


---------------------------------
     local idAirlift2 = 0
     for i,ts in pairs (boot.bootedTerr) do --turning first spot switch into boot 
      if #Terr[ts].NumArmies.SpecialUnits == 0 then
        local mod = WL.TerritoryModification.Create(ts)
        mod.SetOwnerOpt = Switch.ID
        idAirlift2 = Terr[ts].ID
        addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', nil, {mod}));
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
    if amountTurned < i then break end
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt  = Switch.ID
    addNewOrder(WL.GameOrderEvent.Create(0, "Switching", nil, {mod}))
    SUcompatibility(Terr[ts],addNewOrder,Switch.ID)
   end
   for i,ts in pairs (Switch.SwitchTerr) do
    local mod1 = WL.TerritoryModification.Create(ts)
    local Cities = {}
    Cities[WL.StructureType.City] = 0
     mod1.SetOwnerOpt = 0
     mod1.SetArmiesTo = NeutralValue
     mod1.SetStructuresOpt = Cities
     addNewOrder(WL.GameOrderEvent.Create(0, 'Switching', nil, {mod1}))
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
    table.insert(InActionAlready,OrigID)
    table.insert(InActionAlready,NewID)

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

--- Percent logic
   local amountTurned = Turnlogic(#boot.bootedTerr)

---------------------------------

   for i,ts in pairs (boot.bootedTerr) do
    if amountTurned < i then break end
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt  = Switch.ID
    addNewOrder(WL.GameOrderEvent.Create(0, "Absorbing", nil, {mod}))
    SUcompatibility(Terr[ts],addNewOrder,Switch.ID)
   end


end
function EliminateasisLogic(game,addNewOrder,OrigID) --- Eliminating as is
    --645468
    local boot = {} 
     boot.ID = OrigID 
    boot.Commander = 0 
    boot.bootedTerr = {} 

    local ArmyStackBoot
    local ArmystackSwitch
    local Terr = game.ServerGame.LatestTurnStanding.Territories
    table.insert(InActionAlready,OrigID)

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

   local amountTurned = Turnlogic(#boot.bootedTerr)

   for i,ts in pairs (boot.bootedTerr) do
    if amountTurned < i then break end
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt = 0
    addNewOrder(WL.GameOrderEvent.Create(0, "Eliminating", nil, {mod}))

   end


end
function EliminateWasteLogic(game,addNewOrder,OrigID) -- Eliminate to wasteland 
    --645468
    local boot = {} 
     boot.ID = OrigID 
    boot.Commander = 0 
    boot.bootedTerr = {} 


    local ArmyStackBoot
    local ArmystackSwitch
    local Terr = game.ServerGame.LatestTurnStanding.Territories
    table.insert(InActionAlready,OrigID)

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
   local amountTurned = Turnlogic(#boot.bootedTerr)

   for i,ts in pairs (boot.bootedTerr) do
    if amountTurned < i then break end
    local mod = WL.TerritoryModification.Create(ts)
    local Cities = {}
    Cities[WL.StructureType.City] = 0
     mod.SetOwnerOpt = 0
     mod.SetArmiesTo = NeutralValue
     mod.SetStructuresOpt = Cities
    addNewOrder(WL.GameOrderEvent.Create(0, "Eliminating", nil, {mod}))
    SUDelete(Terr[ts],addNewOrder)
   end


end
function ArmiesGone(game,addNewOrder,OrigID) --- Remove Armies
    --645468
    local boot = {} 
     boot.ID = OrigID 
    boot.Commander = 0 
    boot.bootedTerr = {} 


    local ArmyStackBoot
    local ArmystackSwitch
    local Terr = game.ServerGame.LatestTurnStanding.Territories
    table.insert(InActionAlready,OrigID)

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
   local amountTurned = Turnlogic(#boot.bootedTerr)

   for i,ts in pairs (boot.bootedTerr) do
    if amountTurned < i then break end
    local mod = WL.TerritoryModification.Create(ts)
     mod.SetArmiesTo = 0
    addNewOrder(WL.GameOrderEvent.Create(0, "Erase Armies", nil, {mod}))
    SUDelete(Terr[ts],addNewOrder)
   end


end