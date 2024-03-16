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
	ID = Game.Us.ID

	-- changing over packs data
	OrderstartsWith = ModSign(0) -- the last letter represents the mod used


	TransferfromConfig()


	print (Game.Game.TurnNumber, "turn number")
	for i = 1, Playerdata.Maxtypes  do 
	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local morgeRow = nil
	local turnactive = true
	local Ruleson = true
	if modplayers[i] == nil then modplayers[i] = {} end
	if modplayers[i][ID] == nil then modplayers[i][ID] = {} end
	if modplayers[i][ID].readrules == nil then modplayers[i][ID].readrules = false end
if Playerdata.Unitdata[i].HostRules == nil or Playerdata.Unitdata[i].HostRules == '' then -- making sure the buttons look clean
	morgeRow = vert
	Ruleson = false 
	modplayers[i][ID].readrules = true
else morgeRow = row3 

end
	
	local buttonmessage = "Purchase a ".. Playerdata.Unitdata[i].Name.." for " .. Playerdata.Unitdata[i].unitcost .. " gold"
	local hostmessage = "Host Rules/Lore for Unit"
	local infomessage = dynamicInfo(i)
		
	if (Playerdata.Unitdata[i].Active ~= nil and Playerdata.Unitdata[i].Active ~= 0 and Playerdata.Unitdata[i].Active > Game.Game.TurnNumber)then turnactive = false 
		buttonmessage = Playerdata.Unitdata[i].Name .. ' disabled until turn ' .. Playerdata.Unitdata[i].Active 

	elseif publicdata[i] ~= nil then
		if (publicdata[i][ Game.Us.ID] ~= nil)then
		print('cool down started')
	if (publicdata[i][ Game.Us.ID].cooldowntimer ~= nil and publicdata[i][ Game.Us.ID].cooldowntimer >= Game.Game.TurnNumber)then turnactive = false 
		buttonmessage = Playerdata.Unitdata[i].Name .. ' cooling down for ' ..  ((publicdata[i][ Game.Us.ID].cooldowntimer + 1) - Game.Game.TurnNumber) .. ' turn(s)' end
	end end
	

	if (Playerdata.Unitdata[i].Maxunits == 0) then goto next end


	UI.CreateLabel(row1).SetText(infomessage);
	UI.CreateButton(morgeRow).SetText(buttonmessage).SetOnClick(function () PurchaseClicked(i) end).SetInteractable(turnactive).SetFlexibleWidth(1)
	if (Ruleson == true )then
		UI.CreateButton(row3).SetText(hostmessage).SetOnClick(function () RulesClicked(i) end).SetInteractable(turnactive) end
	Chartracker[i] = UI.CreateTextInputField(vert).SetPlaceholderText(" Name of Character                       ").SetFlexibleWidth(1).SetCharacterLimit(20)

	

	::next::
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
			if Nonill(Mod.Settings.Unitdata[type].Level) > 0 then -- check to see if levels are turned on, and if so subtract extra text
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
	
print (Chartracker[type].GetText())
print(type)

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
	if (numUnitAlreadyHave > 0 and Nonill(Mod.Settings.Unitdata[type].Cooldown) > 0) then
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
print(Mod.Settings.Unitdata[Type].Oncity, "Oncity")
	if Mod.Settings.Unitdata[Type].Oncity ~= nil and (Mod.Settings.Unitdata[Type].Oncity == true or Mod.Settings.Unitdata[Type].Oncity > 0) then
		local Land = Game.LatestStanding.Territories[SelectedTerritory.ID]
		local Cities = Land.Structures
		local struc = Mod.Settings.Unitdata[Type].Oncity
		if (Cities == nil) then Cities = {} end
		if Mod.Settings.Unitdata[Type].Oncity == true then struc = 1 end

		if Cities[Buildtype(struc)] == nil then
			UI.Alert("Territory has no " .. Buildname(struc) .. " structure type. This unit must be built on a " .. Buildname(struc))
			return
		end
	end
	


	local power = math.random(Playerdata.Unitdata[Type].unitpower,Playerdata.Unitdata[Type].AttackMax)

	local msg = 'Buy a '.. Playerdata.Unitdata[Type].Name ..' on ' .. SelectedTerritory.Name;
	local payload = OrderstartsWith ..  Type .. '_' .. SelectedTerritory.ID ..';;'.. Type
					 .. ';;'.. power .. ';;'.. Playerdata.Unitdata[Type].Name.. ';;'.. Playerdata.Unitdata[Type].Maxunits..
					  ';;'.. Playerdata.Unitdata[Type].image .. ';;'.. tostring(Playerdata.Unitdata[Type].Shared) .. ';;'.. tostring(Playerdata.Unitdata[Type].Visible) 
					  .. ';;' .. Chartracker[Type].GetText() 

	
	local orders = Game.Orders;
	table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload,  { [WL.ResourceType.Gold] = Playerdata.Unitdata[Type].unitcost } ));
	Game.Orders = orders;



	Close2();
