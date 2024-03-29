require('Utilities')

function Server_AdvanceTurn_Start(game, addNewOrder)
  Game2 = game
--[[
  if order.proxyType == "GameOrderAttackTransfer" then 
    --for _,terr in pairs (game.Map.Territories)do
      terr = game.Map.Territories[1]
      print(terr.ConnectedTo)
      for i,v in pairs (terr.ConnectedTo)do
        print(game.Map.Territories[game.Map.Territories[i].ID].Name)
      --PlayerID
      end
   -- end

   
  end]]


  if Mod.Settings.CityGone > 0 then
    for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do 
      if Slotchecker(ts.OwnerPlayerID ) then  
          if ts.Structures ~= nil and ts.Structures[WL.StructureType.City] ~= nil and ts.Structures[WL.StructureType.City] > 0 then
          local mod = WL.TerritoryModification.Create(ts.ID)
          local struc = {}
          local citiesremoved = Mod.Settings.CityGone
          if ts.Structures[WL.StructureType.City] < Mod.Settings.CityGone then citiesremoved = ts.Structures[WL.StructureType.City] end
          struc[WL.StructureType.City] = citiesremoved * -1
          mod.AddStructuresOpt = struc
          addNewOrder(WL.GameOrderEvent.Create(ts.OwnerPlayerID, 'The City in '.. game.Map.Territories[ts.ID].Name ..' fell to ruin by '.. citiesremoved , nil, {mod}))
          end
      end
    end
  end

