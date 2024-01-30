
function Client_PresentSettingsUI(rootParent)

	local percent = Mod.Settings.Percent -- for games that are already running
	local goldtax = Mod.Settings.GoldTax
	if goldtax == nil then goldtax = 0 end
	if percent == nil then percent = 0 end

	if goldtax > 0 then
		UI.CreateLabel(rootParent).SetText('Tax Mode: Tax multiplier').SetColor('#00F4FF')

	UI.CreateLabel(rootParent).SetText('Players gifted gold are Taxed 1 peice of gold every time they exceed this number ( ' .. goldtax .. ' ) ');
	elseif percent > 0 then
		UI.CreateLabel(rootParent).SetText('Tax Mode: Percent').SetColor('#00F4FF')
		UI.CreateLabel(rootParent).SetText('Players gifted gold are Taxed ' .. percent .. '% for every transfer');
	else
		UI.CreateLabel(rootParent).SetText('Tax Mode: None').SetColor('#00F4FF')
		UI.CreateLabel(rootParent).SetText('Gold is free to be gifted without Tax');

	end

end