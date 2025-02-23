require('Utilities')

function Client_PresentCommercePurchaseUI(rootParent, game, close)
	Close1 = close;
	Game = game;

	publicdata = Mod.PublicGameData
	modplayers = Mod.PublicGameData
	Root = rootParent

	Playerdata = {}
	unit = {}
	Chartracker = {}
	increasingCost = {}
	ID = Game.Us.ID

	-- changing over packs data
	OrderstartsWith = modSign(0) -- the last letter represents the mod used
	TransferfromConfig()

	-- For loop start	
	for i = 1, Playerdata.Maxtypes  do  
		local vert = UI.CreateVerticalLayoutGroup(rootParent);
		local row1 = UI.CreateHorizontalLayoutGroup(vert)
		local row2 = UI.CreateHorizontalLayoutGroup(vert)
		local row3 = UI.CreateHorizontalLayoutGroup(vert)
		local morgeRow = nil
		local turnactive = true
		local Ruleson = true
		unitamount = 0
		increasingCost[i] = math.ceil(Playerdata.Unitdata[i].unitcost * 0.5)
		--Slot management
		local isSlot = false

		if Playerdata.Unitdata[i].Slot ~= nil and #Playerdata.Unitdata[i].Slot > 0 then
			for s = 1, #Playerdata.Unitdata[i].Slot do
				if Playerdata.Unitdata[i].Slot[s] == Game.Us.Slot then 
					isSlot = true
					break
				end
			end

		else 
			isSlot = true
		end
		if isSlot == false then
			UI.CreateLabel(rootParent).SetText("This Slot cannot build a "..Playerdata.Unitdata[i].Name) 
		else
			for _,order in pairs(Game.Orders) do
				if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, OrderstartsWith)) then
					unitamount = unitamount + 1
				end
			end

			if unitamount == 0 then unitamount = 1 increasingCost[i] = 0 end
			if modplayers[i] == nil then modplayers[i] = {} end
			if modplayers[i][ID] == nil then modplayers[i][ID] = {} end
			if modplayers[i][ID].readrules == nil then modplayers[i][ID].readrules = false end
			if Playerdata.Unitdata[i].HostRules == nil or Playerdata.Unitdata[i].HostRules == '' then -- making sure the buttons look clean
				morgeRow = vert
				Ruleson = false 
				modplayers[i][ID].readrules = true
			else morgeRow = row3 end
			
			local buttonmessage = "Under maintaince " --"Purchase a ".. Playerdata.Unitdata[i].Name.." for " .. Playerdata.Unitdata[i].unitcost + (increasingCost[i] * unitamount) .. " gold"
			local hostmessage = "Host Rules/Lore for Unit"
			local infomessage = dynamicInfo(i)
				
			if (Playerdata.Unitdata[i].Active ~= nil and Playerdata.Unitdata[i].Active ~= 0 and Playerdata.Unitdata[i].Active > Game.Game.TurnNumber)then turnactive = false 
				buttonmessage = Playerdata.Unitdata[i].Name .. ' disabled until turn ' .. Playerdata.Unitdata[i].Active 
			elseif publicdata[i] ~= nil and (publicdata[i][ Game.Us.ID] ~= nil) then
				print('cool down started')
				if (publicdata[i][ Game.Us.ID].cooldowntimer ~= nil and publicdata[i][ Game.Us.ID].cooldowntimer >= Game.Game.TurnNumber) then turnactive = false 
					buttonmessage = Playerdata.Unitdata[i].Name .. ' cooling down for ' ..  ((publicdata[i][ Game.Us.ID].cooldowntimer + 1) - Game.Game.TurnNumber) .. ' turn(s)'
				end
			end 

			if (Playerdata.Unitdata[i].Maxunits == 0) then goto next end
			UI.CreateLabel(row1).SetText(infomessage);
			UI.CreateButton(morgeRow).SetText(buttonmessage).SetOnClick(function () PurchaseClicked(i) end).SetInteractable(turnactive).SetFlexibleWidth(1)
			if (Ruleson == true )then
				UI.CreateButton(row3).SetText(hostmessage).SetOnClick(function () RulesClicked(i) end).SetInteractable(turnactive) end
			Chartracker[i] = UI.CreateTextInputField(vert).SetPlaceholderText(" Name of Character                       ").SetFlexibleWidth(1).SetCharacterLimit(20)
			::next::
		end
	end	
