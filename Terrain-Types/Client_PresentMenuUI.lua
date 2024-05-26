require('Utilities')


function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	Pub = Mod.PublicGameData

	Game = game;
	Close = close;
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)

	ID = game.Us.ID


	setMaxSize(300, 250);
	if (game.Us == nil or game.Us.State ~= WL.GamePlayerState.Playing) then
		UI.CreateLabel(vert).SetText("You cannot Vote since you're not in the game")
		return;
	end

print(#AddStringToUI(row1,"<#4EC4FF>Get Tile Info</>",nil).List)
print(row1.GetPreferredWidth())

	--Ui.CreateLabel(vert)
	--AddStringToUI(row1,"<#4EC4FF>Tileoooooooo Ikjhklnfo</>",nil)
	UI.CreateButton(row1).SetText("Select Tile").SetColor('#0000FF').SetOnClick(function() Window(1,close,0) end)



end
function Window(window, close, data)
	
	if window == 1 then
		Game.CreateDialog(PresentBuyUnitDialog)
		close()
	elseif window == 2 then
		Game.CreateDialog(Stats)
		close()
	end
end

function PresentBuyUnitDialog(rootParent, setMaxSize, setScrollable, game, close)
	Close2 = close;
	Data = {}

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1); --set flexible width so things don't jump around while we change InstructionLabel

	SelectTerritoryBtn = UI.CreateButton(vert).SetText("Select Territory").SetOnClick(SelectTerritoryClicked)
	TargetTerritoryInstructionLabel = UI.CreateLabel(vert).SetText("")

	BuyUnitBtn = UI.CreateButton(vert).SetInteractable(false).SetText("View Info").SetOnClick(function () Window(2,close,0) end)

	SelectTerritoryClicked() --just start us immediately in selection mode, no reason to require them to click the button
end

function SelectTerritoryClicked() -- Needs type
	UI.InterceptNextTerritoryClick(TerritoryClicked);
	TargetTerritoryInstructionLabel.SetText("Please click on the territory you wish to see its Info")
	SelectTerritoryBtn.SetInteractable(false)
end

function TerritoryClicked(terrDetails)
	SelectTerritoryBtn.SetInteractable(true)

	if (terrDetails == nil) then
		--The click request was cancelled.   Return to our default state.
		TargetTerritoryInstructionLabel.SetText("")
		SelectedTerritory = nil
		BuyUnitBtn.SetInteractable(false)

	else

			TargetTerritoryInstructionLabel.SetText("Selected territory: " .. terrDetails.Name)
			SelectedTerritory = terrDetails
			BuyUnitBtn.SetInteractable(true)
			local type = Pub.Terrain[terrDetails.ID].Type
			Data = Pub.Types[type]
	end
end

function Stats(rootParent, setMaxSize, setScrollable, game, close)
	local vert = UI.CreateVerticalLayoutGroup(rootParent) -- UI setup
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	setMaxSize(500, 400);

	UI.CreateLabel(row1).SetText("Tile Info").SetColor('#4EC4FF')
	local Name = "<#DEF265>Terrain Name: </><#FF7AF3>" .. Data.name .. "</>\n"

	AddStringToUI(vert,Name,nil) -- Included first cause no terrain type might be found

	if Data.turnstart ~= nil then -- making sure a terrain type exist

-- Settings Display
	local armyrules = Data.armyValueChange
		if armyrules == -1 then armyrules = "Keep current army Value" 
		else armyrules = "Army value changed to " .. armyrules end
	local ownerrules = Data.OwnerID
			if ownerrules == 0 then ownerrules = "Terrain Owner is neutral"
			elseif ownerrules == nil then ownerrules = "No ownership change"
			else 
				ownerrules = "Terrain Owner changed to " .. game.Game.Players[ownerrules].DisplayName(nil, false)
			end
	local ModData = Data.ModFormat
	local Modrules = ""
	for i, v in pairs(ModData) do
		local typedata = v.type
		if typedata == 0 then typedata = "Entire pack" end
			if v.mod == 0 then Modrules = Modrules .. "\nAll Special units defined"
			elseif v.mod == 1 then Modrules = Modrules .. "\nOnly Character pack mods defined || Unit type: " .. typedata 
			else Modrules = Modrules .. "\n" .. Characterpackloader(v.mod) .. " Characters Defined || Unit type: " .. typedata end
	end
	local Basesettings = Data.BaseSettings

			if Basesettings == 1 then Basesettings = "Apply effects on terrain type unless Special units (defined in settings) are detected"
			elseif Basesettings == 2 then Basesettings = "Apply effects on on terrain and remove special units (defined in settings)"
			elseif Basesettings == 3 then Basesettings = "Apply effects on terrain and Remove special units (defined in settings)"
			elseif Basesettings == 4 then Basesettings =  "Apply effects on terrain except tiles with Specil units (defined in settings)" end
	local turn = Data.turnstart
			if turn == 0 then turn = "Always active"
			else turn = "The Terrain last between the turns " .. Data.turnstart .. " - " .. Data.turnend - 1 end

			AddStringToUI(vert,"<#DEF265>Army Rules: </>" .. armyrules,nil)
			AddStringToUI(vert,"<#DEF265>Terrain ID: </>" .. ownerrules,nil)
			AddStringToUI(vert,"<#DEF265>Special units defined: </>".. Modrules,nil)
			AddStringToUI(vert,"<#DEF265>Base Rules: </>" .. Basesettings,nil)
			AddStringToUI(vert,"<#DEF265>Duration: </>" .. turn,nil)
	end



end