end

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)
  Game2 = game

  if order.proxyType == "GameOrderAttackTransfer" and result.IsAttack and Mod.Settings.TConv ~= 0 then 
    local attackerZom = Slotchecker(game.ServerGame.LatestTurnStanding.Territories[order.From].OwnerPlayerID) 
    local defenderZom = Slotchecker(game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID) 
    local troopgain = true

  

    if attackerZom == true or defenderZom == true then

      --Checking to see if Fort Tactics Fort is there and if the zombies are attacking it. if so, then increase attack amount by 1
      local priv = Mod.PublicGameData
      local structure = game.ServerGame.LatestTurnStanding.Territories[order.To].Structures
      if (attackerZom == true and structure ~= nil and structure[WL.StructureType.MercenaryCamp] ~=  nil and structure[WL.StructureType.MercenaryCamp] > 0) then  
        priv = FortLogic(priv,order.To,order.PlayerID)
      end
      Mod.PublicGameData = priv
      

      --Running through attacking rules.
      if game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID == 0 then -- make sure its neutral
        
        if Mod.Settings.Attack == 2 then -- cannot attack any neutrals
          troopgain = false
        skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
        elseif Mod.Settings.Attack == 3 then -- cannot 
        troopgain = false
        elseif Mod.Settings.Attack > 3 then
        local armies = game.ServerGame.LatestTurnStanding.Territories[order.To].NumArmies.NumArmies 
          if armies == Mod.Settings.Attack or armies == 0 then
          skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
          troopgain = false
          end
       end
      end

    --Attacking for zombies
      if troopgain then
        if attackerZom == true then
        --  local SUdamage = SUdamageCal(order,result.ActualArmies.SpecialUnits,result.AttackingArmiesKilled.SpecialUnits)
          local newzombies = result.DefendingArmiesKilled.DefensePower * (Mod.Settings.TConv / 100)
          local land = game.Map.Territories[order.From]
          local zomland = 0
          for i,v in pairs (land.ConnectedTo) do 
            if game.ServerGame.LatestTurnStanding.Territories[game.Map.Territories[i].ID].OwnerPlayerID == game.ServerGame.LatestTurnStanding.Territories[order.From].OwnerPlayerID then
            zomland = zomland + 1
            end
          end
          if zomland == 0 then 
            -- check if the attack failed
            local mod = WL.TerritoryModification.Create(game.ServerGame.LatestTurnStanding.Territories[order.From].ID)
            mod.AddArmies = newzombies
            addNewOrder(WL.GameOrderEvent.Create(game.ServerGame.LatestTurnStanding.Territories[order.From].OwnerPlayerID, "killed forces absorbed into ranks", {}, {mod}))
            goto next end
          local placedZomb = math.ceil(newzombies / zomland) 
          local totalzoms = 0
          local modtable = {}
          for i,v in pairs (land.ConnectedTo) do 
            if game.ServerGame.LatestTurnStanding.Territories[game.Map.Territories[i].ID].OwnerPlayerID == game.ServerGame.LatestTurnStanding.Territories[order.From].OwnerPlayerID then
              
              local mod = WL.TerritoryModification.Create(i)
              mod.AddArmies = placedZomb
              table.insert(modtable,mod)
              totalzoms = totalzoms + placedZomb
              if totalzoms >= newzombies then break end
            end
          end
          addNewOrder(WL.GameOrderEvent.Create(game.ServerGame.LatestTurnStanding.Territories[order.From].OwnerPlayerID, "killed forces absorbed into ranks", {}, modtable))

  -- Defending for zombies
        elseif defenderZom == true then
          local newzombies = result.AttackingArmiesKilled.AttackPower * (Mod.Settings.TConv / 100)
          local land = game.Map.Territories[order.To]
          local zomland = 0
          for i,v in pairs (land.ConnectedTo) do 
            if game.ServerGame.LatestTurnStanding.Territories[game.Map.Territories[i].ID].OwnerPlayerID == game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID then
            zomland = zomland + 1
            end
          end
          if zomland == 0 then 
            -- check if the attack failed
            if result.IsSuccessful == false then 
            local mod = WL.TerritoryModification.Create(game.ServerGame.LatestTurnStanding.Territories[order.To].ID)
            mod.AddArmies = newzombies
            addNewOrder(WL.GameOrderEvent.Create(game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID, "killed forces absorbed into ranks", {}, {mod}))
            goto next end end
          local placedZomb = math.ceil(newzombies / zomland) 
          local totalzoms = 0
          local modtable = {}
          for i,v in pairs (land.ConnectedTo) do 
            if game.ServerGame.LatestTurnStanding.Territories[game.Map.Territories[i].ID].OwnerPlayerID == game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID then
              
              local mod = WL.TerritoryModification.Create(i)
              mod.AddArmies = placedZomb
              table.insert(modtable,mod)
              totalzoms = totalzoms + placedZomb
              if totalzoms >= newzombies then break end
            end
          end
          addNewOrder(WL.GameOrderEvent.Create(game.ServerGame.LatestTurnStanding.Territories[order.To].OwnerPlayerID, "killed forces absorbed into ranks", {}, modtable))
      
        end
      end
    end
      ::next::

  end
  if Slotchecker(order.PlayerID) then    

    print(order.proxyType, "orderproxy")
    --No certain cards
    if(string.find(order.proxyType, "GameOrderPlayCard") ~= nil)then
    
      if order.proxyType == "GameOrderPlayCardAirlift" and Mod.Settings.PlayAir == false then
        skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
      end
      if order.proxyType == "GameOrderPlayCardDiplomacy" and Mod.Settings.PlayDip == false then
        skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
      end
      if order.proxyType == "GameOrderPlayCardSanctions" and Mod.Settings.PlaySan == false then
        skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
      end
      if order.proxyType == "GameOrderPlayCardReinforcement" and Mod.Settings.PlayRef == false then
        skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
      end
    end
    -- No cities
    if order.proxyType == "GameOrderPurchase" and Mod.Settings.Nocities == false then
      skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
    end
    --No deployment
    if order.proxyType == "GameOrderDeploy" and Mod.Settings.TDep > 1 then 
        local build = game.ServerGame.LatestTurnStanding.Territories[order.DeployOn].Structures
        if Mod.Settings.TDep == 3 then 
          skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
        elseif Mod.Settings.TDep == 2 and (build == nil or build[Mod.Settings.StructureType] == 0)  then
          skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
        end
    end
