
function Client_PresentSettingsUI(rootParent)

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row0 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row0).SetText('Base cost of Fort: ').SetColor('#00B5FF')
	UI.CreateLabel(row0).SetText(Mod.Settings.HiveCost)

	local row00 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row00).SetText('Max amount of Forts allowed: ').SetColor('#00B5FF')
	UI.CreateLabel(row00).SetText(Mod.Settings.Maxhives)

	local row1 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row1).SetText('Added cost per Fort owned: ').SetColor('#00B5FF')
	UI.CreateLabel(row1).SetText(": " .. Mod.Settings.Costincrease)

	local row2 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row2).SetText('Power of Fort in troops').SetColor('#00B5FF')
	UI.CreateLabel(row2).SetText(": " .. Mod.Settings.Need)

	local row3 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row3).SetText('Forts per territory allowed: ').SetColor('#00B5FF')
	UI.CreateLabel(row3).SetText(Mod.Settings.Limit)

	local row4 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row4).SetText('Increased power towards Forts every (value below) turns: ').SetColor('#00B5FF')
	local scale = Mod.Settings.Scale
	if scale == 0 then scale = "Off" end
		UI.CreateLabel(row4).SetText(scale)

	local row33 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row33).SetText('Turns between power increase (value above): ').SetColor('#00B5FF')
	UI.CreateLabel(row33).SetText(Mod.Settings.Turn)

	local row44 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row44).SetText('Does cost of forts also increase with power of forts: ').SetColor('#00B5FF')
	local remove = Mod.Settings.Market
	if remove == 0 then remove = "Yes" end
	UI.CreateLabel(row44).SetText(remove)

--auto placer number
	local row3 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row3).SetText('Autoplacer number: ').SetColor('#00B5FF')
	UI.CreateLabel(row3).SetText(Mod.Settings.Auto)

end

