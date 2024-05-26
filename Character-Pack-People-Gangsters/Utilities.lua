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

function isNotEven(int)
	return int % 2 ~= 0
end

-- function buildCustomUnit(territoryOwnerID, attributes)
--     local builder = WL.CustomSpecialUnitBuilder.Create(territoryOwnerID)

--     builder.Name = attributes.name
--     builder.IncludeABeforeName = true
--     builder.ImageFilename = fileFinder(attributes.image)
--     builder.AttackPower = attributes.attackPower
--     builder.DefensePower = attributes.defensePower
--     builder.CombatOrder = attributes.combatOrder
--     builder.DamageToKill = attributes.damageToKill
--     builder.DamageAbsorbedWhenAttacked = attributes.damageToKill
--     builder.CanBeGiftedWithGiftCard = true
--     builder.CanBeTransferredToTeammate = false
--     builder.CanBeAirliftedToSelf = true
--     builder.CanBeAirliftedToTeammate = true
--     builder.TextOverHeadOpt = attributes.name
--     builder.IsVisibleToAllPlayers = attributes.isVisible
--     builder.ModData = attributes.modData

--     return builder
-- end

function getImageFile(image)
	if image == 0 then
		image = math.random(1, 5)
	end

	local files = {
		"pack 1.a.png",
		"pack 1.b.png",
		"pack 1.c.png",
		"pack 1.d.png",
		"pack 1.e.png",
	}
	return files[image]
end

function getBuildInfo(type, mode)
    if type == 0 or type > 18 then return 0 end

    local builds = {
        [1] = {"Cities", WL.StructureType.City},
        [2] = {"Army Camp", WL.StructureType.ArmyCamp},
        [3] = {"Mine", WL.StructureType.Mine},
        [4] = {"Smelter", WL.StructureType.Smelter},
        [5] = {"Crafter", WL.StructureType.Crafter},
        [6] = {"Market", WL.StructureType.Market},
        [7] = {"Army Cache", WL.StructureType.ArmyCache},
        [8] = {"Money Cache", WL.StructureType.MoneyCache},
        [9] = {"Resource Cache", WL.StructureType.ResourceCache},
		[10] = {"Power", WL.StructureType.Power},
        [11] = {"Mercenary Camp", WL.StructureType.MercenaryCamp}, -- real fort
        [12] = {"Man with Hand", WL.StructureType.Draft},
        [13] = {"Arena", WL.StructureType.Arena},
        [14] = {"Hospital", WL.StructureType.Hospital},
        [15] = {"Dig Site", WL.StructureType.DigSite},
        [16] = {"Artillery", WL.StructureType.Attack},
        [17] = {"Mortar", WL.StructureType.Mortar},
        [18] = {"Book", WL.StructureType.Recipe},
    }

	if mode == "name" then return builds[type][1] end
	if mode == "type" then return builds[type][2] end
	-- error("Invalid mode: " .. tostring(mode))
end

function modSign(mode)
    if mode == 0 then
        return "C&PK"
    elseif mode == 1 then
        return {
            "Modern Women","Detective","Gangster","Cop","Family","Random"
        }
    end
end
