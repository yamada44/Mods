-- one of two things to fix
function Client_PresentSettingsUI(rootParent)



	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		for i = 1, Mod.Settings.Maxunittype  do 
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

	local Shared = 'No'
	local Vis = 'No'
	local MaxServer = 'No'
	if (Mod.Settings.Unitdata[i].Maxunits == 0) then goto next end

	
				if (Mod.Settings.Unitdata[i].Shared == true)then Shared = 'yes' end
				if (Mod.Settings.Unitdata[i].Visible == true)then Vis = 'yes' end
				if (Mod.Settings.Unitdata[i].MaxServer == true)then MaxServer = 'yes' end
	
	
		UI.CreateLabel(vert).SetText('Unir type ' .. i .. ': ' .. Mod.Settings.Unitdata[i].Name ).SetColor('#FEFF9B')
		UI.CreateLabel(vert).SetText('\nCost: ' .. Mod.Settings.Unitdata[i].unitcost)
		UI.CreateLabel(vert).SetText('Power in armies: ' .. Mod.Settings.Unitdata[i].unitpower);
		UI.CreateLabel(vert).SetText('Max amount at once: ' .. Mod.Settings.Unitdata[i].Maxunits);
		UI.CreateLabel(vert).SetText('Shared Max between players: ' .. Shared);
		UI.CreateLabel(vert).SetText('Visible to all players: ' .. Vis);
		UI.CreateLabel(vert).SetText('Max useage over game: ' .. MaxServer);


	::next::
	end
	

	
end