end

function TransferfromConfig() -- transfer the data from config to PlayerGameData
	if (Playerdata.Unitedata == nil) then Playerdata.Unitedata = {} end
	Playerdata.Maxtypes = Mod.Settings.BeforeMax
	Playerdata.Unitdata = Mod.Settings.Unitdata
end

function NumUnitin(armies,type)
	local ret = 0;
	local compare = ""
	for _,su in pairs(armies.SpecialUnits) do
		if su.proxyType == 'CustomSpecialUnit' then -- make sure its a custom unit
			if (Mod.Settings.Unitdata[type].Level or 0) > 0 then -- check to see if levels are turned on, and if so subtract extra text
				local stringskip = #su.Name - #Playerdata.Unitdata[type].Name 
				compare = string.sub(su.Name, stringskip+1)
				print(compare)
			else
				compare = su.Name
			end
			if (compare == Playerdata.Unitdata[type].Name and startsWith(su.ModData, OrderstartsWith)) then -- actually count unit
				ret = ret + 1;
				print(ret,"ret")
			end
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
	modplayers[Typerule][ID].readrules = true
	local payload = {}
	payload.type = Typerule
	Game.SendGameCustomMessage("read rules...", payload, function(returnValue) end)

	local rules = Playerdata.Unitdata[Typerule].HostRules
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	UI.CreateLabel(vert).SetText('These are custom Rules/Lore enforced by the host for this unit')
	UI.CreateLabel(vert).SetText(rules).SetColor('#dbddf4')
end

function PurchaseClicked(type)
	--Check if they're already at max.  Add in how many they have on the map plus how many purchase orders they've already made
	--We check on the client for player convenience. Another check happens on the server, so even if someone hacks their client and removes this check they still won't be able to go over the max.
	local playerID = Game.Us.ID;

	if Chartracker[type].GetText() ~= "0" then
		UI.Alert('Mod is under maintaince due to warzone update')
		Close1()
		return;
	end
	if (modplayers[type][ID].readrules == false)then  -- error check for name	
		UI.Alert('You have not Read unit rules yet.\n please read Unit rules before buying')
		Close1()
		return
	end
	
	if (Chartracker[type].GetText() == "" or Chartracker[type].GetText() == nil)then  -- error check for name
		UI.Alert('aborted: did not give Character name')
		Close1()
		return
	end

	Type = type
	local numUnitAlreadyHave = 0;
	for _,order in pairs(Game.Orders) do
		if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, OrderstartsWith ..  Type .. '_')) then
			numUnitAlreadyHave = numUnitAlreadyHave + 1;
		end
	end
	
	--cool down timer
	if (numUnitAlreadyHave > 0 and (Mod.Settings.Unitdata[type].Cooldown or 0) > 0) then
		UI.Alert("You have already bought one " .. Playerdata.Unitdata[Type].Name .. ", your cool down timer has started\nTo remove the cooldown timer, undo your buy order for this unit");
		return;
	end

	for _,ts in pairs(Game.LatestStanding.Territories) do --ts is value of territories table
		if (ts.OwnerPlayerID == playerID) then
			numUnitAlreadyHave = numUnitAlreadyHave + NumUnitin(ts.NumArmies, Type);
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
--print(Mod.Settings.Unitdata[Type].Oncity, "Oncity")
	local city = false
	if (Mod.Settings.Unitdata[Type].Oncity == true )then city = true
	elseif Mod.Settings.Unitdata[Type].Oncity ~= nil and Mod.Settings.Unitdata[Type].Oncity ~= false and Mod.Settings.Unitdata[Type].Oncity > 0 then city = true end
	if city then
		local Land = Game.LatestStanding.Territories[SelectedTerritory.ID]
		local Cities = Land.Structures
		local struc = Mod.Settings.Unitdata[Type].Oncity
		if (Cities == nil) then Cities = {} end
		if Mod.Settings.Unitdata[Type].Oncity == true then struc = 1 end

		if Cities[getBuildInfo(struc, "type")] == nil then
			UI.Alert("Territory has no " .. getBuildInfo(struc, "name") .. " structure type. This unit must be built on a " .. getBuildInfo(struc, "name"))
			return
		end
	end

	local power = math.random(Playerdata.Unitdata[Type].unitpower, Playerdata.Unitdata[Type].AttackMax)
	local msg = 'Buy a '.. Playerdata.Unitdata[Type].Name ..' on ' .. SelectedTerritory.Name;
	local payload = OrderstartsWith ..  Type .. '_' .. SelectedTerritory.ID ..';;'.. Type
					 .. ';;'.. power .. ';;'.. Playerdata.Unitdata[Type].Name.. ';;'.. Playerdata.Unitdata[Type].Maxunits..
					  ';;'.. Playerdata.Unitdata[Type].image .. ';;'.. tostring(Playerdata.Unitdata[Type].Shared) .. ';;'.. tostring(Playerdata.Unitdata[Type].Visible) 
					  .. ';;' .. Chartracker[Type].GetText() 
					  if true then return end
					  local orders = Game.Orders;
	table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload,  { [WL.ResourceType.Gold] = Playerdata.Unitdata[Type].unitcost + (increasingCost[Type] * unitamount) } ));
	Game.Orders = orders;
	Close2();
