require('Utilities')
function Client_PresentSettingsUI(rootParent)

	local name = Mod.Settings.Buildname

	local vert = UI.CreateVerticalLayoutGroup(rootParent)



	local row000 = UI.CreateHorizontalLayoutGroup(vert) -- Human Text
	UI.CreateLabel(row000).SetText("Pure AI").SetColor('#0000FF')

	local row9 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row9).SetText('Pure AI can attack: ' .. tostring(Mod.Settings.P_attack)).SetColor('#00B5FF')

	local row2 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row2).SetText('Pure AI can attack: ' .. tostring(Mod.Settings.P_deploy)).SetColor('#00B5FF')

	local row3 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row3).SetText('Pure AI can attack: ' .. tostring(Mod.Settings.P_city)).SetColor('#00B5FF')

	local row4 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row4).SetText('Pure AI can attack: ' .. tostring(Mod.Settings.P_diplo)).SetColor('#00B5FF')

	local row5 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row5).SetText('Pure AI can attack: ' .. tostring(Mod.Settings.P_block)).SetColor('#00B5FF')

	local row6 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row6).SetText('Pure AI can attack: ' .. tostring(Mod.Settings.P_emergency)).SetColor('#00B5FF')

	local row7 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row7).SetText('Pure AI can attack: ' .. tostring(Mod.Settings.P_rein)).SetColor('#00B5FF')

if Mod.Settings.P_bomb ~= nil then
	local row8 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(row8).SetText('Pure AI can attack: ' .. tostring(Mod.Settings.P_bomb .. '\n\n')).SetColor('#00B5FF') end
--Human
local row00 = UI.CreateHorizontalLayoutGroup(vert) -- Human Text
UI.CreateLabel(row00).SetText("Human AI").SetColor('#0000FF')

	local rowH9 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(rowH9).SetText('Human AI can attack: ' .. tostring(Mod.Settings.H_attack)).SetColor('#00B5FF')

	local rowH2 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(rowH2).SetText('Human AI can attack: ' .. tostring(Mod.Settings.H_deploy)).SetColor('#00B5FF')

	local rowH3 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(rowH3).SetText('Human AI can attack: ' .. tostring(Mod.Settings.H_city)).SetColor('#00B5FF')

	local rowH4 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(rowH4).SetText('Human AI can attack: ' .. tostring(Mod.Settings.H_diplo)).SetColor('#00B5FF')

	local rowH5 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(rowH5).SetText('Human AI can attack: ' .. tostring(Mod.Settings.H_block)).SetColor('#00B5FF')

	local rowH6 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(rowH6).SetText('Human AI can attack: ' .. tostring(Mod.Settings.H_emergency)).SetColor('#00B5FF')

	local rowH7 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(rowH7).SetText('Human AI can attack: ' .. tostring(Mod.Settings.H_rein)).SetColor('#00B5FF')

	if Mod.Settings.H_bomb ~= nil then
	local rowH8 = UI.CreateHorizontalLayoutGroup(vert) 
	UI.CreateLabel(rowH8).SetText('Human AI can attack: ' .. tostring(Mod.Settings.H_bomb .. '\n\n')).SetColor('#00B5FF') end
end
