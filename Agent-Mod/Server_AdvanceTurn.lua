require('Utilities')
-- addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a '.. typename .. addedwords .. addedwords2, nil,{}));

function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)

	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "KillAgent")) then  
        local publicdata = Mod.PublicGameData
		local payloadSplit = split(string.sub(order.Payload, 10), ';;')
        local agenttodieID = tonumber(payloadSplit[1])
        local AgentonmissionID = tonumber(payloadSplit[2])
        local killagentPlayerID = tonumber(payloadSplit[4])
        local ID = order.PlayerID

        --getting proper indexes for tables
        local KillagentID = Findmatch(publicdata[killagentPlayerID].Agency.Agentlist,agenttodieID,"agentID")  
        if KillagentID == nil then -- if the kill target is already dead, cancel Operation
            addNewOrder(WL.GameOrderEvent.Create(ID, "Operation canceled. 1 or more agents apart of this mission are already dead", {}, {})) return   end
            
        local AgentIndex = Findmatch(publicdata[ID].Agency.Agentlist  ,  AgentonmissionID,"agentID")
        if AgentIndex == nil then -- if the agent is already dead, cancel Operation
            addNewOrder(WL.GameOrderEvent.Create(ID, "Operation canceled. 1 or more agents apart of this mission are already dead", {}, {}))            
                return end
         

        local attacker = publicdata[ID].Agency.Agentlist[AgentIndex].level

        Defaultchecker(order)
        local battleresults = Combat(attacker + publicdata[killagentPlayerID].Agency.Agentlist[KillagentID].level, attacker)

        if battleresults == 0 then -- Agent died
            local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " died trying to assassinate agent " .. publicdata[killagentPlayerID].Agency.Agentlist[KillagentID].codename .. "\nAttempt From: ".. publicdata[ID].Agency.agencyname .. " Agency"
            addNewOrder(WL.GameOrderEvent.Create(killagentPlayerID, message));
           
            table.remove(publicdata[ID].Agency.Agentlist,AgentIndex)

        elseif battleresults == 1 then -- nothing happened
            local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " failed to assassinate agent " .. publicdata[killagentPlayerID].Agency.Agentlist[KillagentID].codename .. "\nboth agents got away"
            addNewOrder(WL.GameOrderEvent.Create(killagentPlayerID, message)); 
            publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1
       
        elseif battleresults == 2 then -- kill target was eliminated

            if #publicdata[killagentPlayerID].Agency.Decoylist > 0 then
                local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " assassinated Decoy instead of agent " .. publicdata[killagentPlayerID].Agency.Agentlist[KillagentID].codename
                addNewOrder(WL.GameOrderEvent.Create(killagentPlayerID, message))
                table.remove(publicdata[killagentPlayerID].Agency.Decoylist,1)

            
            else 
                local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " successfully assassinated agent " .. publicdata[killagentPlayerID].Agency.Agentlist[KillagentID].codename .. "\nFrom the " .. publicdata[killagentPlayerID].Agency.agencyname .. " Agency"
                addNewOrder(WL.GameOrderEvent.Create(killagentPlayerID, message))

                publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions = publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions + 1
                publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1
                publicdata[ID].Agency.successfulmissions = publicdata[ID].Agency.successfulmissions + 1
                publicdata[ID].Agency.agencyrating = publicdata[ID].Agency.agencyrating + 1

                if publicdata[ID].Agency.Agentlist[AgentIndex].level < 7 then
                    if publicdata[ID].Agency.Agentlist[AgentIndex].level * (publicdata[ID].Agency.Agentlist[AgentIndex].level+1 ) <= publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions then
                        publicdata[ID].Agency.Agentlist[AgentIndex].level = publicdata[ID].Agency.Agentlist[AgentIndex].level + 1
                        publicdata[ID].Agency.agencyrating = publicdata[ID].Agency.agencyrating + 1
                    end
                end

                --subtracting agencyrating
                publicdata[killagentPlayerID].Agency.agencyrating = publicdata[killagentPlayerID].Agency.agencyrating - publicdata[killagentPlayerID].Agency.Agentlist[KillagentID].level
                table.remove(publicdata[killagentPlayerID].Agency.Agentlist,KillagentID)
            end
        end

        --update publicdata
        publicdata[ID].Agency.Missions = publicdata[ID].Agency.Missions + 1

        Mod.PublicGameData = publicdata
    end

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "Killguy")) then  
        local publicdata = Mod.PublicGameData
		local payloadSplit = split(string.sub(order.Payload, 8), ';;')
        local SelectedTerritory = tonumber(payloadSplit[1])
        local AgentonmissionID = tonumber(payloadSplit[2])
        local ID = order.PlayerID
        local combatvalue = -2
        local builder = nil
        local t = {}

        local AgentIndex = Findmatch(publicdata[ID].Agency.Agentlist  ,  AgentonmissionID,"agentID")
        if AgentIndex == nil then -- if the agent is already dead, cancel Operation
            addNewOrder(WL.GameOrderEvent.Create(ID, "Operation canceled. 1 or more agents apart of this mission are already dead", {}, {}))            
                return end
        local attacker = publicdata[ID].Agency.Agentlist[AgentIndex].level

        local ts = game.ServerGame.LatestTurnStanding.Territories[SelectedTerritory]

            for i,v in pairs (ts.NumArmies.SpecialUnits)do -- search this territroy and see if it has a speical unit


                if v.proxyType == "CustomSpecialUnit" then
                    table.insert(t, v.ID);
                    builder = WL.CustomSpecialUnitBuilder.CreateCopy(v)
                    combatvalue = 1

                    if v.ModData ~= nil then -- 

                        if startsWith(v.ModData, "C&P") then -- make sure the speical unit is only from I.S. mods
                            local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
                            combatvalue = tonumber(Nonill(payloadSplit[9]))

                            if combatvalue == 0 then -- check if this unit has expired in life, if yes, then destroy it
                                combatvalue = -1
                                
                            end
                            break
                        end
                    end
                end
            end
            

        if combatvalue >= 0 and builder ~= nil then
            
            local battleresults = Combat(attacker + combatvalue, attacker)
            

            if battleresults == 0 then -- agent died
                local TempNameOverHead = "a "
                if builder.TextOverHeadOpt ~= nil then
                    TempNameOverHead = builder.TextOverHeadOpt .. " the "
                end
                local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " died trying to Eliminate " .. TempNameOverHead .. builder.Name .. "\nAttempt From: ".. publicdata[ID].Agency.agencyname .. " Agency"
                addNewOrder(WL.GameOrderEvent.Create(ts.OwnerPlayerID, message));
               
                table.remove(publicdata[ID].Agency.Agentlist,AgentIndex)
    
            elseif battleresults == 1 then -- nothing happens
                local TempNameOverHead = "a "
                if builder.TextOverHeadOpt ~= nil then
                    TempNameOverHead = builder.TextOverHeadOpt .. " the "
                end
                local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " failed to eliminate " .. TempNameOverHead .. builder.Name  .. "\nagent and target got away"
                addNewOrder(WL.GameOrderEvent.Create(ts.OwnerPlayerID, message)); 
                publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1
           
            elseif battleresults == 2 then -- mission complete
                local TempNameOverHead = "a "
                if builder.TextOverHeadOpt ~= nil then
                    TempNameOverHead = builder.TextOverHeadOpt .. " the "
                end
                if publicdata[ts.OwnerPlayerID] ~= nil and #publicdata[ts.OwnerPlayerID].Agency.Decoylist > 0 then
                    local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " eliminated a Decoy " .. builder.Name .. " instead of his target"
                    addNewOrder(WL.GameOrderEvent.Create(ts.OwnerPlayerID, message))
                    table.remove(publicdata[ts.OwnerPlayerID].Agency.Decoylist,1)

                
                else 
                    local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " successfully eliminated " .. TempNameOverHead .. builder.Name .. " in " .. game.Map.Territories[SelectedTerritory].Name

    
                    --adding to tables for database
                    publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions = publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions + 1
                    publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1
                    publicdata[ID].Agency.successfulmissions = publicdata[ID].Agency.successfulmissions + 1

    
                    if publicdata[ID].Agency.Agentlist[AgentIndex].level < 7 then -- leveling up
                        if publicdata[ID].Agency.Agentlist[AgentIndex].level * (publicdata[ID].Agency.Agentlist[AgentIndex].level+1 ) <= publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions then
                            publicdata[ID].Agency.Agentlist[AgentIndex].level = publicdata[ID].Agency.Agentlist[AgentIndex].level + 1
                            publicdata[ID].Agency.agencyrating = publicdata[ID].Agency.agencyrating + 1
                        end
                    end
    
                    --removing SU from territroy
                    local mod = WL.TerritoryModification.Create(ts.ID)

                    mod.RemoveSpecialUnitsOpt = t
                    addNewOrder(WL.GameOrderEvent.Create(ts.OwnerPlayerID, message, nil, {mod}))

                end
            end

            publicdata[ID].Agency.agencyrating = publicdata[ID].Agency.agencyrating + 1
            publicdata[ID].Agency.Missions = publicdata[ID].Agency.Missions + 1
        else 
            local message = "No unit found"
            if combatvalue == -1 then   message = "Unit cannot be destroy/killed via assassination" end
            addNewOrder(WL.GameOrderEvent.Create(ID, message, {}, {}))

        end


        Mod.PublicGameData = publicdata
    end

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "KillCity")) then  
        local publicdata = Mod.PublicGameData
        local payloadSplit = split(string.sub(order.Payload, 9), ';;')
        local SelectedTerritory = tonumber(payloadSplit[1])
        local AgentonmissionID = tonumber(payloadSplit[2])
        local ID = order.PlayerID
        local modifier = 2
        local citiesToRemove = Mod.Settings.Citylost

        local terr = game.ServerGame.LatestTurnStanding.Territories[SelectedTerritory] -- Making sure it has cities
        local Cities = terr.Structures;
        if (Cities == nil) then 
            addNewOrder(WL.GameOrderEvent.Create(ID, "Operation canceled. No cities found", {}, {})) return   end

            local AgentIndex = Findmatch(publicdata[ID].Agency.Agentlist  ,  AgentonmissionID,"agentID") -- Getting Agents Index
            if AgentIndex == nil then -- if the agent is already dead, cancel Operation
                addNewOrder(WL.GameOrderEvent.Create(ID, "Operation canceled. This agent is already dead", {}, {}))            
                    return end
            local attacker = publicdata[ID].Agency.Agentlist[AgentIndex].level


    -- getting average power of agency
        local totalpower = 0
        if publicdata[terr.OwnerPlayerID] ~= nil and #publicdata[terr.OwnerPlayerID].Agency.Agentlist > 0 then
            for i,v in pairs (publicdata[terr.OwnerPlayerID].Agency.Agentlist) do
                totalpower = totalpower + v.level
        end
    else 
        totalpower = modifier
    end

        totalpower = (totalpower / #publicdata[terr.OwnerPlayerID].Agency.Agentlist ) + modifier
            local battleresults = Combat(attacker + totalpower, attacker)
            local name = "Neutral"

            if terr.OwnerPlayerID ~= 0 then name = game.Game.Players[terr.OwnerPlayerID].DisplayName(nil,false) end
            if battleresults == 0 then -- agent died

                local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " died trying to Sabotage " .. name .. "'s' cities" .. "\nAttempt From: ".. publicdata[ID].Agency.agencyname .. " Agency"
                addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID, message));
               
                table.remove(publicdata[ID].Agency.Agentlist,AgentIndex)
    
            elseif battleresults == 1 then -- nothing happens

                local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " failed trying to Sabotage " .. name .. " cities's\nAgent got away" 
                addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID, message)); 
                publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1
           
            elseif battleresults == 2 then -- mission complete

                if publicdata[terr.OwnerPlayerID] ~= nil and #publicdata[terr.OwnerPlayerID].Agency.Decoylist > 0 then
                    local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " was intercepted in his plan to Sabotage a city by a Decoy\nAgent got away"
                    addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID, message))
                    table.remove(publicdata[terr.OwnerPlayerID].Agency.Decoylist,1)

                
                else 
                    local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " successfully Sabotaged " .. name .. "'s' city in " .. game.Map.Territories[SelectedTerritory].Name

    
                    --adding to tables for database
                    publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions = publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions + 1
                    publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1
                    publicdata[ID].Agency.successfulmissions = publicdata[ID].Agency.successfulmissions + 1

    
                    if publicdata[ID].Agency.Agentlist[AgentIndex].level < 7 then -- leveling up
                        if publicdata[ID].Agency.Agentlist[AgentIndex].level * (publicdata[ID].Agency.Agentlist[AgentIndex].level+1 ) <= publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions then
                            publicdata[ID].Agency.Agentlist[AgentIndex].level = publicdata[ID].Agency.Agentlist[AgentIndex].level + 1
                            publicdata[ID].Agency.agencyrating = publicdata[ID].Agency.agencyrating + 1
                        end
                    end
    
                    --removing SU from territroy
                    local bottom0 = Cities[WL.StructureType.City] - citiesToRemove
                    if bottom0 < 0 then bottom0 = 0 end
                    Cities[WL.StructureType.City] = bottom0
                  
                    local mod = WL.TerritoryModification.Create(SelectedTerritory)
                    mod.SetStructuresOpt = Cities
                    addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID, message, nil, {mod}))

                end
            end

            publicdata[ID].Agency.agencyrating = publicdata[ID].Agency.agencyrating + 1
            publicdata[ID].Agency.Missions = publicdata[ID].Agency.Missions + 1

        Mod.PublicGameData = publicdata
    end

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "Killcard")) then  
        local publicdata = Mod.PublicGameData
		local payloadSplit = split(string.sub(order.Payload, 9), ';;')
        local Carddata = payloadSplit[1]
        local AgentonmissionID = tonumber(payloadSplit[2])
        local TargetplayerID = tonumber(payloadSplit[3])
        local ID = order.PlayerID
        local modifier = 2
        local AgentIndex = Findmatch(publicdata[ID].Agency.Agentlist  ,  AgentonmissionID,"agentID") -- Getting Agents Index
        if AgentIndex == nil then -- if the agent is already dead, cancel Operation
            addNewOrder(WL.GameOrderEvent.Create(ID, "Operation canceled. This agent is already dead", {}, {}))            
                return end
        local attacker = publicdata[ID].Agency.Agentlist[AgentIndex].level
        local cardtable = CardData(0)
        local cardname = "No name found"
        for i,v in pairs(cardtable)do
            if v == Carddata then cardname = i break end
        end
        if cardname == "Bomb" or cardname == "Sanctions" or cardname == "Diplomacy" or cardname == "Airlift" then modifier = 3 end -- diplos, sanctions, and airlifts are harder
