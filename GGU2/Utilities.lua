require('ColorUI/TextWriter')

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

function first(array, func)
	for _,v in pairs(array) do
		if (func(v)) then
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

function SortTable(tableinput,field)
	local newtable = {}
	
	for i,v in pairs (tableinput) do
	local elementplaced = false
		for p = 1, #newtable do
			if newtable[p] == nil then table.insert(newtable,v) -- beginning of table
				elementplaced = true
				break
			elseif tableinput[i][field] >= newtable[p][field] then -- normal placing. 
				table.insert(newtable,p,v)
				elementplaced = true
				break
			end
		end
		if elementplaced == false then -- found the end of a table
			table.insert(newtable,v)
		end
	end

	return newtable
end

function Findmatch(findtable, match,what)
    for i,v in pairs (findtable) do

        if v[what] == match then
            return i
        end 
    end
    return nil
end
function FindmatchID(findtable, match,returnsetting) -- Return setting (1) = value / (2) = bool
	local Returnvalue = false
	if returnsetting == 1 then Returnvalue = nil end

    for i,v in pairs (findtable) do

        if v == match then
			Returnvalue = true
			if returnsetting == 1 then Returnvalue = i end
            return Returnvalue

        end 
    end
    return Returnvalue
end
-- serverside value to table conversion
function Values2Table_Server(IDtable)
	local newtable = {}
	for i,v in pairs (IDtable) do
		table.insert(newtable, Mod.PublicGameData.Entity[v])
	end
	return newtable
end
--creates a list of entities from a list of values
function Values2Table(IDtable)
	local newtable = {}
	for i,v in pairs (IDtable) do
		table.insert(newtable, Entities[v])
	end
	return newtable
end
--index then value to table
	function Values2Table_key(IDtable,key)
		local newtable = {}
		for i,v in pairs (IDtable) do
			
			table.insert(newtable, Entities[v.AID])
		end
		return newtable
	end
-- compare two tables then create a new one on matches
function SearchValue2Table(votegroup,compare,addtable)
	local whovoted = addtable or {}

	for i,v in pairs (compare) do
		for i2,v2 in pairs(votegroup) do 
			if v2 == v then 
				table.insert(whovoted,v) 
			end
		end
	end

	return whovoted
end
--[[
-- Prompt list functionally for players Entities (do not use. have not looked at)
	function TargetEntitiesClicked()
	end]]