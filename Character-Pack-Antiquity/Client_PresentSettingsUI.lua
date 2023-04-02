-- one of two things to fix
function Client_PresentSettingsUI(rootParent)



	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		for i = 1, Mod.Settings.Maxunittype  do 
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		
	if (Mod.Settings.Unitdata[i].Maxunits == 0) then goto next end

	UI.CreateLabel(vert).SetText('Unir type ' .. i .. ': ' .. Mod.Settings.Unitdata[i].Name ).SetColor('#FEFF9B')
	UI.CreateLabel(vert).SetText('\n\n cost: ' .. Mod.Settings.Unitdata[i].unitcost)
	UI.CreateLabel(vert).SetText('power in armies: ' .. Mod.Settings.Unitdata[i].unitpower);
	UI.CreateLabel(vert).SetText('Max amount at once: ' .. Mod.Settings.Unitdata[i].Maxunits);
	UI.CreateLabel(vert).SetText('Shared Max between players: ' .. Mod.Settings.Unitdata[i].Shared);
	UI.CreateLabel(vert).SetText('Visible to all players: ' .. Mod.Settings.Unitdata[i].Visible);
	UI.CreateLabel(vert).SetText('Max useage over game: ' .. Mod.Settings.Unitdata[i].MaxServer);



	::next::
	end
	

	
end

