require('Utilities')

function Client_PresentCommercePurchaseUI(rootParent, game, close)
	Close1 = close;
	Game = game;

	SettingData = Mod.Settings
	ID = Game.Us.ID

	-- changing over packs data
	OrderstartsWith = "FortX" -- the last letter represents the mod used

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	Xincrease = Mod.Settings.Costincrease
	local buildnumber = 0
	local turnscale = 0
	local combatinfo = "double that of standing army inside"

	if Mod.Settings.Scale > 0 then 
		turnscale = Howmany20(Game.Game.TurnNumber)
	end
	if Mod.Settings.Need == 0 then combatinfo = "0. will cancel attack before destroying Fort"
	elseif Mod.Settings.Need > 0 then combatinfo = Mod.Settings.Need + (turnscale * Mod.Settings.Scale) end
	if SettingData.Costincrease ~= 0 then
		for _,ts in pairs(Game.LatestStanding.Territories) do --ts is value of territories table
			if (ts.OwnerPlayerID == ID) then
				
				buildnumber = buildnumber + Buildnumber(ts.Structures)
			end
		end
	
	end

	--if buildnumber == 0 then buildnumber = 1 end
	Xincrease = Xincrease * buildnumber
	CostScale = 0
	if Mod.Settings.Market == true then 
		local percent = ((Mod.Settings.Need + (turnscale * Mod.Settings.Scale)) - Mod.Settings.Need) / Mod.Settings.Need
		CostScale = percent
		--if CostScale == 0 then CostScale = 1 end
	end
	print(CostScale,"scale")
	PreFinalcost = (SettingData.HiveCost + Xincrease)
	print(PreFinalcost,"pre",(PreFinalcost * CostScale),SettingData.HiveCost , Xincrease)
	local buttonmessage = "Build a Fort"
	local infomessage = "This Fort cost " .. math.floor(PreFinalcost + (PreFinalcost * CostScale)) .. "\nYou can only have ".. SettingData.Maxhives .. " at a time\nFort Combat power is " .. combatinfo

	UI.CreateLabel(row1).SetText(infomessage)
	UI.CreateButton(row1).SetText(buttonmessage).SetOnClick(PurchaseClicked).SetInteractable(true).SetFlexibleWidth(1)
	
end


function PurchaseClicked(type)
	--Check if they're already at max.  Add in how many they have on the map plus how many purchase orders they've already made
	--We check on the client for player convenience. Another check happens on the server, so even if someone hacks their client and removes this check they still won't be able to go over the max.
	local numUnitAlreadyHave = 0

	--checking orders for Building
	for _,order in pairs(Game.Orders) do
		if (order.proxyType == 'GameOrderCustom' and startsWith(order.Payload, OrderstartsWith)) then
			UI.Alert("Can only build 1 Fort per turn")
			return
		end
	end



	for _,ts in pairs(Game.LatestStanding.Territories) do --ts is value of territories table
		if (ts.OwnerPlayerID == ID) then
			numUnitAlreadyHave = numUnitAlreadyHave + Buildnumber(ts.Structures)
		end
	end


	if (numUnitAlreadyHave >= SettingData.Maxhives) then
		UI.Alert("You already have the Max amount of Forts")
		return
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
	TargetTerritoryInstructionLabel.SetText("Please click on the territory you wish to build your Fort on")
	SelectTerritoryBtn.SetInteractable(false);
end

function TerritoryClicked(terrDetails)
	SelectTerritoryBtn.SetInteractable(true)

		
			local amount = Buildnumber(Game.LatestStanding.Territories[terrDetails.ID].Structures)
			if amount >= SettingData.Limit  then UI.Alert("Can only have " .. SettingData.Limit .." Forts on a single territory") return end
	if (terrDetails == nil) then
		--The click request was cancelled.   Return to our default state.
		TargetTerritoryInstructionLabel.SetText("");
		SelectedTerritory = nil;
		BuyUnitBtn.SetInteractable(false);
	else
		--Territory was clicked, check it
		if (Game.LatestStanding.Territories[terrDetails.ID].OwnerPlayerID ~= Game.Us.ID) then
			TargetTerritoryInstructionLabel.SetText("You may only Build on a territory you own, please try again");
		else
			TargetTerritoryInstructionLabel.SetText("Selected territory: " .. terrDetails.Name);
			SelectedTerritory = terrDetails
			BuyUnitBtn.SetInteractable(true)
		end
	end
end

function CompletePurchaseClicked()




	local msg = 'The building of a Fort has begun on ' .. SelectedTerritory.Name
	local payload = OrderstartsWith .. ";;"..  SelectedTerritory.ID

	
	local orders = Game.Orders
	table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload,  { [WL.ResourceType.Gold] = math.floor(PreFinalcost + (PreFinalcost * CostScale))  } ))
	Game.Orders = orders;



	Close2();
end