end

function dynamicInfo(i)
	local message = 'Name: ' ..Playerdata.Unitdata[i].Name -- Attack message
	local defend = Playerdata.Unitdata[i].unitpower / 2

	message = message .. '\nCost: ' ..  Playerdata.Unitdata[i].unitcost 

	if (Mod.Settings.Unitdata[i].AttackMax ~= nil and Mod.Settings.Unitdata[i].AttackMax > Playerdata.Unitdata[i].unitpower)then
		message = message .. "\nAttack Range: " .. Playerdata.Unitdata[i].unitpower .. '-' .. Mod.Settings.Unitdata[i].AttackMax
	
	else	message = message .."\nAttack Power: " .. Playerdata.Unitdata[i].unitpower    end

	if Playerdata.Unitdata[i].Defend ~= nil then defend = Playerdata.Unitdata[i].Defend end

	message = message .. "\nDefense Power: " .. defend
	message = message .. "\nMax at once: " .. Playerdata.Unitdata[i].Maxunits

	if Mod.Settings.Unitdata[i].Maxlife > 0 then
		message = message .. "\nTurns Alive: " .. Mod.Settings.Unitdata[i].Minlife .. '-' .. Mod.Settings.Unitdata[i].Maxlife
	end

	if Mod.Settings.Unitdata[i].Level ~= nil and Mod.Settings.Unitdata[i].Level > 0 then
		message = message .. "\nKills needed for first level up: " .. Mod.Settings.Unitdata[i].Level
	end
	if Mod.Settings.Unitdata[i].Oncity ~= nil and Mod.Settings.Unitdata[i].Oncity == true then
		message = message .. "\nBuild on cities Only"
	end
 
	message = message .. '\nMore details on this unit type in full Settings        '

	return message
end

function Buildtype(type)
	local build = {}

	build[1] = WL.StructureType.City
	build[2] = WL.StructureType.ArmyCamp
	build[3] = WL.StructureType.Mine
	build[4] = WL.StructureType.Smelter
	build[5] = WL.StructureType.Crafter
	build[6] = WL.StructureType.Market
	build[7] = WL.StructureType.ArmyCache
	build[8] = WL.StructureType.MoneyCache
	build[9] = WL.StructureType.ResourceCache
	build[10] = WL.StructureType.MercenaryCamp -- real fort
	build[11] = WL.StructureType.Power
	build[12] = WL.StructureType.Draft
	build[13] = WL.StructureType.Arena
	build[14] = WL.StructureType.Hospital
	build[15] = WL.StructureType.DigSite
	build[16] = WL.StructureType.Attack
	build[17] =	WL.StructureType.Mortar
	build[18] = WL.StructureType.Recipe

	if type == 0 then return 0 end
	return build[type]
end

function Buildname(type)
	local build = {}

	build[1] = "City"
	build[2] = "Army Camp"
	build[3] = "Mine"
	build[4] = "Smelter"
	build[5] = "Crafter"
	build[6] = "Market"
	build[7] = "Army Cache"
	build[8] = "Money Cache"
	build[9] = "Resource Cache"
	build[10] = "Mercenary Camp" -- real fort
	build[11] = "Power"
	build[12] = "Man with Hand"
	build[13] = "Arena"
	build[14] = "Hospital"
	build[15] = "Dig Site"
	build[16] = "Artillery"
	build[17] =	"Mortar"
	build[18] = "Book"

	if type == 0 then return 0 end
	return build[type]
end
