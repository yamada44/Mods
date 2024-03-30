function NewIdentity()
	local data = Mod.PublicGameData
	local ret = data.Identity or 1
	data.Identity = ret + 1
	Mod.PublicGameData = data
	return ret
end

function Dump(obj)
	if obj.proxyType ~= nil then
		DumpProxy(obj)
	elseif type(obj) == "table" then
		DumpTable(obj)
	else
		print("Dump " .. type(obj))
	end
end

function DumpTable(tbl)
	for k, v in pairs(tbl) do
		print("k = " .. tostring(k) .. " (" .. type(k) .. ") " .. " v = " .. tostring(v) .. " (" .. type(v) .. ")")
	end
end

function DumpProxy(obj)
	print(
		"type="
			.. obj.proxyType
			.. " readOnly="
			.. tostring(obj.readonly)
			.. " readableKeys="
			.. table.concat(obj.readableKeys, ",")
			.. " writableKeys="
			.. table.concat(obj.writableKeys, ",")
	)
end

function split(str, pat)
	local t = {} -- NOTE: use {n = 0} in Lua-5.0
	local fpat = "(.-)" .. pat
	local last_end = 1
	local s, e, cap = str:find(fpat, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t, cap)
		end
		last_end = e + 1
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
	local i = 1
	for _, v in pairs(array) do
		new_array[i] = func(v)
		i = i + 1
	end
	return new_array
end

function filter(array, func)
	local new_array = {}
	local i = 1
	for _, v in pairs(array) do
		if func(v) then
			new_array[i] = v
			i = i + 1
		end
	end
	return new_array
end

function removeWhere(array, func)
	for k, v in pairs(array) do
		if func(v) then
			array[k] = nil
		end
	end
end

function first(array, func)
	for _, v in pairs(array) do
		if func == nil or func(v) then
			return v
		end
	end
	return nil
end

function randomFromArray(array)
	local len = #array
	local i = math.random(len)
	return array[i]
end

function startsWith(str, sub)
	return string.sub(str, 1, string.len(sub)) == sub
end

function shuffle(tbl)
	for i = #tbl, 2, -1 do
		local j = math.random(i)
		tbl[i], tbl[j] = tbl[j], tbl[i]
	end
end

function groupBy(tbl, funcToGetKey)
	local ret = {}
	for k, v in pairs(tbl) do
		local key = funcToGetKey(v)
		local group = ret[key]
		if group == nil then
			group = {}
			ret[key] = group
		end
		table.insert(group, v)
	end
	return ret
end

function isEven(int)
	return int % 2 == 0
end

function modSign(mode)
	if mode == 0 then
		return "C&PA"
	elseif mode == 1 then
		return {
			"Barbarian",
			"Roman Legion",
			"Horse",
			"Man",
			"Women",
			"Random",
		}
	end

	error("Invalid mode: " .. tostring(mode))
end

function fileFinder(image)
	if image == 0 then
		image = math.random(1, 5)
	end

	local fileStorage = {
		"pack 1.a.png",
		"pack 1.b.png",
		"pack 1.c.png",
		"pack 1.d.png",
		"pack 1.e.png",
	}
	return filestorage[image]
end

function buildType(type)
	if type == 0 then
		return 0
	end

	local build = {
		[1] = WL.StructureType.City,
		[2] = WL.StructureType.ArmyCamp,
		[3] = WL.StructureType.Mine,
		[4] = WL.StructureType.Smelter,
		[5] = WL.StructureType.Crafter,
		[6] = WL.StructureType.Market,
		[7] = WL.StructureType.ArmyCache,
		[8] = WL.StructureType.MoneyCache,
		[9] = WL.StructureType.ResourceCache,
		[10] = WL.StructureType.MercenaryCamp, -- real fort
		[11] = WL.StructureType.Power,
		[12] = WL.StructureType.Draft,
		[13] = WL.StructureType.Arena,
		[14] = WL.StructureType.Hospital,
		[15] = WL.StructureType.DigSite,
		[16] = WL.StructureType.Attack,
		[17] = WL.StructureType.Mortar,
		[18] = WL.StructureType.Recipe,
	}
	return build[type]
end
