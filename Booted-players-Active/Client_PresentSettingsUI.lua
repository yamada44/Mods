require('Utilities')

function Client_PresentSettingsUI(rootParent)


	local wasteland = Mod.Settings.WastelandAmount
	local pecent = Mod.Settings.Percentthreshold
	local turned = Mod.Settings.TurnedPercent
	if turned == nil then turned = 100 end

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	UI.CreateLabel(vert).SetText('Server agreement: ' .. pecent .. '%').SetColor('#F3FFAE')
	UI.CreateLabel(vert).SetText('Wasteland amount : ' .. wasteland).SetColor('#F3FFAE')
	UI.CreateLabel(vert).SetText('Turned Percent : ' .. turned).SetColor('#F3FFAE')


end