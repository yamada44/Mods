-- one of two things to fix
function Client_PresentSettingsUI(rootParent)



	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		for i = 1, Mod.Settings.BeforeMax  do 
			local vert = UI.CreateVerticalLayoutGroup(rootParent);
			local image = Imagename(Mod.Settings.Unitdata[i].image)
			local Shared = 'False'
			local Vis = 'False'
			local even = 'False'
			local MaxServer = 0
			local transfer = 0
			local level = 0
			local active = 0
			local defend = 0
		
		
			if (Mod.Settings.Unitdata[i].Maxunits == 0) then goto next end
		
		
		
						if (Mod.Settings.Unitdata[i].Shared == true)then Shared = 'True' end
						if (Mod.Settings.Unitdata[i].Visible == true)then Vis = 'True' end
						if (Mod.Settings.Unitdata[i].Altmoves ~= nil and Mod.Settings.Unitdata[i].Altmoves == true)then even = 'True' end
						if (Mod.Settings.Unitdata[i].MaxServer ~= true and Mod.Settings.Unitdata[i].MaxServer ~= false)then MaxServer = Mod.Settings.Unitdata[i].MaxServer end
						if (Mod.Settings.Unitdata[i].Transfer ~= nil) then transfer = Mod.Settings.Unitdata[i].Transfer  end
						if (Mod.Settings.Unitdata[i].Level ~= nil) then level = Mod.Settings.Unitdata[i].Level end
						if (Mod.Settings.Unitdata[i].Active ~= nil)then active = Mod.Settings.Unitdata[i].Active end
						if (Mod.Settings.Unitdata[i].Defend ~= nil)then defend = Mod.Settings.Unitdata[i].Defend end
			
			
				UI.CreateLabel(vert).SetText('\nUnit type ' .. i .. ': ' .. Mod.Settings.Unitdata[i].Name ).SetColor('#FEFF9B')
				UI.CreateLabel(vert).SetText('Cost: ' .. Mod.Settings.Unitdata[i].unitcost)
				UI.CreateLabel(vert).SetText('Attack Power in armies: ' .. Mod.Settings.Unitdata[i].unitpower).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Defence power in armies: ' .. defend);
				UI.CreateLabel(vert).SetText('Max amount at once: ' .. Mod.Settings.Unitdata[i].Maxunits).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Min possible age range: ' .. Mod.Settings.Unitdata[i].Minlife)
				UI.CreateLabel(vert).SetText('Max possible age range: ' .. Mod.Settings.Unitdata[i].Maxlife).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Unit tranfered upon death Amount: ' .. transfer);
				UI.CreateLabel(vert).SetText('Max amount of units allowed to be spawned over entire game: ' .. MaxServer).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Base Number of armies needed to kill to level up: ' .. level);
				UI.CreateLabel(vert).SetText('Unit locked till turn: ' .. active).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Shared Max between players: ' .. Shared);
				UI.CreateLabel(vert).SetText('Visible to all players: ' .. Vis).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Move on Even turns only: ' .. even);

				UI.CreateLabel(vert).SetText('Image used: ' .. image).SetColor('#dbddf4')

	




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
