



function Server_GameCustomMessage(game, playerID, payload, setReturnTable)
  local type = payload.entrytype
  local typename = payload.typename
  local typecost = payload.cost
  local typetext = payload.text
  local goldhave = game.ServerGame.LatestTurnStanding.NumResources(playerID, WL.ResourceType.Gold)
   publicdata = Mod.PublicGameData
       if publicdata[playerID] == nil then publicdata[playerID] = {} end
       if publicdata.Ranklist == nil then publicdata.Ranklist = {} end
       if publicdata.AgentRank == nil then publicdata.AgentRank = {} end

  
    if publicdata[playerID].Agency ~= nil and false then -- things being cheaper if your agency is ranked higher 
      local hold = 1 / publicdata[playerID].Agency.agencyRank
      if hold == 1 then hold = 0.75 end -- making sure agents aren't free if there number one
      local costhold = typecost * hold
  
      typecost = typecost - costhold
    end
  
    if (goldhave < typecost) then  -- don't have enough money
      setReturnTable({ Message = "You need " .. typecost .. " gold to purchase a " .. typename .. ". you need ".. typecost - goldhave ..  " more gold to purchase this unit", Pass = false})
        return
      end
  
      game.ServerGame.SetPlayerResource(playerID, WL.ResourceType.Gold, goldhave - typecost);
  
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
  
        table.insert(publicdata.Ranklist,publicdata[playerID].Agency)
        print (publicdata[playerID].Agency.agencyrating)
        setReturnTable({ Message = nil, Pass = true})

      
    elseif type == 1 then -- when you buy a decoy
      if publicdata[playerID].Agency.Decoylist == nil then publicdata[playerID].Agency.Decoylist = {}end
      if publicdata[playerID].Agency.Decoylist[#publicdata[playerID].Agency.Decoylist] == nil then 
        publicdata[playerID].Agency.Decoylist[#publicdata[playerID].Agency.Decoylist]  = 0 end

        publicdata[playerID].Agency.agencyrating = publicdata[playerID].Agency.agencyrating + 1 -- adding for agency rating
        setReturnTable({ Message = "Decoy successfully Set up ", Pass = true})
        publicdata[playerID].Agency.Missions = 10

  
  elseif type == 2 then -- when your buying a new agent
    if publicdata[playerID].Agency.Agentlist == nil then publicdata[playerID].Agency.Agentlist = {} end
    if publicdata[playerID].Agency.Agentlist[#publicdata[playerID].Agency.Agentlist] == nil then 
      publicdata[playerID].Agency.Agentlist[#publicdata[playerID].Agency.Agentlist]  = {} end 
      local short = publicdata[playerID].Agency.Agentlist[#publicdata[playerID].Agency.Agentlist]

      if short.codename == nil then short.codename = typetext end
      if short.level == nil then short.level = 1 end
      if short.kills == nil then short.kills = 0 end
      if short.missions == nil then short.missions = 0 end
      if short.missuccessfulmissionssions == nil then short.successfulmissions = 0 end

      table.insert(publicdata.AgentRank,short)


      publicdata[playerID].Agency.agencyrating = publicdata[playerID].Agency.agencyrating + 1 -- 1 for agent level. agency rating
      setReturnTable({ Message = "Agent Code Name '".. short.codename .. "' successfully Trained. ", Pass = true})
      

  end
  
    Mod.PublicGameData = publicdata

end

--[[function RankingLogic(id)
local pointer = publicdata[id].FirstRankpointer
local pastpointer = {}

  if publicdata[id].FirstRankpointer == nil then publicdata[id].FirstRankpointer = publicdata[id].Agency 
    publicdata[id].Agency.agencyRank = 1
  else 
    while true do
      if publicdata[id].Agency.agencyrating > pointer.agencyrating then
        publicdata[id].Agency.Backwardspointer = pointer
        publicdata[id].Agency.Frowardpointer = pastpointer
        pastpointer.Backwardspointer = publicdata[id].Agency
        pointer.Frowardpointer = publicdata[id].Agency
      -- do shit
      end
     
      pointer = pointer.Backwardspointer
      pastpointer = pointer.Frowardpointer

    end
  end

end--]]
--[[
function AddRank(agency)

  if publicdata.Ranklist == nil then publicdata.Ranklist = {} end
  
      print(#publicdata.Ranklist, "check 1")
  if publicdata.Ranklist[#publicdata.Ranklist + 1] == nil then publicdata.Ranklist[#publicdata.Ranklist + 1] = {} end

      print (#publicdata.Ranklist, "check 2")
      print(publicdata.Ranklist[#publicdata.Ranklist], "check 2.5")


  publicdata.Ranklist[#publicdata.Ranklist] = setmetatable({}, {__index = agency})
  print ( publicdata.Ranklist[1].agencyname, "name")

  for i,v in pairs (getmetatable(publicdata.Ranklist[#publicdata.Ranklist]))do -- testing purposes
    print (i,v,"test tables")
      for i,v in pairs (v)do
        print (i,v,"test values")
      end
  end
  print(publicdata.Ranklist)
print ("end of test")
end--]]