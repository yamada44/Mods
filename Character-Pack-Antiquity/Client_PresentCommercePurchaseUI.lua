require('Utilities')

function Client_PresentCommercePurchaseUI(rootParent, game, close)
	Close1 = close;
	Game = game;

	Playerdata = {}
	unit = {}
	Chartracker = {}
	OrderstartsWith = "C&P"

	TransferfromConfig()



	for i = 1, Playerdata.Maxtypes  do 
	local vert = UI.CreateVerticalLayoutGroup(rootParent);

		print (Playerdata.Unitdata)
		
	if (Playerdata.Unitdata[i].Maxunits == 0) then goto next end


	UI.CreateLabel(vert).SetText(Playerdata.Unitdata[i].Name .."'s are worth " .. Playerdata.Unitdata[i].unitpower .. " armies and cost " ..  Playerdata.Unitdata[i].unitcost .. " gold to purchase.  You may have up to " .. Playerdata.Unitdata[i].Maxunits .. ' ' .. Playerdata.Unitdata[i].Name.. "'s at a time.");
	Chartracker[i] = UI.CreateTextInputField(vert).SetPlaceholderText(" Name of Character                       ").SetFlexibleWidth(1).SetCharacterLimit(30)
	UI.CreateButton(vert).SetText("Purchase a ".. Playerdata.Unitdata[i].Name.." for " .. Playerdata.Unitdata[i].unitcost .. " gold").SetOnClick(function () PurchaseClicked(i) end)

	

	::next::
	end
	
end
function TransferfromConfig() -- transfer the data from config to PlayerGameData

	if (Playerdata.Unitedata == nil) then Playerdata.Unitedata = {} end 

	Playerdata.Maxtypes = Mod.Settings.BeforeMax
	Playerdata.Unitdata = Mod.Settings.Unitdata


end

function NumUnitin(armies, type)
	local ret = 0;
	for _,su in pairs(armies.SpecialUnits) do
		if (su.proxyType == 'CustomSpecialUnit' and su.Name == Playerdata.Unitdata[type].Name) then
			ret = ret + 1;
		end
	end
	return ret;
end

function PurchaseClicked(type)
	--Check if they're already at max.  Add in how many they have on the map plus how many purchase orders they've already made
	--We check on the client for player convenience. Another check happens on the server, so even if someone hacks their client and removes this check they still won't be able to go over the max.

	local playerID = Game.Us.ID;
	
print (Chartracker[type].GetText())
print(type)

	if (Chartracker[type].GetText() == "")then  -- error check for name
	
		UI.Alert('aborted: did not give Character name')
		Close1()
		return
	end

	
	Type = type
	
	local numUnitAlreadyHave = 0;
	for _,ts in pairs(Game.LatestStanding.Territories) do --ts is value of territories table
		if (ts.OwnerPlayerID == playerID) then
			numUnitAlreadyHave = numUnitAlreadyHave + NumUnitin(ts.NumArmies, Type);
		end
	end

	for _,order in pairs(Game.Orders) do
		if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, OrderstartsWith ..  Type .. '_')) then
			numUnitAlreadyHave = numUnitAlreadyHave + 1;
		end
	end

	if (numUnitAlreadyHave >= Playerdata.Unitdata[Type].Maxunits) then
		UI.Alert("You already have " .. numUnitAlreadyHave .. " " .. Playerdata.Unitdata[Type].Name .. ", and you can only have " ..  Playerdata.Unitdata[type].Maxunits);
		return;
	end

	Game.CreateDialog(PresentBuyUnitDialog); 
	Close1();
end


function PresentBuyUnitDialog(rootParent, setMaxSize, setScrollable, game, close)
	Close2 = close;

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1); --set flexible width so things don't jump around while we change InstructionLabel

	SelectTerritoryBtn = UI.CreateButton(vert).SetText("Select Territory").SetOnClick(SelectTerritoryClicked);
	TargetTerritoryInstructionLabel = UI.CreateLabel(vert).SetText("");

	BuyUnitBtn = UI.CreateButton(vert).SetInteractable(false).SetText("Complete Purchase").SetOnClick(CompletePurchaseClicked);

	SelectTerritoryClicked(); --just start us immediately in selection mode, no reason to require them to click the button
end

function SelectTerritoryClicked() -- Needs type
	UI.InterceptNextTerritoryClick(TerritoryClicked);
	TargetTerritoryInstructionLabel.SetText("Please click on the territory you wish to receive your ".. Playerdata.Unitdata[Type].Name.. " on.  If needed, you can move this dialog out of the way.");
	SelectTerritoryBtn.SetInteractable(false);
end

function TerritoryClicked(terrDetails)
	SelectTerritoryBtn.SetInteractable(true);

	if (terrDetails == nil) then
		--The click request was cancelled.   Return to our default state.
		TargetTerritoryInstructionLabel.SetText("");
		SelectedTerritory = nil;
		BuyUnitBtn.SetInteractable(false);
	else
		--Territory was clicked, check it
		if (Game.LatestStanding.Territories[terrDetails.ID].OwnerPlayerID ~= Game.Us.ID) then
			TargetTerritoryInstructionLabel.SetText("You may only receive a " .. Playerdata.Unitdata[Type].Name .. " on a territory you own.  Please try again.");
		else
			TargetTerritoryInstructionLabel.SetText("Selected territory: " .. terrDetails.Name);
			SelectedTerritory = terrDetails;
			BuyUnitBtn.SetInteractable(true);
		end
	end
end

function CompletePurchaseClicked()

print (tostring(Playerdata.Unitdata[Type].Shared) , tostring(Playerdata.Unitdata[Type].Visible))

	local msg = 'Buy a '.. Playerdata.Unitdata[Type].Name ..' on ' .. SelectedTerritory.Name;
	local payload = OrderstartsWith ..  Type .. '_' .. SelectedTerritory.ID .. ',' .. Chartracker[Type].GetText() ..','.. Type
					 .. ','.. Playerdata.Unitdata[Type].unitpower .. ','.. Playerdata.Unitdata[Type].Name.. ','.. Playerdata.Unitdata[Type].Maxunits..
					  ','.. Playerdata.Unitdata[Type].image .. ','.. tostring(Playerdata.Unitdata[Type].Shared) .. ','.. tostring(Playerdata.Unitdata[Type].Visible)

	
	local orders = Game.Orders;
	table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload,  { [WL.ResourceType.Gold] = Playerdata.Unitdata[Type].unitcost } ));
	Game.Orders = orders;



	Close2();
end
