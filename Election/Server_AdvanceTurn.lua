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

            -- change voting for group functions
            -- change time needed 

            Addhistory(publicdata.Action[i],percentVote,game)
            table.remove(publicdata.Action,i) -- remove Vote

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