require('Utilities')

function Client_PresentSettingsUI(rootParent)



	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		for i = 1, Mod.Settings.BeforeMax  do 
			local vert = UI.CreateVerticalLayoutGroup(rootParent);
			local image = Imagename(Mod.Settings.Unitdata[i].image)
			local Shared = 'False'
			local Vis = 'False'
			local even = 'False'
			local city = "False"
			local combat = "After Armies"
			local MaxServer = 0
			local transfer = 0
			local level = 0
			local active = 0
			local defend = 0
			local cooldown = 0
			local assass = 0
			local auto = 0
			local powermessage = 'Attack Power in armies: ' .. Mod.Settings.Unitdata[i].unitpower
		
		
			if (Mod.Settings.Unitdata[i].Maxunits == 0) then goto next end
		

		
						if (Mod.Settings.Unitdata[i].Shared == true)then Shared = 'True' end
						if (Mod.Settings.Unitdata[i].Visible == true)then Vis = 'True' end
						if (Mod.Settings.Unitdata[i].Altmoves ~= nil and Mod.Settings.Unitdata[i].Altmoves == true)then even = 'True' end
						if (Mod.Settings.Unitdata[i].MaxServer ~= true and Mod.Settings.Unitdata[i].MaxServer ~= false)then MaxServer = Mod.Settings.Unitdata[i].MaxServer end
						if (Mod.Settings.Unitdata[i].Transfer ~= nil) then transfer = Mod.Settings.Unitdata[i].Transfer  end
						if (Mod.Settings.Unitdata[i].Level ~= nil) then level = Mod.Settings.Unitdata[i].Level end
						if (Mod.Settings.Unitdata[i].Active ~= nil)then active = Mod.Settings.Unitdata[i].Active end
						if (Mod.Settings.Unitdata[i].Defend ~= nil)then defend = Mod.Settings.Unitdata[i].Defend end
						if (Mod.Settings.Unitdata[i].Cooldown ~= nil)then cooldown = Mod.Settings.Unitdata[i].Cooldown end
						if (Mod.Settings.Unitdata[i].Assassination ~= nil)then assass = Mod.Settings.Unitdata[i].Assassination end
						if (Mod.Settings.Unitdata[i].AttackMax ~= nil and Mod.Settings.Unitdata[i].AttackMax > Mod.Settings.Unitdata[i].unitpower) then
							 powermessage = "Attack Range is: " .. Mod.Settings.Unitdata[i].unitpower .. ' - ' .. Mod.Settings.Unitdata[i].AttackMax
							end
						if (Mod.Settings.Unitdata[i].Oncity == true )then city = Buildname(1)
						elseif Mod.Settings.Unitdata[i].Oncity ~= nil and Mod.Settings.Unitdata[i].Oncity ~= false and Mod.Settings.Unitdata[i].Oncity > 0 then city = Buildname(Mod.Settings.Unitdata[i].Oncity) end
						if (Nonill(Mod.Settings.Unitdata[i].CombatOrder) == 1 )then combat = "Before Armies" end
						if (Mod.Settings.Unitdata[i].Autovalue ~= nil)then auto = Mod.Settings.Unitdata[i].Autovalue end
							

				UI.CreateLabel(vert).SetText('\nUnit type ' .. i .. ': ' .. Mod.Settings.Unitdata[i].Name ).SetColor('#FEFF9B')
				UI.CreateLabel(vert).SetText('Cost: ' .. Mod.Settings.Unitdata[i].unitcost)
				UI.CreateLabel(vert).SetText(powermessage).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Defence power in armies: ' .. defend);
				UI.CreateLabel(vert).SetText('Max amount at once: ' .. Mod.Settings.Unitdata[i].Maxunits).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Life range: ' .. Mod.Settings.Unitdata[i].Minlife .. ' - '.. Mod.Settings.Unitdata[i].Maxlife)
				UI.CreateLabel(vert).SetText('Unit tranfered upon death Amount: ' .. transfer).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Max amount of units allowed to be spawned over entire game: ' .. MaxServer)
				UI.CreateLabel(vert).SetText('Base Number of armies needed to kill to level up: ' .. level).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Unit locked till turn: ' .. active)
				UI.CreateLabel(vert).SetText('Combat order: ' .. combat).SetColor('#dbddf4') --
				UI.CreateLabel(vert).SetText('Create on Structure type only: ' .. city) --
				UI.CreateLabel(vert).SetText('Shared Max between players: ' .. Shared).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Visible to all players: ' .. Vis)
				UI.CreateLabel(vert).SetText('Move on Even turns only: ' .. even).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Cool Down timer (in turns): ' .. cooldown)
				UI.CreateLabel(vert).SetText('Assassination/Sabotage level: ' .. assass).SetColor('#dbddf4')
				UI.CreateLabel(vert).SetText('Auto Place Number: ' .. auto)
				UI.CreateLabel(vert).SetText('Image used: ' .. image).SetColor('#dbddf4')
	




				::next::
	end
end

function Imagename (name)
	local filename = {}
	local sourcenames = ModSign(1)

	filename[1] = sourcenames[1]
	filename[2] = sourcenames[2]
	filename[3] = sourcenames[3]
	filename[4] = sourcenames[4]
	filename[5] = sourcenames[5]
	filename[6] = sourcenames[6]

	if name == 0 then name = 6 end
return filename[name]


end
function Buildname(type)
	local build = {}

	build[1] = "Cities"
	build[2] = "Army Camp"
	build[3] = "Mine"
	build[4] = "Smelter"
	build[5] = "Crafter"
	build[6] = "Market"
	build[7] = "Army Cache"
	build[8] = "Money Cache"
	build[9] = "Resource Cache"
	build[10] = "Mercenary Camp" -- real fort
	build[11] = "Power"
	build[12] = "Man with Hand"
	build[13] = "Arena"
	build[14] = "Hospital"
	build[15] = "Dig Site"
	build[16] = "Artillery"
	build[17] =	"Mortar"
	build[18] = "Book"

	if type == 0 then return 0 end
	return build[type]
end