--This file contains utility functions that could be used in any lua project.

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