require('Utilities')

function Server_StartGame (game,standing)

    Pub = Mod.PublicGameData
    Pub.Terrain = {}
    Pub.Type = {}
    Game = game
    local LandTable =  Mod.Settings.Landdata
    local firstTile = {}

--Init Values
    for i, v in pairs (LandTable) do
        firstTile[i] = {}
        firstTile[i].First = false
        firstTile[i].TileID = 0
        Pub.Type[i] = {}
        Pub.Type[i].name = v.C_Name
        Pub.Type[i].turnstart = v.C_Turnstart
        Pub.Type[i].turnend = v.C_Turnend
        Pub.Type[i].armyValueChange = v.C_Value
        Pub.Type[i].ModFormat = ModDataSetup(v.C_Definegroup)
        Pub.Type[i].BaseSettings = v.C_Inverse

        Pub.Type[i].Removebuild = v.C_RemoveBuild
    end


        for Tid,ts in pairs(standing.Territories) do
            Pub.Terrain[Tid] = {}
            local found = false
            for i,v in pairs (LandTable) do
                
                if (ts.NumArmies.NumArmies == v.C_Autofind or ts.NumArmies.NumArmies == v.C_AutoP) and (v.C_Inverse == 1 or v.C_Inverse == 2)  then -- standard template settings.
                    if Pub.Terrain[Tid].name == nil or Pub.Terrain[Tid].BaseSettings == 4 or v.C_Inverse == 3 then -- deciding how ownership value works

                        firstTile[i] = ID_decider(Tid,v,ts,firstTile[i])
                    end

                    Pub.Terrain[Tid].Type = i

                    found = true
                elseif found == false and (v.C_Inverse == 4 or v.C_Inverse == 3) and (ts.NumArmies.NumArmies ~= v.C_Autofind and ts.NumArmies.NumArmies ~= v.C_AutoP) then -- for every other tile not included in a template and that setting has been turned on with the setting C_Inverse = 4
                    if Pub.Terrain[Tid].name == nil then -- deciding how ownership value works
                        firstTile[i] = ID_decider(Tid,v,ts,firstTile[i])
                    end

                    Pub.Terrain[Tid].Type = i
                end

            end
            if Pub.Terrain[Tid].name == nil then
                Pub.Terrain[Tid].name = "No Terrain Type" end

        end

        FirstTerrainPass(game,standing)

        Mod.PublicGameData = Pub
end
function ID_decider(Tid,v,ts,first)

    if  v.C_TerrainTypeID == -1 then -- changes to first tile ID it comes across

        if first.First == false then
            Pub.Terrain[Tid].OwnerID = ts.OwnerPlayerID 
            first.TileID = ts.OwnerPlayerID
            first.First = true 
        else
            Pub.Terrain[Tid].OwnerID = first.TileID
        end

    elseif v.C_TerrainTypeID == -2 then -- does not change
        Pub.Terrain[Tid].OwnerID = nil
    elseif  v.C_TerrainTypeID == -3 then -- keep ownership of all current tiles
        Pub.Terrain[Tid].OwnerID = ts.OwnerPlayerID 
    elseif  v.C_TerrainTypeID == 0 then -- changes it to 0
        Pub.Terrain[Tid].OwnerID = 0
    elseif  v.C_TerrainTypeID > 0 then -- Manual ID input (changes to neutral if ID was not found)

        local PlayerID = Findmatch(Game.Game.PlayingPlayers,v.C_TerrainTypeID - 1,"Slot")
        print(PlayerID,"playerID",Game.Game.PlayingPlayers[PlayerID].ID)
        Pub.Terrain[Tid].OwnerID = Game.Game.PlayingPlayers[PlayerID].ID
    end
    return first
end

function FirstTerrainPass(game,standing)

    local modtable = {}


    for i,v2 in pairs(Pub.Terrain)do
        local v = Pub.Type[v2.Type]
        local ts = standing.Territories[i]
        local Army = ts.NumArmies.NumArmies -- Base army amount
        local Owner = ts.OwnerPlayerID

        if v.turnstart ~= nil and (v.turnstart == -1 or v.turnstart == 0) then

            local mod = WL.TerritoryModification.Create(i)
            --specil unit immune/remove
            local SUdata = {}
            SUdata = SUImmuneOrNot(ts,v.ModFormat,v.BaseSettings)
            if SUdata.Immune_logic == false then


                --ownership change
                if v2.OwnerID ~= nil and v2.OwnerID ~= ts.OwnerPlayerID  then
                    ts.OwnerPlayerID = v2.OwnerID
                end

                --army change
                print("test 1")
                if v.armyValueChange ~= -1 and v.armyValueChange ~= ts.NumArmies.NumArmies then
                    ts.NumArmies = WL.Armies.Create(v.armyValueChange,nil)
                end

                --remove buildings
                if v.Removebuild == true then
                    local Cities = {}
                    Cities[WL.StructureType.City] = 0
                    Cities[WL.StructureType.MercenaryCamp] = 0
                    Cities[WL.StructureType.ArmyCamp] = 0

                    ts.Structures = Cities
                end
            end
        end

    end


end

function ModDataSetup(rawdata)
    local FormatedData = {}

    for index,value in pairs(rawdata)do
        FormatedData[index] = {}
        for i,v in pairs(value)do
            if i == 1 then
                FormatedData[index].mod = v
                print(i,v,"index")
            else
                print(i,v,"index")  
                FormatedData[index].type = v
         
            end

        end
    end    
    return FormatedData
end