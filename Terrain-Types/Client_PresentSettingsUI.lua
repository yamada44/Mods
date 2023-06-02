
function Client_PresentSettingsUI(rootParent)

	local mapname = MapName(Mod.Settings.mapreturnvalue)
	local Modname = ModName(Mod.Settings.modinputreturn)
	local neutralvalue = Mod.Settings.Neutral

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	UI.CreateLabel(vert).SetText('Name of map configured to: ' .. mapname)
	UI.CreateLabel(vert).SetText('Name of Mod configured to: ' .. Modname)
	UI.CreateLabel(vert).SetText('Neutrals turned to ' .. neutralvalue .. ' Armies')	
		


end

function MapName(value)
	local name = {}

	name[1] = 'IS: Europe World War Supergame'
	name[2] = 'Baconsizzle`s Big World'
	name[3] = 'IS - Star Wars RP Map - B-Wing Edition'
	name[4] = 'The Peloponnesian War'
	name[5] = 'Liverpool City Centre'

return name[value]
end
function ModName(value)
    local name = {}

    if value > 0 then
        name[1] = 'I.S. Character Pack ( Antiquity )'
        name[2] = 'I.S. Character Pack ( Ship Props )'
        --name[3] = ''
        --name[4] = ''
        --name[5] = ''
        
    
    elseif value == 0 then 
        name[50] = 'All mods allowed'
        value = 50 
    end 
        
    
    return name[value]
    
end