require('Utilities')



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)
  publicdata = Mod.PublicGameData

  local type = Nonill(payload.entrytype)
  local typename = Nonill(payload.typename)
  local typecost = Nonill(payload.cost)
  local typetext = Nonill(payload.text)
  local goldhave = game.ServerGame.LatestTurnStanding.NumResources(playerID, WL.ResourceType.Gold)


       if publicdata[playerID] == nil then publicdata[playerID] = {} end
       if publicdata.Ranklist == nil then publicdata.Ranklist = {} end
       if publicdata.CardstoStop == nil then publicdata.CardstoStop = {} end
       if publicdata.id == nil then publicdata.id = 0 end
  
  
    if (goldhave < typecost) then  -- don't have enough money
      setReturnTable({ Message = "You need " .. typecost .. " gold to purchase a " .. typename .. ". you need ".. typecost - goldhave ..  " more gold to purchase this unit", Pass = false})
        return
      end
      if type < 3 then
        game.ServerGame.SetPlayerResource(playerID, WL.ResourceType.Gold, goldhave - typecost)
      end

  
    if type == 0 then -- when your buying a new agency    
      --Initing  
        print("agency created")
  
      if publicdata[playerID].Agency == nil then publicdata[playerID].Agency = {} end
      if publicdata[playerID].Agency.agencyname == nil then publicdata[playerID].Agency.agencyname = typetext end
      if publicdata[playerID].Agency.agencyrating == nil then  publicdata[playerID].Agency.agencyrating = 0 end
       if publicdata[playerID].Agency.agencyRank == nil then publicdata[playerID].Agency.agencyRank = 0 end
       if publicdata[playerID].Agency.AgencyKills == nil then publicdata[playerID].Agency.AgencyKills = 0 end
       if publicdata[playerID].Agency.Missions == nil then publicdata[playerID].Agency.Missions = 0 end
       if publicdata[playerID].Agency.successfulmissions == nil then publicdata[playerID].Agency.successfulmissions = 0 end
        if publicdata[playerID].Agency.Protectionrate == nil then  publicdata[playerID].Agency.Protectionrate = 0 end
        if publicdata[playerID].Agency.Agentlist == nil then publicdata[playerID].Agency.Agentlist = {} end
        if publicdata[playerID].Agency.Decoylist == nil then publicdata[playerID].Agency.Decoylist = {}end
        if publicdata[playerID].Agency.Infil == nil then publicdata[playerID].Agency.Infil = {}end
        if publicdata[playerID].Agency.playerID == nil then publicdata[playerID].Agency.playerID = game.Game.Players[playerID].DisplayName(nil, false) end
        

        table.insert(publicdata.Ranklist,playerID)


        setReturnTable({ Message = nil, Pass = true})

      
    elseif type == 1 then -- when you buy a decoy
      if publicdata[playerID].Agency.Decoylist[#publicdata[playerID].Agency.Decoylist + 1] == nil then 
        publicdata[playerID].Agency.Decoylist[#publicdata[playerID].Agency.Decoylist + 1]  = {} end
        local Dshort = publicdata[playerID].Agency.Decoylist[#publicdata[playerID].Agency.Decoylist]

        Dshort.type = "all"
        Dshort.PlayerID = playerID


        publicdata[playerID].Agency.agencyrating = publicdata[playerID].Agency.agencyrating + 1 -- adding for agency rating
        setReturnTable({ Message = "Decoy successfully Set up ", Pass = true})

  
  elseif type == 2 then -- when your buying a new agent
    if #publicdata[playerID].Agency.Agentlist >= 4 then setReturnTable({ Message = "The max amount of agents is 4. you have already reached that limit", Pass = false}) return end
    if publicdata[playerID].Agency.Agentlist == nil then publicdata[playerID].Agency.Agentlist = {} end
    if publicdata[playerID].Agency.Agentlist[#publicdata[playerID].Agency.Agentlist + 1] == nil then 
      publicdata[playerID].Agency.Agentlist[#publicdata[playerID].Agency.Agentlist + 1 ]  = {} end 
      local short = publicdata[playerID].Agency.Agentlist[#publicdata[playerID].Agency.Agentlist]
      
      if short.PlayerofAgentID == nil then short.PlayerofAgentID = playerID end
      if short.codename == nil then short.codename = typetext end
      if short.level == nil then short.level = 1 end
      if short.kills == nil then short.kills = 0 end
      if short.missions == nil then short.missions = 0 end
      if short.cooldownTill == nil then short.cooldownTill = Mod.Settings.Cooldown end
      if short.agentID == nil then short.agentID = publicdata.id end
      if short.missuccessfulmissionssions == nil then short.successfulmissions = 0 end -- our XP
      if short.agentHomeAgency == nil then short.agentHomeAgency = publicdata[playerID].Agency.agencyname end

      publicdata.id = publicdata.id + 1
 
      publicdata[playerID].Agency.agencyrating = publicdata[playerID].Agency.agencyrating + 1 -- 1 for agent level. agency rating
      setReturnTable({ Message = "Agent Code Name '".. short.codename .. "' successfully Trained. ", Pass = true})
   
    elseif type == 3 then -- updating cooldown

      publicdata[playerID].Agency.Agentlist[typetext].cooldownTill = game.Game.TurnNumber + Mod.Settings.Cooldown
      
    end

    Mod.PublicGameData = publicdata

end