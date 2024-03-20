require('Utilities')
function Client_PresentSettingsUI(rootParent)

	local name = Mod.Settings.Buildname

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	local row0 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row0).SetText('Only these Slots are effected by these settings: ').SetColor('#00B5FF')
	local text = Mod.Settings.Slotstore
	if text == "" or text == nil then text = "Auto placer mode"
	UI.CreateLabel(row0).SetText(text)

	local row00 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row00).SetText('Percentaged of killed troops converted to this slot: ').SetColor('#00B5FF')
	UI.CreateLabel(row00).SetText(Mod.Settings.TConv .. "%")

	local row1 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row1).SetText('Cost to build a ' .. name).SetColor('#00B5FF')
	UI.CreateLabel(row1).SetText(": " .. Mod.Settings.HiveCost)

	local row2 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row2).SetText('Max amount of ' .. name .. '`s').SetColor('#00B5FF')
	UI.CreateLabel(row2).SetText(": " .. Mod.Settings.Maxhives)

	local row3 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row3).SetText('Autoplacer number: ').SetColor('#00B5FF')
	UI.CreateLabel(row3).SetText(Mod.Settings.Auto)

	local row4 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row4).SetText('Cities removed when controlled by this slot: ').SetColor('#00B5FF')
	local remove = Mod.Settings.CityGone
	if remove == 0 then remove = "None" end
	UI.CreateLabel(row4).SetText(remove)

	local row10 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row10).SetText('Can Build cities: ').SetColor('#00B5FF')
	UI.CreateLabel(row10).SetText(Mod.Settings.Nocities)

	local row5 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row5).SetText('Deployment Rules: ').SetColor('#00B5FF')
	local deploy = "No limits"
	if Mod.Settings.TDep == 2 then deploy = "can only deploy on " .. name
	elseif Mod.Settings.TDep == 3 then deploy = "Cannot deploy troops" end
	UI.CreateLabel(row5).SetText(deploy) 

	local row6 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row6).SetText('Can play Airlift cards: ').SetColor('#00B5FF')
	UI.CreateLabel(row6).SetText(Mod.Settings.PlayAir) 

	local row7 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row7).SetText('Can play Diplomacy cards: ').SetColor('#00B5FF')
	UI.CreateLabel(row7).SetText(Mod.Settings.PlayDip) 

	local row8 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row8).SetText('Can play Sanction cards: ').SetColor('#00B5FF')
	UI.CreateLabel(row8).SetText(Mod.Settings.PlaySan) 

	local row9 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row9).SetText('Can play Reinforcement cards: ').SetColor('#00B5FF')
	UI.CreateLabel(row9).SetText(Mod.Settings.PlayRef) 

end
