require('Utilities')
-- addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a '.. typename .. addedwords .. addedwords2, nil,{}));

--Add decoys
--increase level for agent
function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)

	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "KillAgent")) then  
        local publicdata = Mod.PublicGameData
		local payloadSplit = split(string.sub(order.Payload, 10), ';;')
        local agenttodieID = tonumber(payloadSplit[1])
        local AgentonmissionID = tonumber(payloadSplit[2])
        local killagentPlayerID = tonumber(payloadSplit[4])
        local ID = order.PlayerID
print(killagentPlayerID)
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
print(battleresults, "battleresults")
print(publicdata[killagentPlayerID].Agency.Decoylist, "decoylist")
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
                print(#publicdata[killagentPlayerID].Agency.Decoylist, "decoylist 2")

                return
            end
            local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentIndex].codename .. " successfully assassinated agent " .. publicdata[killagentPlayerID].Agency.Agentlist[KillagentID].codename .. "\nFrom the " .. publicdata[killagentPlayerID].Agency.agencyname .. " Agency"
            addNewOrder(WL.GameOrderEvent.Create(killagentPlayerID, message))

            publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions = publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions + 1
            publicdata[ID].Agency.Agentlist[AgentIndex].missions = publicdata[ID].Agency.Agentlist[AgentIndex].missions + 1
            publicdata[ID].Agency.successfulmissions = publicdata[ID].Agency.successfulmissions + 1
            publicdata[ID].Agency.agencyrating = publicdata[ID].Agency.agencyrating + 1

            if publicdata[ID].Agency.Agentlist[AgentIndex].level < 7 then
                if publicdata[ID].Agency.Agentlist[AgentIndex].level * (publicdata[ID].Agency.Agentlist[AgentIndex].level +1 ) <= publicdata[ID].Agency.Agentlist[AgentIndex].successfulmissions then
                    publicdata[ID].Agency.Agentlist[AgentIndex].level = publicdata[ID].Agency.Agentlist[AgentIndex].level + 1
                end
            end

            --subtracting agencyrating
            publicdata[killagentPlayerID].Agency.agencyrating = publicdata[killagentPlayerID].Agency.agencyrating - publicdata[killagentPlayerID].Agency.Agentlist[KillagentID].level
            table.remove(publicdata[killagentPlayerID].Agency.Agentlist,KillagentID)
        end

        --update publicdata
        publicdata[ID].Agency.Missions = publicdata[ID].Agency.Missions + 1

        
        Mod.PublicGameData = publicdata
    end

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "Killguy")) then  
        local publicdata = Mod.PublicGameData
		local payloadSplit = split(string.sub(order.Payload, 7), ';;')
        local SelectedTerritory = tonumber(payloadSplit[1])
        local AgentID = tonumber(payloadSplit[2])

        --check the territroy for SU
        --if it has SU, then

        local battleresults = 1
        if battleresults == 0 then -- agent died

        elseif battleresults == 1 then
            
        elseif battleresults == 2 then
            
        end
        Mod.PublicGameData = publicdata
    end

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "KillCity")) then  
        local publicdata = Mod.PublicGameData
        local payloadSplit = split(string.sub(order.Payload, 8), ';;')
        local SelectedTerritory = tonumber(payloadSplit[1])
        local AgentID = tonumber(payloadSplit[2])

        local result = 1
        if results == 0 then -- agent died

        elseif result == 1 then
            
        elseif result == 2 then
            
        end
        Mod.PublicGameData = publicdata
    end

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "Killcard")) then  
        local publicdata = Mod.PublicGameData
		local payloadSplit = split(string.sub(order.Payload, 8), ';;')
        local Carddata = payloadSplit[1]
        local AgentID = tonumber(payloadSplit[2])
        local TargetplayerID = tonumber(payloadSplit[3])

        local result = 1
        if results == 0 then -- agent died

        elseif result == 1 then
            
        elseif result == 2 then
            
        end
        Mod.PublicGameData = publicdata
        end

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "Killarmy")) then  
        local publicdata = Mod.PublicGameData
		local payloadSplit = split(string.sub(order.Payload, 8), ';;'); 
        local SelectedTerritory = tonumber(payloadSplit[1])
        local AgentID = tonumber(payloadSplit[2])

        local result = 1
        if results == 0 then -- agent died

        elseif result == 1 then
            
        elseif result == 2 then
            
        end
        Mod.PublicGameData = publicdata
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
    
    if rawdata >= attacker+3 then
        results = 0
    elseif rawdata > attacker then
        results = 1
    elseif rawdata <= attacker then
        results = 2
    end
results = 2
    return results
end

function Defaultchecker(order)
    if (order.CostOpt == nil) then
        return; --shouldn't ever happen, unless another mod interferes
    end
    
end
