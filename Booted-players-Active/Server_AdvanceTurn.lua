require('Utilities')


function Server_AdvanceTurn_Start(game, addNewOrder)


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

local array = {}

local i = 1
  while i <= #publicdata.Action do -- Action logic
    local access = true
    if (publicdata.Action[i].TurnCreated + 3) - game.Game.TurnNumber <= 0 then table.remove(publicdata.Action,i) access = false end -- remove action after 3 turns

    if access == true then -- to retrict scope of percentvote
    
        local percentVote = (#publicdata.Action[i].VotingIDs / ActivePlayers) * 100
        local alwaysaccess = false -- Host control logic
         if publicdata.HostID > 0 then alwaysaccess = true end
        if (percentVote >= NeedPercent or alwaysaccess ) and InAction(publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID) then
            TurnPercent = publicdata.Action[i].turned


            if publicdata.Action[i].Actiontype == ActionTypeNames(1) then
            SwitchingLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID) 
            elseif publicdata.Action[i].Actiontype == ActionTypeNames(2) then
                SwapThenWasteland(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID,publicdata.Action[i].Bonus)
            elseif publicdata.Action[i].Actiontype == ActionTypeNames(3) then
                EliminateasisLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].Bonus)
            elseif publicdata.Action[i].Actiontype == ActionTypeNames(4) then
                EliminateWasteLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].Bonus)
            elseif publicdata.Action[i].Actiontype == ActionTypeNames(5) then
                Absorblogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID,publicdata.Action[i].Bonus)
            elseif publicdata.Action[i].Actiontype == ActionTypeNames(6) then
                ArmiesGone(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].Bonus)
            elseif publicdata.Action[i].Actiontype == ActionTypeNames(7)  then
                GoldBumpLogic(game, addNewOrder,publicdata.Action[i].incomebump,publicdata.Action[i].Cutoff)
            elseif publicdata.Action[i].Actiontype == ActionTypeNames(8)  then
                Absorb_ArmiesErasedLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].NewPlayerID,publicdata.Action[i].Bonus)
            elseif publicdata.Action[i].Actiontype == ActionTypeNames(9)  then
                Eliminate_ArmiesGoneLogic(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].Bonus)
            elseif publicdata.Action[i].Actiontype == ActionTypeNames(10)  then -- Army cut off
                ArmiesCut(game,addNewOrder,publicdata.Action[i].OrigPlayerID,publicdata.Action[i].Bonus,publicdata.Action[i].Armycut)
            elseif publicdata.Action[i].Actiontype == ActionTypeNames(11)  then -- Gold by players
                GoltToOne(game,addNewOrder,publicdata.Action[i].incomebump, publicdata.Action[i].OrigPlayerID)
            end
            Addhistory(publicdata.Action[i],percentVote,game)
            table.remove(publicdata.Action,i)

            i = i-1

        end  

        i = i + 1
    end
  end



