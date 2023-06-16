
function Client_PresentSettingsUI(rootParent)

	local mapname = MapName(Mod.Settings.mapreturnvalue)
	local Modname = ModName(Mod.Settings.modinputreturn)
	local neutralvalue = Mod.Settings.Neutral
	local theme = Themename(Mod.Settings.mapreturnvalue)

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	UI.CreateLabel(vert).SetText('Name of map configured to: ' .. mapname).SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Name of Mod configured to: ' .. Modname).SetColor('#43C631')
	UI.CreateLabel(vert).SetText('Neutrals turned to ' .. neutralvalue .. ' Armies').SetColor('#00B5FF')
	UI.CreateLabel(vert).SetText('Theme: ' .. theme).SetColor('#43C631')
		


end

function MapName(value)
	local name = {}

	name[1] = 'IS: Europe World War Supergame'
	name[2] = 'Baconsizzle`s Big World'
	name[3] = 'IS - Star Wars RP Map - B-Wing Edition'
	name[4] = 'The Peloponnesian War'
	name[5] = 'Liverpool City Centre'
	name[6] = 'Avatar - The Last Airbender'
	name[7] = 'France Large'
	name[8] = 'Huge Westeros'

return name[value]
end
function Themename(value)
	local name = {}

	name[1] = 'Sea tiles'
	name[2] = 'Sea tiles'
	name[3] = 'Space tiles'
	name[4] = 'Sea tiles'
	name[5] = 'Every territory not assigned to a bonus'
	name[6] = 'Sea tiles'
	name[7] = 'Sea tiles'
	name[8] = 'Sea tiles'

return name[value]
end

function ModName(value)
    local name = {}

    if value > 0 then
        name[1] = 'I.S. Character Pack ( Antiquity )'
        name[2] = 'I.S. Character Pack ( Ship Props )'
        name[3] = 'I.S. Character Pack ( Three kingdom Heros )'
        --name[4] = ''
        --name[5] = ''
        
    
    elseif value == 0 then 
        name[50] = 'All mods allowed'
        value = 50 
    end 
        
    
    return name[value]
    
end