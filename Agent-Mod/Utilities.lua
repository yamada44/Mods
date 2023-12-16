
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
function map2(array, func)
	local new_array = {}
	local i = 1;
	for N,v in pairs(array) do
		
		new_array[i] = func(N);
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
function Nonill(value)
	if value == nil then
		return 0
	
else return value end
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

function CardData(value)
	local cards = {}

	cards["Reinforcement"] = "GameOrderPlayCardReinforcement"
	cards["Gift"] = "GameOrderPlayCardGift"
	cards["Spy"] = "GameOrderPlayCardSpy"
	cards["EmergencyBlockade"] = "GameOrderPlayCardAbandon"
	cards["Blockade"] = "GameOrderPlayCardBlockade"
	cards["OrderPriority"] = "GameOrderPlayCardOrderPriority"
	cards["OrderDelay"] = "GameOrderPlayCardOrderDelay"
	cards["Airlift"] = "GameOrderPlayCardAirlift"
	cards["Diplomacy"] = "GameOrderPlayCardDiplomacy"
	cards["Sanctions"] = "GameOrderPlayCardSanctions"
	cards["Reconnaissance"] = "GameOrderPlayCardReconnaissance"
	cards["Surveillance"] = "GameOrderPlayCardSurveillance"
	cards["Bomb"] = "GameOrderPlayCardBomb"

	if type(value) ~= "number" then -- return a single card
	return cards(value)
	elseif type(value) == "number" then -- return entire table
		return cards
	end
end

function CardWLData(value)
	local cards = {}

	cards["Reinforcement"] = WL.CardID.Reinforcement
	cards["Gift"] = WL.CardID.Gift
	cards["Spy"] = WL.CardID.Spy
	cards["EmergencyBlockade"] = WL.CardID.Abandon
	cards["Blockade"] = WL.CardID.Blockade
	cards["OrderPriority"] = WL.CardID.OrderPriority
	cards["OrderDelay"] = WL.CardID.OrderDelay
	cards["Airlift"] = WL.CardID.Airlift
	cards["Diplomacy"] = WL.CardID.Diplomacy
	cards["Sanctions"] = WL.CardID.Sanctions
	cards["Reconnaissance"] = WL.CardID.Reconnaissance
	cards["Surveillance"] = WL.CardID.Surveillance
	cards["Bomb"] = WL.CardID.Bomb

	if type(value) ~= "number" then -- return a single card
	return cards[value]
	elseif type(value) == "number" then -- return entire table
		return cards
	end
end
--returns place in table
function Findmatch(findtable, match,what)
    for i = 1, #findtable do

        if findtable[i][what] == match then
            print(match, i, "match")
            return i

        end 
    end
    return nil
end
function FindmatchID(findtable, match)
    for i = 1, #findtable do

        if findtable[i] == match then
            print(match, i, "match")
            return i

        end 
    end
    return nil
end
--create tables from list of player ID's

function Values2TableAgency(IDtable)
	local newtable = {}
	for i,v in pairs (IDtable) do
		print(i,v,IDtable)
		table.insert(newtable, publicdata[v].Agency)
	end
	return newtable
end
function Values2TableAgent(IDtable)
	local newtable = {}
	for i,v in pairs (IDtable) do
		print(#publicdata[v].Agency.Agentlist, "agentlist amount")
		if #publicdata[v].Agency.Agentlist > 0 then
			for i,v in pairs (publicdata[v].Agency.Agentlist) do
			table.insert(newtable, v)
			end
		end
	end
	print(IDtable)
	return newtable
end