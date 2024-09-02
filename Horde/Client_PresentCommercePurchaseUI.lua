require('Utilities')

function Client_PresentCommercePurchaseUI(rootParent, game, close)
	Close1 = close;
	Game = game;

	SettingData = Mod.Settings
	ID = Game.Us.ID

	-- changing over packs data
	OrderstartsWith = "Zom" -- the last letter represents the mod used

	print(game.Settings.Name, "map name")
	if game.Settings.Name == "Immersive system - The last of us Game  .9.0.2" then
		print("game found")
	end
print (SettingData.Slot, Game.Us.Slot )
	local isZom = false
	for i = 1, #Mod.Settings.Slot do
		if SettingData.Slot[i] == Game.Us.Slot or SettingData.Slot[i] == 0 then 
			isZom = true
		end end
		if isZom == false then
		UI.CreateLabel(rootParent).SetText("This Slot cannot build a "..Mod.Settings.Buildname) return end

	if SettingData.StructureType == 0 then
		UI.CreateLabel(rootParent).SetText("No building types for this Game")
		return end
	if SettingData.Maxhives == 0 then
		UI.CreateLabel(rootParent).SetText("This structure " .. Mod.Settings.Buildname .. " can be played with but not built by players")
		return end

	local vert = UI.CreateVerticalLayoutGroup(rootParent);
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local buttonmessage = "Build a " .. Mod.Settings.Buildname
	local infomessage = "This Structure cost " .. SettingData.HiveCost .. "\nYou can only have ".. SettingData.Maxhives .. " at a time"

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
			UI.Alert("Can only build 1 " .. Mod.Settings.Buildname .. " per turn")
			return
		end
	end



	for _,ts in pairs(Game.LatestStanding.Territories) do --ts is value of territories table
		if (ts.OwnerPlayerID == ID) then
			numUnitAlreadyHave = numUnitAlreadyHave + Buildnumber(ts.Structures)
		end
	end


	if (numUnitAlreadyHave >= SettingData.Maxhives) then
		UI.Alert("You already have the Max amount of " .. Mod.Settings.Buildname)
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
	TargetTerritoryInstructionLabel.SetText("Please click on the territory you wish to build your " .. Mod.Settings.Buildname .. " on")
	SelectTerritoryBtn.SetInteractable(false);
end

function TerritoryClicked(terrDetails)
	SelectTerritoryBtn.SetInteractable(true);

	if (terrDetails == nil) then
		--The click request was cancelled.   Return to our default state.
		TargetTerritoryInstructionLabel.SetText("")
		SelectedTerritory = nil
		BuyUnitBtn.SetInteractable(false)
	else
		--Territory was clicked, check it
		if (Game.LatestStanding.Territories[terrDetails.ID].OwnerPlayerID ~= Game.Us.ID) then
			TargetTerritoryInstructionLabel.SetText("You may only Build on a territory you own, please try again")
		else
			TargetTerritoryInstructionLabel.SetText("Selected territory: " .. terrDetails.Name)
			SelectedTerritory = terrDetails
			BuyUnitBtn.SetInteractable(true)
		end
	end
end

function CompletePurchaseClicked()




	local msg = 'Building a ' .. Mod.Settings.Buildname .. ' on ' .. SelectedTerritory.Name
	local payload = OrderstartsWith .. ";;"..  SelectedTerritory.ID

	
	local orders = Game.Orders
	table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload,  { [WL.ResourceType.Gold] = SettingData.HiveCost } ))
	Game.Orders = orders;



	Close2();
end
