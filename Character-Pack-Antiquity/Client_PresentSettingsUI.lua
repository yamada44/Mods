-- one of two things to fix
function Client_PresentSettingsUI(rootParent)



	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		for i = 1, Mod.Settings.BeforeMax  do 
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local Shared = 'No'
	local Vis = 'No'
	local MaxServer = 'No'
	local transfer = 0
	local level = 0
	local active = 0

	if (Mod.Settings.Unitdata[i].Maxunits == 0) then goto next end

		local image = Imagename(Mod.Settings.Unitdata[i].Image)

				if (Mod.Settings.Unitdata[i].Shared == true)then Shared = 'yes' end
				if (Mod.Settings.Unitdata[i].Visible == true)then Vis = 'yes' end
				if (Mod.Settings.Unitdata[i].MaxServer == true)then MaxServer = 'yes' end
				if (Mod.Settings.Unitdata[i].Transfer ~= nil) then transfer = Mod.Settings.Unitdata[i].Transfer  end
				if (Mod.Settings.Unitdata[i].Level ~= nil) then level = Mod.Settings.Unitdata[i].Level end
				if (Mod.Settings.Unitdata[i].Active ~= nil)then active = Mod.Settings.Unitdata[i].Active
	
	
		UI.CreateLabel(vert).SetText('Unit type ' .. i .. ': ' .. Mod.Settings.Unitdata[i].Name ).SetColor('#FEFF9B')
		UI.CreateLabel(vert).SetText('\nCost: ' .. Mod.Settings.Unitdata[i].unitcost)
		UI.CreateLabel(vert).SetText('Power in armies: ' .. Mod.Settings.Unitdata[i].unitpower);
		UI.CreateLabel(vert).SetText('Max amount at once: ' .. Mod.Settings.Unitdata[i].Maxunits);
		UI.CreateLabel(vert).SetText('Min possible age range: ' .. Mod.Settings.Unitdata[i].Minlife);
		UI.CreateLabel(vert).SetText('Max possible age range: ' .. Mod.Settings.Unitdata[i].Maxlife);
		UI.CreateLabel(vert).SetText('Unit tranfered upon death Amount: ' .. transfer);
		UI.CreateLabel(vert).SetText('Base Number of armies needed to kill to level up: ' .. level);
		UI.CreateLabel(vert).SetText('Unit locked till level: ' .. active);
		UI.CreateLabel(vert).SetText('Shared Max between players: ' .. Shared);
		UI.CreateLabel(vert).SetText('Visible to all players: ' .. Vis);
		UI.CreateLabel(vert).SetText('Max useage over game: ' .. MaxServer);
		UI.CreateLabel(vert).SetText('Image used: ' .. image);

	




	::next::
	end
	

	
end

function Imagename (name)
	local filename = {}

	filename[1] = 'Barbarian'
	filename[2] = 'Roman Legion'
	filename[3] = 'Horse'
	filename[4] = 'Man'
	filename[5] = 'Women'

return filename[name]


end