--end of Init variables

            --- logic to get powerlevel of player
        local totalpower = 0
            if publicdata[TargetplayerID] ~= nil and #publicdata[TargetplayerID].Agency.Agentlist > 0 then
                for i,v in pairs (publicdata[TargetplayerID].Agency.Agentlist) do
                    totalpower = totalpower + v.level
                end
                totalpower = (totalpower / #publicdata[TargetplayerID].Agency.Agentlist ) + modifier
            else 
            totalpower = modifier
            end

print(totalpower,"total")
        local battleresults = Combat(attacker + totalpower, attacker)
        local name = "Neutral"
        if TargetplayerID ~= 0 then name = game.Game.Players[TargetplayerID].DisplayName(nil,false) end
        if battleresults == 0 then -- agent died

            local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " died trying to Sabotage " .. name .. "'s influence(cards)" .. "\nAttempt From: ".. publicdata[ID].Agency.agencyname .. " Agency"
            addNewOrder(WL.GameOrderEvent.Create(TargetplayerID, message));
        
            table.remove(publicdata[ID].Agency.Agentlist,AgentIndex)

        elseif battleresults == 1 then -- nothing happens

            local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " failed trying to Sabotage " .. name .. "'s influence(cards)\nAgent got away" 
            addNewOrder(WL.GameOrderEvent.Create(TargetplayerID, message)); 
            publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1

        elseif battleresults == 2 then -- mission complete

            if publicdata[TargetplayerID] ~= nil and #publicdata[TargetplayerID].Agency.Decoylist > 0 then
                local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " was intercepted in his plan to Sabotage " .. name .. "'s influence(cards) by a Decoy\nAgent got away"
                addNewOrder(WL.GameOrderEvent.Create(TargetplayerID, message))
                table.remove(publicdata[TargetplayerID].Agency.Decoylist,1)

            
            else 
                local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " successfully Sabotaged " .. name .. "'s political influence" .. "("..cardname.." card)"

                --adding to tables for database
                publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions = publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions + 1
                publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1
                publicdata[ID].Agency.successfulmissions = publicdata[ID].Agency.successfulmissions + 1


                if publicdata[ID].Agency.Agentlist[AgentIndex].level < 7 then -- leveling up
                    if publicdata[ID].Agency.Agentlist[AgentIndex].level * (publicdata[ID].Agency.Agentlist[AgentIndex].level+1 ) <= publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions then
                        publicdata[ID].Agency.Agentlist[AgentIndex].level = publicdata[ID].Agency.Agentlist[AgentIndex].level + 1
                        publicdata[ID].Agency.agencyrating = publicdata[ID].Agency.agencyrating + 1
                    end
                end

                --removing Armies from territroy

                table.insert(publicdata.CardstoStop,{})

                publicdata.CardstoStop[#publicdata.CardstoStop].orderproxy = Carddata
                publicdata.CardstoStop[#publicdata.CardstoStop].agentname = publicdata[ID].Agency.Agentlist[AgentIndex].codename
                publicdata.CardstoStop[#publicdata.CardstoStop].message = message
                publicdata.CardstoStop[#publicdata.CardstoStop].TargetplayerID = TargetplayerID
                publicdata.CardstoStop[#publicdata.CardstoStop].Cardname = cardname
                publicdata.CardstoStop[#publicdata.CardstoStop].PlayerID = ID
                publicdata.CardstoStop[#publicdata.CardstoStop].targetplayername = game.Game.Players[TargetplayerID].DisplayName(nil,false)
                addNewOrder(WL.GameOrderEvent.Create(ID, "Card Mission successful",{},nil))


            end
        end
        Mod.PublicGameData = publicdata
        end

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "Killarmy")) then  -- killing army orders
        local publicdata = Mod.PublicGameData
		local payloadSplit = split(string.sub(order.Payload, 9), ';;'); 
        local SelectedTerritory = tonumber(payloadSplit[1])
        local AgentonmissionID = tonumber(payloadSplit[2])
        local ID = order.PlayerID
        local ArmiesToRemove = Mod.Settings.ArmiesLost
        local armyModifier  = 2
        local AgentIndex = Findmatch(publicdata[ID].Agency.Agentlist  ,  AgentonmissionID,"agentID") -- Getting Agents Index
        if AgentIndex == nil then -- if the agent is already dead, cancel Operation
            addNewOrder(WL.GameOrderEvent.Create(ID, "Operation canceled. This agent is already dead", {}, {}))            
                return end
        local attacker = publicdata[ID].Agency.Agentlist[AgentIndex].level

        local terr = game.ServerGame.LatestTurnStanding.Territories[SelectedTerritory]


    -- getting average power of agency
            --- logic to get powerlevel of player
            local totalpower = 0
            if publicdata[terr.OwnerPlayerID] ~= nil and #publicdata[terr.OwnerPlayerID].Agency.Agentlist > 0 then
                for i,v in pairs (publicdata[terr.OwnerPlayerID].Agency.Agentlist) do
                    totalpower = totalpower + v.level
                end
                totalpower = (totalpower / #publicdata[terr.OwnerPlayerID].Agency.Agentlist ) + armyModifier
            else 
            totalpower = armyModifier
            end


    local battleresults = Combat(attacker + totalpower, attacker)
    local name = "Neutral"

    if terr.OwnerPlayerID ~= 0 then name = game.Game.Players[terr.OwnerPlayerID].DisplayName(nil,false) end
    if battleresults == 0 then -- agent died

        local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " died trying to Sabotage " .. name .. "'s army logistics" .. "\nAttempt From: ".. publicdata[ID].Agency.agencyname .. " Agency"
        addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID, message));
       
        table.remove(publicdata[ID].Agency.Agentlist,AgentIndex)

    elseif battleresults == 1 then -- nothing happens

        local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " failed trying to Sabotage " .. name .. "'s amy logistics\nAgent got away" 
        addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID, message)); 
        publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1
   
    elseif battleresults == 2 then -- mission complete

        if publicdata[terr.OwnerPlayerID] ~= nil and #publicdata[terr.OwnerPlayerID].Agency.Decoylist > 0 then
            local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " was intercepted in his plan to Sabotage army logistics by a Decoy\nAgent got away"
            addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID, message))
            table.remove(publicdata[terr.OwnerPlayerID].Agency.Decoylist,1)

        
        else 
            local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " successfully Sabotaged " .. name .. "'s army logistics in " .. game.Map.Territories[SelectedTerritory].Name


            --adding to tables for database
            publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions = publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions + 1
            publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1
            publicdata[ID].Agency.successfulmissions = publicdata[ID].Agency.successfulmissions + 1


            if publicdata[ID].Agency.Agentlist[AgentIndex].level < 7 then -- leveling up
                if publicdata[ID].Agency.Agentlist[AgentIndex].level * (publicdata[ID].Agency.Agentlist[AgentIndex].level+1 ) <= publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions then
                    publicdata[ID].Agency.Agentlist[AgentIndex].level = publicdata[ID].Agency.Agentlist[AgentIndex].level + 1
                    publicdata[ID].Agency.agencyrating = publicdata[ID].Agency.agencyrating + 1
                end
            end

            --removing Armies from territroy
            local armies = terr.NumArmies.NumArmies
            local bottom0 = armies - ArmiesToRemove
            if bottom0 < 0 then bottom0 = 0 end
            local mod = WL.TerritoryModification.Create(SelectedTerritory)
            mod.SetArmiesTo = bottom0

            addNewOrder(WL.GameOrderEvent.Create(terr.OwnerPlayerID, message, nil, {mod}))

        end
    end

    publicdata[ID].Agency.agencyrating = publicdata[ID].Agency.agencyrating + 1
    publicdata[ID].Agency.Missions = publicdata[ID].Agency.Missions + 1
        Mod.PublicGameData = publicdata
        end

        if(string.find(order.proxyType, "GameOrderPlayCard") ~= nil)then
            local publicdata = Mod.PublicGameData

            for i = 1, #publicdata.CardstoStop do
                if order.PlayerID == publicdata.CardstoStop[i].TargetplayerID then
                    if(order.proxyType == publicdata.CardstoStop[i].orderproxy)then
                        local message = publicdata.CardstoStop[i].message
                        addNewOrder(WL.GameOrderEvent.Create(publicdata.CardstoStop[i].TargetplayerID, message,nil,nil))
                        table.remove(publicdata.CardstoStop,i)
                        skipThisOrder(WL.ModOrderControl.Skip)
                        Mod.PublicGameData = publicdata
                        break

                    end
                end
            end

        end
end
-- 0: death of attacking agent
-- 1: nothing happen
-- 2:success of attacking agent
--attacker is the lower side of the total
function Combat(total, attacker)
    
    local results = 0

    local rawdata = math.random(1,total)

    print(total,attacker,rawdata)
    
    if rawdata >= attacker+2 then
        results = 0
    elseif rawdata > attacker then
        results = 1
    elseif rawdata <= attacker then
        results = 2
    end

    return results
end

function Defaultchecker(order)
    if (order.CostOpt == nil) then
        return; --shouldn't ever happen, unless another mod interferes
    end
    
end
