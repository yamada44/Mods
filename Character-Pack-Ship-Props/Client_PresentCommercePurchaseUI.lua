require('Utilities')

function Client_PresentCommercePurchaseUI(rootParent, game, close)
	Close1 = close;
	Game = game;

	publicdata = Mod.PublicGameData
	Root = rootParent

	Playerdata = {}
	unit = {}
	Chartracker = {}

	-- changing over packs data
	OrderstartsWith = "C&PB" -- the last letter represents the mod used


	TransferfromConfig()


	print (Game.Game.TurnNumber, "turn number")
	for i = 1, Playerdata.Maxtypes  do 
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local morgeRow = row3
	local turnactive = true
	local defend = 0
	local addedwords = ''
	local Ruleson = true
if Playerdata.Unitdata[i].HostRules == nil or Playerdata.Unitdata[i].HostRules == '' then -- making sure the buttons look clean
	morgeRow = vert
	Ruleson = false
end
	local buttonmessage = "Purchase a ".. Playerdata.Unitdata[i].Name.." for " .. Playerdata.Unitdata[i].unitcost .. " gold"
	local hostmessage = "Host rules for unit"
		
	if (Playerdata.Unitdata[i].Active ~= nil and Playerdata.Unitdata[i].Active ~= 0 and Playerdata.Unitdata[i].Active > Game.Game.TurnNumber)then turnactive = false 
		buttonmessage = Playerdata.Unitdata[i].Name .. ' disabled until turn ' .. Playerdata.Unitdata[i].Active 

	elseif publicdata[i] ~= nil then
		if (publicdata[i][ Game.Us.ID] ~= nil)then
		print('cool down started')
	if (publicdata[i][ Game.Us.ID].cooldowntimer ~= nil and publicdata[i][ Game.Us.ID].cooldowntimer >= Game.Game.TurnNumber)then turnactive = false 
		buttonmessage = Playerdata.Unitdata[i].Name .. ' cooling down for ' ..  ((publicdata[i][ Game.Us.ID].cooldowntimer + 1) - Game.Game.TurnNumber) .. ' turn(s)' end
	end end
	
	if (Playerdata.Unitdata[i].Defend ~= nil)then defend = Playerdata.Unitdata[i].Defend end
	if (Playerdata.Unitdata[i].Maxunits == 0) then goto next end


	UI.CreateLabel(row1).SetText('Name: ' ..Playerdata.Unitdata[i].Name .."\nAttack Power: " .. Playerdata.Unitdata[i].unitpower .. "\nDefense Power: " .. defend .. '\nCost: ' ..  Playerdata.Unitdata[i].unitcost .. "\nMax at once: " .. Playerdata.Unitdata[i].Maxunits.. '\nMore details on this unit type in full Settings');
	UI.CreateButton(morgeRow).SetText(buttonmessage).SetOnClick(function () PurchaseClicked(i) end).SetInteractable(turnactive)
	if (Ruleson == true )then
		UI.CreateButton(row3).SetText(hostmessage).SetOnClick(function () RulesClicked(i) end).SetInteractable(turnactive) end
	Chartracker[i] = UI.CreateTextInputField(vert).SetPlaceholderText(" Name of Character                       ").SetFlexibleWidth(1).SetCharacterLimit(15)

	

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
		if (su.proxyType == 'CustomSpecialUnit' and su.Name == Playerdata.Unitdata[type].Name and startsWith(su.ModData, 'C&PB')) then
			ret = ret + 1;
		end
	end
	return ret;
end
function RulesClicked(type)
Typerule = type
	Game.CreateDialog(HostRulesDialog)
	
end
function HostRulesDialog(rootParent, setMaxSize, setScrollable, game, close)
	Close3 = close
	local rules = Playerdata.Unitdata[Typerule].HostRules

	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	
	UI.CreateLabel(vert).SetText('These are custom Rules enforced by the host how to buy/use this unit')
	UI.CreateLabel(vert).SetText(rules).SetColor('#dbddf4')

	--Game.CreateDialog
	
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
	local payload = OrderstartsWith ..  Type .. '_' .. SelectedTerritory.ID ..';;'.. Type
					 .. ';;'.. Playerdata.Unitdata[Type].unitpower .. ';;'.. Playerdata.Unitdata[Type].Name.. ';;'.. Playerdata.Unitdata[Type].Maxunits..
					  ';;'.. Playerdata.Unitdata[Type].image .. ';;'.. tostring(Playerdata.Unitdata[Type].Shared) .. ';;'.. tostring(Playerdata.Unitdata[Type].Visible) 
					  .. ';;' .. Chartracker[Type].GetText() 

	
	local orders = Game.Orders;
	table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload,  { [WL.ResourceType.Gold] = Playerdata.Unitdata[Type].unitcost } ));
	Game.Orders = orders;



	Close2();
end
