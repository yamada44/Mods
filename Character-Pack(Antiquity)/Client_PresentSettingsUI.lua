-- one of two things to fix
function Client_PresentSettingsUI(rootParent)
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		for i = 1, Playerdata.Maxtypes  do 
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		print (Playerdata.Unitdata)
		
	if (Playerdata.Unitdata[i].Maxunits == 0) then goto next end


	UI.CreateLabel(vert).SetText(Playerdata.Unitdata[i].Name .."'s are worth " .. Playerdata.Unitdata[i].unitpower .. " armies and cost " ..  Playerdata.Unitdata[i].unitcost .. " gold to purchase.  You may have up to " .. Playerdata.Unitdata[i].Maxunits .. ' ' .. Playerdata.Unitdata[i].Name.. "'s at a time.");
	Chartracker[i] = UI.CreateTextInputField(vert).SetPlaceholderText(" Name of Character                       ").SetFlexibleWidth(1).SetCharacterLimit(30)
	UI.CreateButton(vert).SetText("Purchase a ".. Playerdata.Unitdata[i].Name.." for " .. Playerdata.Unitdata[i].unitcost .. " gold").SetOnClick(function () PurchaseClicked(i) end)

	

	::next::
	end
	
	
	UI.CreateLabel(vert).SetText('Tank cost: ' .. Mod.Settings.Unitdata[i].CostToBuyTank);
	UI.CreateLabel(vert).SetText('Tank power: ' .. Mod.Settings.Unitdata[i].TankPower);
	UI.CreateLabel(vert).SetText('Max tanks: ' .. Mod.Settings.Unitdata[i].MaxTanks);
	
end

