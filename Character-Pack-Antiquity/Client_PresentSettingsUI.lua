-- one of two things to fix
function Client_PresentSettingsUI(rootParent)



	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		for i = 1, Mod.Settings.Maxunittype  do 
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		
	if (Mod.Settings.Unitdata[i].Maxunits == 0) then goto next end

	--UI.CreateLabel(vert).SetText(Mod.Settings.Unitdata[i].Name'\n\n cost: ' .. Mod.Settings.Unitdata[i].unitcost);
	--UI.CreateLabel(vert).SetText('power: ' .. Mod.Settings.Unitdata[i].unitpower);
	--UI.CreateLabel(vert).SetText('Max amount: ' .. Mod.Settings.Unitdata[i].Maxunits);

	::next::
	end
	

	
end

