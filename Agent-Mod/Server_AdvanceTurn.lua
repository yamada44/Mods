require('Utilities')
-- addNewOrder(WL.GameOrderEvent.Create(order.PlayerID, 'Purchased a '.. typename .. addedwords .. addedwords2, nil,{}));


function Server_AdvanceTurn_Order(game, order, result, skipThisOrder, addNewOrder)

	if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "KillAgent")) then  
        local publicdata = Mod.PublicGameData
		local payloadSplit = split(string.sub(order.Payload, 10), ';;')
        local Killagenttarget = tonumber(payloadSplit[1])
        local AgentID = tonumber(payloadSplit[2])
        local ID = order.PlayerID
        local rivalID = publicdata.AgentRank[Killagenttarget].PlayerofAgentID
        local attacker = publicdata[ID].Agency.Agentlist[AgentID].level
print(order.Payload)
        print(AgentID)
print(Killagenttarget,"server")
        Defaultchecker(order)
        local battleresults = Combat(attacker + publicdata.AgentRank[Killagenttarget].level, attacker)
print(battleresults)
        if battleresults == 0 then -- Agent died
            local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentID].codename .. " died trying to assassinate agent " .. publicdata.AgentRank[Killagenttarget].codename
            addNewOrder(WL.GameOrderEvent.Create(rivalID, message));
            local matchid = Findmatch(publicdata.AgentRank,publicdata[ID].Agency.Agentlist[AgentID].AgentID)
            table.remove(publicdata.AgentRank,matchid)
            table.remove(publicdata[ID].Agency.Agentlist,AgentID)


        elseif battleresults == 1 then -- nothing happened
            local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentID].codename .. " failed to to assassinate agent " .. publicdata.AgentRank[Killagenttarget].codename .. "\nboth agents got away"
            addNewOrder(WL.GameOrderEvent.Create(rivalID, message)); 
       
        elseif battleresults == 2 then -- kill target was eliminated
print("battleresults",battleresults,Killagenttarget,publicdata.AgentRank[Killagenttarget].agentID,publicdata.AgentRank[Killagenttarget].level)
            local message = "Agent " .. publicdata[ID].Agency.Agentlist[AgentID].codename .. " successfully assassinated agent " .. publicdata.AgentRank[Killagenttarget].codename
            addNewOrder(WL.GameOrderEvent.Create(rivalID, message));
            local matchid = Findmatch(publicdata[rivalID].Agency.Agentlist,publicdata.AgentRank[Killagenttarget].agentID)

            table.remove(publicdata.AgentRank,Killagenttarget)
            table.remove(publicdata[rivalID].Agency.Agentlist,matchid)
        end
        --do Combat
        --win:remove agent, lose:nothing, critical win:agent dies
        --update publicdata

        Mod.PublicGameData = publicdata
    end

    if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, "Killguy")) then  
        local publicdata = Mod.PublicGameData
		local payloadSplit = split(string.sub(order.Payload, 7), ';;')
        local SelectedTerritory = tonumber(payloadSplit[1])
        local AgentID = tonumber(payloadSplit[2])

        local result = 1
        if results == 0 then -- agent died

        elseif result == 1 then
            
        elseif result == 2 then
            
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

    return results
end

function Defaultchecker(order)
    if (order.CostOpt == nil) then
        return; --shouldn't ever happen, unless another mod interferes
    end
    
end
function Findmatch(findtable, match)
    for i = 1, #findtable do
        if findtable[i].AgentID == match then
            print(match, i, "match")
            return i

        end 
    end
end