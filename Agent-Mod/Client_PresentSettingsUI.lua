
function Client_PresentSettingsUI(rootParent)


	local creationfee = Mod.Settings.Creationfee
	local Agentcost = Mod.Settings.Agentcost
	local Decoycost = Mod.Settings.Decoycost
	local ArmiesLost = Mod.Settings.ArmiesLost
	local Cooldown = Mod.Settings.Cooldown
	local Citylost = Mod.Settings.Citylost
	local Cardsremoved = Mod.Settings.Cardsremoved
	local MissionCost = Mod.Settings.MissionCost


	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	UI.CreateLabel(vert).SetText('Gold needed to create a spy agency: $' .. creationfee).SetColor('#F3FFAE')
	UI.CreateLabel(vert).SetText('Agent/spy cost: $' .. Agentcost).SetColor('#F3FFAE')
    UI.CreateLabel(vert).SetText('Decoy Agent cost: $' .. Decoycost).SetColor('#F3FFAE')
	UI.CreateLabel(vert).SetText('Armies removed when a agent sabotages logistics: ' .. ArmiesLost).SetColor('#F3FFAE')
	UI.CreateLabel(vert).SetText('cities removed when a agent sabotages logistics: ' .. Citylost).SetColor('#F3FFAE')
	UI.CreateLabel(vert).SetText('Resting time between missions for agents (turns): ' .. Cooldown).SetColor('#F3FFAE')
	UI.CreateLabel(vert).SetText('Can cards be removed in this game: ' .. Cardsremoved).SetColor('#F3FFAE')
	UI.CreateLabel(vert).SetText('operation cost to launch a mission: $' .. MissionCost).SetColor('#F3FFAE')

end
