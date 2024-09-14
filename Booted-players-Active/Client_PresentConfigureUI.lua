
function Client_PresentConfigureUI(rootParent)

	local wasteamount = Mod.Settings.WastelandAmount
	if wasteamount == nil then
		wasteamount = 10
	end
    local percent = Mod.Settings.Percentthreshold
	if percent == nil then
		percent = 66
	end

	local host = Mod.Settings.Host
	if host == nil then
		host = true
	end

    local vert = UI.CreateVerticalLayoutGroup(rootParent)
	

    local row01 = UI.CreateHorizontalLayoutGroup(vert); -- Wasteland amount
	UI.CreateButton(row01).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("When a player is turned into a wasteland, this number will be how many armies are on the wasteland"); end);
	UI.CreateLabel(row01).SetText('Wasteland Amount');
    WastelandInput = UI.CreateNumberInputField(row01)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(1000)
		.SetValue(wasteamount)

    local row02 = UI.CreateHorizontalLayoutGroup(vert); -- Percent threshold amount
    UI.CreateButton(row02).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("What percent of players in the server need to agree before the action can process"); end);
    UI.CreateLabel(row02).SetText('Percent Threshold');
    PercentInput = UI.CreateNumberInputField(row02)
        .SetSliderMinValue(50)
        .SetSliderMaxValue(100)
        .SetValue(percent)

	local row8 = UI.CreateHorizontalLayoutGroup(vert) -- present 
	UI.CreateButton(row8).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("True: the server Votes on Host and Host decides Actions\nFalse: Server votes on Actions"); end);
	UI.CreateLabel(row8).SetText('Host Controls Vote')
	HostInput = UI.CreateCheckBox(row8).SetText("").SetIsChecked(host)

end