end
  


  if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "Zom")) then  --look for the order that we inserted in Client_PresentCommercePurchaseUI
    
    print (order.Payload, 'payload')	
    local publicdata = Mod.PublicGameData

    --Payload
    local payloadSplit = split(string.sub(order.Payload, 4), ';;')
    local targetTerritoryID = tonumber(payloadSplit[1])

    local numUnitsAlreadyHave = 0;
    for _,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do -- server side check to make sure builds are not above the Given amount

      if(ts.OwnerPlayerID == order.PlayerID) then
        numUnitsAlreadyHave = numUnitsAlreadyHave + Buildnumber(ts.Structures)
      end
    end
    if numUnitsAlreadyHave > Mod.Settings.Maxhives then 
      addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Already at Max Structure limit. cannot build'))
      skipThisOrder(WL.ModOrderControl.SkipAndSupressSkippedMessage)
      return
    end
    local mod = WL.TerritoryModification.Create(targetTerritoryID)
    local struc = {}

    struc[Mod.Settings.StructureType] = 1
    mod.AddStructuresOpt = struc

    
    addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a Building' , nil, {mod}))
    

  end
end

function Server_AdvanceTurn_End(game, addNewOrder)
 
  
  --[[
    local publicdata = Mod.PublicGameData
    --local playergroup = {}
    local goldhave
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
            addNewOrder(WL.GameOrderEvent.Create(playerID, "Added income " , nil, {},nil,{incomeMod}));
            --game.ServerGame.SetPlayerResource(playerID, WL.ResourceType.Gold, goldhave + 100)
            --
           end
        end
    end



  --game.Settings.CustomScenario.SlotsAvailable
        

Mod.PublicGameData = publicdata]]
end
function Slotchecker(playerid)
  if playerid == 0 or playerid == nil then return false end
  local issame = false

	for i = 1, #Mod.Settings.Slot do
		if Mod.Settings.Slot[i] == Game2.Game.PlayingPlayers[playerid].Slot then 
			issame = true
		end end

      return issame
end

function SUdamageCal(order,SU,deathSU)
  local totaldamage
  local notdeadyetSU = {}

  for i,v in pairs(SU)do

    for i2, v2 in pairs(deathSU) do -- checking to see if he died
      if SU.ID == deathSU then end
    end
  end


return totaldamage
end

function RemoveFort(game, addNewOrder)
	--Build any forts that we queued in up Server_AdvanceTurn_Order
	
	local priv = Mod.PublicGameData
	if priv.PendingForts == nil then return end
for i = 1, (priv.PendingForts) do
	local pending = priv.PendingForts[i]
	if (pending == nil) then return end
  if pending.Attackcount >= Mod.Settings.Fort then
    local message = "Fort destroyed by repeated attacks"

    -- We will now build a fort for each pending fort.  However, we need to take care to ensure that if there are two build orders for the same territory that we build both of them, so we first group by the territory ID so we get all build orders for the same territory together.
    local mod = WL.TerritoryModification.Create(pending.TerritoryID)
    local struc = {}
    struc[WL.StructureType.MercenaryCamp] = -1
    mod.AddStructuresOpt = struc
    
    addNewOrder(WL.GameOrderEvent.Create(pending.PlayerID, message, nil, {mod}))
    table.remove(priv.PendingForts,i)
    i = i - 1
  end

end
--remove logic

	Mod.PublicGameData = priv
	
end

function FortLogic(priv,To,PlayerID)
  if priv == nil then priv = {} end
  if priv.pendingFort == nil then priv.PendingForts = {} end
  if priv.PendingForts[To] ==  nil then  -- have attacked before
    priv.PendingForts[To] = {}
    priv.pendingFort[To].Attackcount = priv.pendingFort.Attackcount + 1  
  else -- attack from zoms here
    priv.pendingFort[To].PlayerID = PlayerID
    priv.pendingFort[To].TerritoryID = To
    priv.pendingFort[To].Attackcount = 1

  end
return priv
end