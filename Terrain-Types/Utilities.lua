require('ColorUI/TextWriter')

function NewIdentity()
	local data = Mod.PublicGameData;
	local ret = data.Identity or 1;
	data.Identity = ret + 1;
	Mod.PublicGameData = data;
	return ret;
end
function Dump(obj)
	if obj.proxyType ~= nil then
		DumpProxy(obj);
	elseif type(obj) == 'table' then
		DumpTable(obj);
	else
		print('Dump ' .. type(obj));
	end
end
function DumpTable(tbl)
    for k,v in pairs(tbl) do
        print('k = ' .. tostring(k) .. ' (' .. type(k) .. ') ' .. ' v = ' .. tostring(v) .. ' (' .. type(v) .. ')');
    end
end
function DumpProxy(obj)

    print('type=' .. obj.proxyType .. ' readOnly=' .. tostring(obj.readonly) .. ' readableKeys=' .. table.concat(obj.readableKeys, ',') .. ' writableKeys=' .. table.concat(obj.writableKeys, ','));
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end


function map(array, func)
	local new_array = {}
	local i = 1;
	for _,v in pairs(array) do
		new_array[i] = func(v);
		i = i + 1;
	end
	return new_array
end


function filter(array, func)
	local new_array = {}
	local i = 1;
	for _,v in pairs(array) do
		if (func(v)) then
			new_array[i] = v;
			i = i + 1;
		end
	end
	return new_array
end

function removeWhere(array, func)
	for k,v in pairs(array) do
		if (func(v)) then
			array[k] = nil;
		end
	end
end

function first(array, func)
	for _,v in pairs(array) do
		if (func == nil or func(v)) then
			return v;
		end
	end
	return nil;
end

function randomFromArray(array)
	local len = #array;
	local i = math.random(len);
	return array[i];
end

function startsWith(str, sub)
	return string.sub(str, 1, string.len(sub)) == sub;
end

function shuffle(tbl)
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
end

function groupBy(tbl, funcToGetKey)
	local ret = {};
	for k,v in pairs(tbl) do
		local key = funcToGetKey(v);
		local group = ret[key];
		if (group == nil) then
			group = {};
			ret[key] = group;
		end
		table.insert(group, v)
	end

	return ret;
end
--returns place in table
function Findmatch(findtable, match,what) -- input a table with a index and values, then input a value(match) to match on table values(what). returns value if true, returns 0 if not 
    for i = 1, #findtable do

        if findtable[i][what] == match then
            print(match, i, "match")
            return i

        end 
    end
    return 0
end
function Slotchecker(playerid,game)
    if playerid == 0 or playerid == nil then return false end
    local issame = false

    for i = 1, #Mod.Settings.Slot do
        if Mod.Settings.Slot[i] == game.Game.PlayingPlayers[playerid].Slot then 
            return true
        end 
    end

    return issame
end
function Modloader(loadnumber)
    local list = {}
	if loadnumber == -1 then return -1 end
    if loadnumber > 0 then
		list[1] = 'C&P'
        list[2] = 'C&PA'
        list[3] = 'C&PB'
        list[4] = 'C&PC'
        list[5] = 'C&PD'
        list[6] = 'C&PE'
        list[7] = 'C&PF'
        list[8] = 'C&PG'
        list[9] = 'C&PH'
        list[10] = 'C&PI'
        list[11] = 'C&PJ'
        list[12] = 'C&PK'
        list[13] = 'C&PL'
        list[14] = 'C&PM'
        list[15] = 'C&PN'
        list[16] = 'C&PO'
		list[17] = 'C&PP'
		list[18] = 'C&PQ'

        
    return list[loadnumber]
    elseif loadnumber == 0 then 
        return 0
    end 
    
end

function Characterpackloader(loadnumber)
    local list = {}

    if loadnumber > 0 then
		list[1] = 'All Character packs'
        list[2] = 'Antiquity Pack'
        list[3] = 'Ship Props Pack'
        list[4] = 'Hero Pack'
        list[5] = 'Asian Pack'
        list[6] = 'World war Pack'
        list[7] = 'Greek Gods Pack'
        list[8] = 'medieval Pack'
        list[9] = 'medieval Props Pack'
        list[10] = 'Modern Pack'
        list[11] = 'Monsters Pack'
        list[12] = 'People/Ganger Pack'
        list[13] = 'Game of thrones Pack'
        list[14] = 'Star wars Pack'
        list[15] = 'Star war Props Pack'
        list[16] = 'Victorian Pack'
		list[17] = 'Muv-Luv Pack'
		list[18] = 'Muv-luv Beta/Human Pack'

        
    return list[loadnumber]
    elseif loadnumber == 0 then 
        return 0
    end 
    
end

function SUImmuneOrNot (land,Moddata,Basesetting,neworder)
    local t = {correctunit = false,SU = {},Immune_logic = false} 
    for index, value in pairs (Moddata)do

        if (#land.NumArmies.SpecialUnits > 0 ) then -- looking for SU to determine logic
            for i,v in pairs (land.NumArmies.SpecialUnits)do 
                if v.proxyType == "CustomSpecialUnit" or Modloader(value.mod) == 0  then
                    if v.ModData ~= nil or Modloader(value.mod) == 0 then
                        if startsWith(v.ModData or "", Modloader(value.mod))then
                            local payloadSplit = split(string.sub(v.ModData, 5), ';;'); 
                            local unittype = tonumber(payloadSplit[10])
                            if unittype == value.type or value.type == 0 then
                                t.correctunit = true
                                table.insert(t.SU, v.ID)   
                            end

                        elseif Modloader(value.mod) == 0 then 
                            t.correctunit = true
                            table.insert(t.SU, v.ID)

                        end
                    end
                end
            end
            if t.correctunit == true then

                if Basesetting == 1 or Basesetting == 4 then -- Immune logic
                        t.Immune_logic = true
                        print("empty table")
                        t.SU = {}
                end
            end 
        end
    
    end
    return t
    end

 