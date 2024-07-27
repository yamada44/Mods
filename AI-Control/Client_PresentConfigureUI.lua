
function Client_PresentConfigureUI(rootParent)

-- PURE AI
	--No attacks
		local p_attack = Mod.Settings.P_attack
		if p_attack == nil then
			p_attack = true
		end
	-- Deploy
		local p_deploy = Mod.Settings.P_deploy
		if p_deploy == nil then
			p_deploy = true
		end
	--No city
		local p_city = Mod.Settings.P_city
		if p_city == nil then
			p_city = true
		end
	--Diplo card
		local p_diplo = Mod.Settings.P_diplo
		if p_diplo == nil then
			p_diplo = true
		end
	--Block card
		local p_block = Mod.Settings.P_block
		if p_block == nil then
			p_block = true
		end
	--Emergency Block
		local p_emergency = Mod.Settings.P_emergency
		if p_emergency == nil then
			p_emergency = true
		end
	--Reinforcement
		local p_rein = Mod.Settings.P_rein
		if p_rein == nil then
			p_rein = true
		end



-- Human AI --------------------------------------------
	--No attacks
	local h_attack = Mod.Settings.H_attack
	if h_attack == nil then
		h_attack = true
	end
	-- Deploy
	local h_deploy = Mod.Settings.H_deploy
	if h_deploy == nil then
		h_deploy = true
	end
	--No city
	local h_city = Mod.Settings.H_city
	if h_city == nil then
		h_city = true
	end
	--Diplo card
	local h_diplo = Mod.Settings.H_diplo
	if h_diplo == nil then
		h_diplo = true
	end
	--Block card
	local h_block = Mod.Settings.H_block
	if h_block == nil then
		h_block = true
	end
	--Emergency Block
	local h_emergency = Mod.Settings.H_emergency
	if h_emergency == nil then
		h_emergency = true
	end
	--Reinforcement
	local h_rein = Mod.Settings.H_rein
	if h_rein == nil then
		h_rein = true
	end


	local vert = UI.CreateVerticalLayoutGroup(rootParent)


	local row0 = UI.CreateHorizontalLayoutGroup(vert) -- Pure / Human ai
	UI.CreateLabel(row0).SetText("what is Pure AI / Human AI").SetColor('#0000FF')
	UI.CreateButton(row0).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Pure AI: an AI created from game start.\n\nHuman AI: an AI that was a player before becoming an AI ") end)


	local row00 = UI.CreateHorizontalLayoutGroup(vert) -- Pure Text
	UI.CreateLabel(row00).SetText("Pure AI").SetColor('#0000FF')


	local row1 = UI.CreateHorizontalLayoutGroup(vert) -- Pure Attack
	UI.CreateLabel(row1).SetText('Can Pure AI attack')
	PP_attack = UI.CreateCheckBox(row1).SetText("").SetIsChecked(p_attack)

	local row2 = UI.CreateHorizontalLayoutGroup(vert) -- Pure deploy
	UI.CreateLabel(row2).SetText('Can Pure AI Deploy')
	PP_deploy = UI.CreateCheckBox(row2).SetText("").SetIsChecked(p_deploy)

	local row3 = UI.CreateHorizontalLayoutGroup(vert) -- Pure city
	UI.CreateLabel(row3).SetText('Can Pure AI build cities')
	PP_city = UI.CreateCheckBox(row3).SetText("").SetIsChecked(p_city)

	local row4 = UI.CreateHorizontalLayoutGroup(vert) -- Pure diplo
	UI.CreateLabel(row4).SetText('Can Pure AI place diplomacy cards')
	PP_diplo = UI.CreateCheckBox(row4).SetText("").SetIsChecked(p_diplo)

	local row5 = UI.CreateHorizontalLayoutGroup(vert) -- Pure block
	UI.CreateLabel(row5).SetText('Can Pure AI place Blockad cards')
	PP_block = UI.CreateCheckBox(row5).SetText("").SetIsChecked(p_block)

	local row6 = UI.CreateHorizontalLayoutGroup(vert) -- Pure Emergency
	UI.CreateLabel(row6).SetText('Can Pure AI play Emergency cards')
	PP_emger = UI.CreateCheckBox(row6).SetText("").SetIsChecked(p_emergency)

	local row7 = UI.CreateHorizontalLayoutGroup(vert) -- Pure Reinforcement
	UI.CreateLabel(row7).SetText('Can Pure AI play Reinforcement cards')
	PP_rein = UI.CreateCheckBox(row7).SetText("").SetIsChecked(p_rein)

-------------- Human AI


	local row00 = UI.CreateHorizontalLayoutGroup(vert) -- Human Text
	UI.CreateLabel(row00).SetText("Human AI").SetColor('#0000FF')


	local rowH1 = UI.CreateHorizontalLayoutGroup(vert) -- Human Attack
	UI.CreateLabel(rowH1).SetText('Can Human AI attack')
	HH_attack = UI.CreateCheckBox(rowH1).SetText("").SetIsChecked(h_attack)

	local rowH2 = UI.CreateHorizontalLayoutGroup(vert) -- Human deploy
	UI.CreateLabel(rowH2).SetText('Can Human AI Deploy')
	HH_deploy = UI.CreateCheckBox(rowH2).SetText("").SetIsChecked(h_deploy)

	local rowH3 = UI.CreateHorizontalLayoutGroup(vert) -- Human city
	UI.CreateLabel(rowH3).SetText('Can Human AI build cities')
	HH_city = UI.CreateCheckBox(rowH3).SetText("").SetIsChecked(h_city)

	local rowH4 = UI.CreateHorizontalLayoutGroup(vert) -- Human diplo
	UI.CreateLabel(rowH4).SetText('Can Human AI place diplomacy cards')
	HH_diplo = UI.CreateCheckBox(rowH4).SetText("").SetIsChecked(h_diplo)

	local rowH5 = UI.CreateHorizontalLayoutGroup(vert) -- Human block
	UI.CreateLabel(rowH5).SetText('Can Human AI place Blockad cards')
	HH_block = UI.CreateCheckBox(rowH5).SetText("").SetIsChecked(h_block)

	local rowH6 = UI.CreateHorizontalLayoutGroup(vert) -- Human Emergency
	UI.CreateLabel(rowH6).SetText('Can Human AI play Emergency cards')
	HH_emger = UI.CreateCheckBox(rowH6).SetText("").SetIsChecked(h_emergency)

	local rowH7 = UI.CreateHorizontalLayoutGroup(vert) -- Human Reinforcement
	UI.CreateLabel(rowH7).SetText('Can Human AI play Reinforcement cards')
	HH_rein = UI.CreateCheckBox(rowH7).SetText("").SetIsChecked(h_rein)

end