end

function dynamicInfo(i)
	local message = 'Name: ' ..Playerdata.Unitdata[i].Name -- Attack message
	local defend = Playerdata.Unitdata[i].unitpower / 2
	local city = false
	local upkeep = Playerdata.Unitdata[i].upkeep

	message = message .. '\nCost: ' ..  Playerdata.Unitdata[i].unitcost + (increasingCost[i] * unitamount)

	if (Mod.Settings.Unitdata[i].AttackMax ~= nil and Mod.Settings.Unitdata[i].AttackMax > Playerdata.Unitdata[i].unitpower) then
		message = message .. "\nAttack Range: " .. Playerdata.Unitdata[i].unitpower .. '-' .. Mod.Settings.Unitdata[i].AttackMax
	else message = message .."\nAttack Power: " .. Playerdata.Unitdata[i].unitpower end

	if Playerdata.Unitdata[i].Defend ~= nil then defend = Playerdata.Unitdata[i].Defend end

	message = message .. "\nDefense Power: " .. defend
	message = message .. "\nMax at once: " .. Playerdata.Unitdata[i].Maxunits

	if Mod.Settings.Unitdata[i].Maxlife > 0 then
		message = message .. "\nTurns Alive: " .. Mod.Settings.Unitdata[i].Minlife .. '-' .. Mod.Settings.Unitdata[i].Maxlife
	end
	if Mod.Settings.Unitdata[i].Level ~= nil and Mod.Settings.Unitdata[i].Level > 0 then
		message = message .. "\nKills needed for first level up: " .. Mod.Settings.Unitdata[i].Level
	end
	print (Mod.Settings.Unitdata[i].Oncity,"info values")

	if (Mod.Settings.Unitdata[i].Oncity == true )then city = true
	elseif Mod.Settings.Unitdata[i].Oncity ~= nil and Mod.Settings.Unitdata[i].Oncity ~= false and Mod.Settings.Unitdata[i].Oncity > 0 then city = true end
	if city then
		local name = getBuildInfo(1, "name")
		print ("Structure type", Mod.Settings.Unitdata[i].Oncity)
		if type(Mod.Settings.Unitdata[i].Oncity) == "number" then name = getBuildInfo(Mod.Settings.Unitdata[i].Oncity, "name") end
		message = message .. "\nBuild on ".. name .." Only"
	end
	if upkeep ~= nil and upkeep ~= 0 then
		message = message .. "\nUpkeep Cost: " .. upkeep .. " gold"
	end
 
	message = message .. '\nMore details on this unit type in full Settings        '

	return message
end