-- clearing Action creation ID's
if publicdata.Turn ~= nil  then
    publicdata.CreatedActionID = {}
    publicdata.CreatedHostchangeID = {}
    publicdata.Turn = game.Game.TurnNumber

    --Host Vote Calculations 
    if publicdata.ChangeAction ~= nil then
        for i = 1, #publicdata.ChangeAction do 
            local percentVote = (#publicdata.ChangeAction[i].VotedPlayers / ActivePlayers) * 100
            if percentVote >= NeedPercent then
                publicdata.HostID = publicdata.ChangeAction[i].NewHostID
                table.remove(publicdata.ChangeAction,i)
                break
            end
        end
            i = 1
            while i <= #publicdata.ChangeAction do -- Action logic

                if (publicdata.ChangeAction[i].TurnCreated + 2) - game.Game.TurnNumber <= 0 then table.remove(publicdata.ChangeAction,i) i = i - 1  end -- remove Host change after 2 turns
                i = i + 1
            end
    end
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
    return (math.floor(origlandamount * (TurnPercent / 100)))
    
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

function SwapThenWasteland(game,addNewOrder,OrigID,NewID,Bonuson) --- Swapping to wasteland
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
        if Bonuson == false then -- bonus terrain on
            
            for _,v in pairs (ts.NumArmies.SpecialUnits) do 
                if v.proxyType == "Commander" then
                    boot.Commander = ts.ID
                    ArmyStackBoot = ts.NumArmies
                    SUDelete(ts,addNewOrder)
                end
            end
            table.insert(boot.bootedTerr,ts.ID)
        end
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

   -- Logic for bonus terrain
   if Bonuson == true then
    for __, TID in pairs (game.Map.Bonuses[OrigID].Territories) do 
        table.insert(boot.bootedTerr,TID)

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

--Action logic orig
   for i,ts in pairs (boot.bootedTerr) do
    if amountTurned < i then break end
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt  = Switch.ID
    addNewOrder(WL.GameOrderEvent.Create(0, "Switching", nil, {mod}))
    SUcompatibility(Terr[ts],addNewOrder,Switch.ID)
   end
   --Action logic new 
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
function Absorblogic(game,addNewOrder,OrigID,NewID,Bonuson) -- Absorb logic
    --645468
    local boot = {} 
    local Switch = {} 
     boot.ID = OrigID 
    Switch.ID = NewID 
    boot.Commander = 0 
    Switch.Commander = 0 
    boot.bootedTerr = {} 
    Switch.SwitchTerr = {} 



    local Terr = game.ServerGame.LatestTurnStanding.Territories
    table.insert(InActionAlready,OrigID)
    table.insert(InActionAlready,NewID)

   for _,ts in pairs(Terr)do -- getting the Territories of each player
    if ts.OwnerPlayerID == boot.ID then -- boot
        if Bonuson == false then -- bonus terrain on
            for _,v in pairs (ts.NumArmies.SpecialUnits) do 
                if v.proxyType == "Commander" then
                    boot.Commander = ts.ID
                    SUDelete(ts,addNewOrder)
                end
            end
            table.insert(boot.bootedTerr,ts.ID)
        end
    elseif ts.OwnerPlayerID == Switch.ID then -- switch
        for _,v in pairs (ts.NumArmies.SpecialUnits) do 
            if v.proxyType == "Commander" then
                Switch.Commander = ts.ID

            end
        end
        table.insert(Switch.SwitchTerr,ts.ID)
    end
   end
   -- Logic for bonus terrain
   if Bonuson == true then
    for __, TID in pairs (game.Map.Bonuses[OrigID].Territories) do 
        table.insert(boot.bootedTerr,TID)

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
function EliminateasisLogic(game,addNewOrder,OrigID,Bonuson) --- Eliminating as is
    --645468
    local boot = {} 
     boot.ID = OrigID 
    boot.Commander = 0 
    boot.bootedTerr = {} 


    local Terr = game.ServerGame.LatestTurnStanding.Territories
    table.insert(InActionAlready,OrigID)

   for _,ts in pairs(Terr)do -- getting the Territories of each player
        if ts.OwnerPlayerID == boot.ID then -- boot
            if Bonuson == false then -- bonus terrain on
                for _,v in pairs (ts.NumArmies.SpecialUnits) do 
                    if v.proxyType == "Commander" then
                        boot.Commander = ts.ID
                    end
                end
                table.insert(boot.bootedTerr,ts.ID)
            end
        end
   end
   -- Logic for bonus terrain
   if Bonuson == true then
    for __, TID in pairs (game.Map.Bonuses[OrigID].Territories) do 
        table.insert(boot.bootedTerr,TID)

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
function EliminateWasteLogic(game,addNewOrder,OrigID,Bonuson) -- Eliminate to wasteland 
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
        if Bonuson == false then -- bonus terrain on
            for _,v in pairs (ts.NumArmies.SpecialUnits) do 
                if v.proxyType == "Commander" then
                    boot.Commander = ts.ID
                end
            end
            table.insert(boot.bootedTerr,ts.ID)
        end
    end
   end
      -- Logic for bonus terrain
      if Bonuson == true then
        for __, TID in pairs (game.Map.Bonuses[OrigID].Territories) do 
            table.insert(boot.bootedTerr,TID)
    
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
function ArmiesGone(game,addNewOrder,OrigID,Bonuson) --- Remove Armies
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
        if Bonuson == false then -- bonus terrain on
            for _,v in pairs (ts.NumArmies.SpecialUnits) do 
                if v.proxyType == "Commander" then
                    boot.Commander = ts.ID
                end
            end
            table.insert(boot.bootedTerr,ts.ID)
        end
    end
   end
      -- Logic for bonus terrain
      if Bonuson == true then
        for __, TID in pairs (game.Map.Bonuses[OrigID].Territories) do 
            table.insert(boot.bootedTerr,TID)
    
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
function GoldBumpLogic(game,addNewOrder,goldbonus, cutoff) -- Gold cutoff

    local MaxGold = cutoff
    local added = goldbonus
    local standing = game.ServerGame.LatestTurnStanding
    for playerID, player in pairs(game.Game.PlayingPlayers) do
        if (not player.IsAIOrHumanTurnedIntoAI) then 

            local income = player.Income(0, standing, true, true) 
           if income.Total <= MaxGold then
            local incomeMod = WL.IncomeMod.Create(playerID, added, 'Income for balancing')
            addNewOrder(WL.GameOrderEvent.Create(playerID, "Added income " , nil, {},nil,{incomeMod}))

           else
            local incomeMod = WL.IncomeMod.Create(playerID, 1, 'Income for stats')
            addNewOrder(WL.GameOrderEvent.Create(0, "state viewing" , nil, nil,nil,{incomeMod}))
           end
        end
    end

end

function Absorb_ArmiesErasedLogic(game,addNewOrder,OrigID,NewID,Bonuson) -- Absorb than armies erased
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
        if Bonuson == false then -- bonus terrain on
            for _,v in pairs (ts.NumArmies.SpecialUnits) do 
                if v.proxyType == "Commander" then
                    boot.Commander = ts.ID
                end
            end
            table.insert(boot.bootedTerr,ts.ID)
        end

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
   -- Logic for bonus terrain
   if Bonuson == true then
    for __, TID in pairs (game.Map.Bonuses[OrigID].Territories) do 
        table.insert(boot.bootedTerr,TID)

    end
   end
--- Percent logic
   local amountTurned = Turnlogic(#boot.bootedTerr)

---------------------------------
-- Core logic
   for i,ts in pairs (boot.bootedTerr) do
    if amountTurned < i then break end
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt  = Switch.ID
    mod.SetArmiesTo = 0
    addNewOrder(WL.GameOrderEvent.Create(0, "Absorbing_ArmiesGone", nil, {mod}))
    SUDelete(Terr[ts],addNewOrder)
   end

end

function Eliminate_ArmiesGoneLogic(game,addNewOrder,OrigID,Bonuson) -- Eliminate armies erased 
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
        if Bonuson == false then -- bonus terrain on
            for _,v in pairs (ts.NumArmies.SpecialUnits) do 
                if v.proxyType == "Commander" then
                    boot.Commander = ts.ID
                end
            end
            table.insert(boot.bootedTerr,ts.ID)
        end
    end
   end
   -- Logic for bonus terrain
   if Bonuson == true then
    for __, TID in pairs (game.Map.Bonuses[OrigID].Territories) do 
        table.insert(boot.bootedTerr,TID)

    end
   end
   local amountTurned = Turnlogic(#boot.bootedTerr)

   for i,ts in pairs (boot.bootedTerr) do
    if amountTurned < i then break end
    local mod = WL.TerritoryModification.Create(ts)
    mod.SetOwnerOpt = 0
    mod.SetArmiesTo = 0
    addNewOrder(WL.GameOrderEvent.Create(0, "Eliminating", nil, {mod}))
    SUDelete(Terr[ts],addNewOrder)
   end


end

function ArmiesCut(game,addNewOrder,OrigID,Bonuson,ArmiesCut) -- Army cut
    
local boot = {} 
     boot.ID = OrigID 
    boot.Commander = 0 
    boot.bootedTerr = {} 


    local armycut = ArmiesCut
    if armycut > 100 then armycut = 100 end
    armycut = math.floor((armycut - 100) * -1)    
    local Terr = game.ServerGame.LatestTurnStanding.Territories
    table.insert(InActionAlready,OrigID)

   for _,ts in pairs(Terr)do -- getting the Territories of each player
    if ts.OwnerPlayerID == boot.ID then -- boot
        if Bonuson == false then -- bonus terrain on
            for _,v in pairs (ts.NumArmies.SpecialUnits) do 
                if v.proxyType == "Commander" then
                    boot.Commander = ts.ID
                end
            end
            table.insert(boot.bootedTerr,ts.ID)
        end
    end
   end
      -- Logic for bonus terrain
      if Bonuson == true then
        for __, TID in pairs (game.Map.Bonuses[OrigID].Territories) do 
            table.insert(boot.bootedTerr,TID)
    
        end
       end
   local amountTurned = Turnlogic(#boot.bootedTerr)

   for i,ts in pairs (boot.bootedTerr) do
    if amountTurned < i then break end
    local mod = WL.TerritoryModification.Create(ts)
    local Currentarmies = Terr[ts].NumArmies.NumArmies
     mod.SetArmiesTo = Currentarmies * (armycut / 100)
    addNewOrder(WL.GameOrderEvent.Create(0, "Armies Cut", nil, {mod}))
    SUDelete(Terr[ts],addNewOrder)
   end


end

function GoltToOne(game,addNewOrder,goldbonus, ID) -- Gold cutoff

    local added = goldbonus
    local standing = game.ServerGame.LatestTurnStanding
    for playerID, player in pairs(game.Game.PlayingPlayers) do
            
        local income = player.Income(0, standing, true, true) 
        if playerID == ID then
        local incomeMod = WL.IncomeMod.Create(playerID, added, 'Extra Income')
        addNewOrder(WL.GameOrderEvent.Create(playerID, "Added income " , nil, {},nil,{incomeMod}))

        else
        local incomeMod = WL.IncomeMod.Create(playerID, 1, 'Income for stats')
        addNewOrder(WL.GameOrderEvent.Create(0, "state viewing" , nil, nil,nil,{incomeMod}))
        end

    end

end

function Addhistory(Action,VotedBy,game,Bonuson) -- History 
    table.insert(publicdata.History,{})

    local hiss = publicdata.History[#publicdata.History]
    hiss.type = Action.Actiontype
    hiss.original = Action.OrigPlayerID
    hiss.New = Action.NewPlayerID
    hiss.createdBy = Action.playerWhoCreated
    hiss.Datapoint3 = Action.turned
    hiss.votedby = VotedBy
    hiss.ActionID = #publicdata.History
    hiss.Turn = game.Game.TurnNumber
    hiss.incomebump = Action.incomebump
    hiss.cutoff = Action.Cutoff
    hiss.Bonuson = Action.Bonus
    hiss.armycut = Action.Armycut
    hiss.goldby = Action.incomebump
end