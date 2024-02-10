
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
		new_array[i] = func(v)
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
		table.insert(group, v);
	end

	return ret;
end

function Finddayofweek(Daystable,Month,Cday)

	local total = 0


		for i = 1, Month do

			if i == Month then
				total = total + Cday
			else
				total = total + Daystable[i]
				
			end
			 
		end
	return total
end

function Calculateweek(totaldays,weekdays)
	local weeknameindex = 0
	if totaldays < weekdays then
		weeknameindex = totaldays
	else
		local W = math.floor(totaldays / weekdays) 
		local tw = W * weekdays
		weeknameindex = totaldays - tw
		if weeknameindex == 0 then weeknameindex = weekdays end
	end

	return weeknameindex
end
function Addhistroy(record,Time,turn,monthnames,abb,dayofweek)
	local year = Time.year
	if year < 0 then year = year * -1 end
	record.year = year
	record.month = Time.month 
	record.day = Time.day 
	record.hour = Time.hour 
	record.mintue = Time.mintue 
	record.second = Time.second 
	record.abb = abb
	record.DayName = dayofweek 
	record.turn = turn + 1
	record.monthname = monthnames[Time.month]
	
	return record
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

function ViewingOptions(type)
	local style = {}

	style[1] = "Years"
	style[2] = "Month"
	style[3] = "Days"
	style[4] = "Hour"
	style[5] = "Minutes"
	style[6] = "Second"
	style[7] = "Month Name"
	style[8] = "Day Name"
	style[9] = "None"

	if type == 0 then return style 
	elseif type > 0 then return style[type] end

end