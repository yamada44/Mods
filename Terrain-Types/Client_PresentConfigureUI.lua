
function Client_PresentConfigureUI(rootParent)

	Maxpictures = 5

NewrootParent = rootParent
InputFieldTable = {}
TempUI = {}
Minterrain = 1
Maxterrain = 8

  if (not WL.IsVersionOrHigher or not WL.IsVersionOrHigher("5.21")) then
	  UI.Alert("You must update your app to the latest version to use this mod");
	  return;
  end


  if Mod.Settings.Landdata == nil then Mod.Settings.Landdata = {} end --Init variables
   landconfig =	Mod.Settings.Landdata



  local vert0 = UI.CreateVerticalLayoutGroup(rootParent);
  UI.CreateLabel(vert0).SetText('Tip 1: If UI messes up, uncheck mod box and recheck\nTip 2: note Loading terrain types might take a second\nTip 3: You may have a old template. remove mod, save template and reinstall mod').SetColor('#F3FFAE');

--Set up access point and max values
  if Mod.Settings.access == nil then Mod.Settings.access = 1 end
   access = Mod.Settings.access
   if Mod.Settings.BeforeMax == nil then Mod.Settings.BeforeMax = 1 end
   BeforeMax = Mod.Settings.BeforeMax


-- End of Init


  

  local vert2 = UI.CreateVerticalLayoutGroup(rootParent)


-- setting up amount of terrain types
  local row0 = UI.CreateHorizontalLayoutGroup(vert2);
  UI.CreateButton(row0).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("This determines the amount of terrain types you can create at once\nMax Terrains allowed is ".. Maxterrain) end)
  InputFieldTable.text0 = UI.CreateLabel(row0).SetText('How many terrain Types')
  InputFieldTable.TerrainTypeMax = UI.CreateNumberInputField(row0)
	  .SetSliderMinValue(Minterrain)
	  .SetSliderMaxValue(Maxterrain)
	  .SetValue(BeforeMax)
	  TerrainTypeMax = InputFieldTable.TerrainTypeMax.GetValue()


  RefreshButton = UI.CreateButton(row0).SetText("Refresh").SetColor("#00DD00").SetOnClick(TerrainCreation)

  if (access == 3 )then 
		  UI.Alert('Tip: If UI messes up, uncheck mod box and recheck')
  end
  if access == 2 or access == 3 then
	  TerrainCreation()
  end
end


function TerrainCreation()
TerrainTypeMax = InputFieldTable.TerrainTypeMax.GetValue()

  if access == 2 then -- Setting up UI again
	  UI.Alert('Regenerated UI Types')
	  Destroy()
	  
  end
  if TerrainTypeMax < Minterrain or TerrainTypeMax > Maxterrain then  -- making sure land types are between Min and max values (values can be found at top of screen)
  UI.Alert('Max unit types ' .. Maxterrain .. ' .\nMin unit types '..Minterrain..'\n Reset to Default settings')
  TerrainTypeMax = 1
  end


  for i = 1, TerrainTypeMax do -- looping through all the land templates so you dont have to repeat code
	  local vert = UI.CreateVerticalLayoutGroup(NewrootParent);
	  local color = '#FF697A' -- redish
	  local templatetext = 'Empty Terrain Template: '.. i

	  if landconfig[i] == nil then landconfig[i] = {} end -- making sure the tables exist
	  if InputFieldTable[i] == nil then InputFieldTable[i] = {} end

	  --checking to see if your templates have been created already
	  InputFieldTable[i].TempCreated = landconfig[i].TempCreated
	  if InputFieldTable[i].TempCreated == nil then InputFieldTable[i].TempCreated = false 
	  elseif InputFieldTable[i].TempCreated == true then 
		  TempAlreadyCreated(i)
		  templatetext = 'Stored ' .. landconfig[i].C_Name .. ' Template'
		  color = '#00E9FF'
	  end
	  InputFieldTable[i].TemplateStored = landconfig[i].TemplateStored
	  if InputFieldTable[i].TemplateStored == nil then InputFieldTable[i].TemplateStored = false end

	  -- creating row for first UI group
	  InputFieldTable[i].row000 = UI.CreateHorizontalLayoutGroup(vert);
	  local row000 = InputFieldTable[i].row000

	  InputFieldTable[i].text180 = UI.CreateLabel(row000).SetText(templatetext).SetColor(color)    
	  InputFieldTable[i].Template = UI.CreateCheckBox(row000).SetIsChecked(false).SetText('').SetOnValueChanged(function () Unittemplates(vert, i)end)
		  
  end

  access = 2
  BeforeMax = TerrainTypeMax
InputFieldTable.BeforeMax = TerrainTypeMax
end

function Unittemplates(vert, i)

		  InputFieldTable[i].TempCreated = true
		  InputFieldTable[i].Template.SetInteractable(false) 
		  InputFieldTable[i].TemplateStored = false

	  local auto = landconfig[i].C_Autofind -- initializing all of the defaults if nil
	  if (auto == nil ) then auto = 3 end 

	  local autoport = landconfig[i].C_AutoP -- for compatiblelity with other autofind settings
	  if (autoport == nil ) then autoport = 3 end 

	  local value = landconfig[i].C_Value -- the army value the tile is set to
	  if value == nil then value = 0 end
	  
	  local name = landconfig[i].C_Name -- the name of the terrain
	  if (name == nil ) then name = '' end 

	  local turnS = landconfig[i].C_Turnstart -- what turn do these affects apply
	  if (turnS == nil ) then turnS = 0 end 

	  local turnE = landconfig[i].C_Turnend -- what turn do these affects stop
	  if (turnE == nil ) then turnE = 0 end 

	  local id = landconfig[i].C_TerrainTypeID -- set change ID upon game start
	  if (id == nil ) then id = 0 end 

	  local invert = landconfig[i].C_Inverse
	  if (invert == nil ) then invert = 1 end 

	  local modsetting = landconfig[i].C_Modsetting
	  if (modsetting == nil ) then modsetting = 0 end 

	  local type = landconfig[i].C_Unittype
	  if (type == nil ) then type = 0 end 

	  local build = landconfig[i].C_RemoveBuild
	  if (build == nil ) then build = true end 

	  --local portL = landconfig[i].C_Portlogic
	  --if (portL == nil ) then portL = 0 end 
	  --setting up the UI and all its fields





  --AutoFind number
  InputFieldTable[i].row1 = UI.CreateHorizontalLayoutGroup(vert)
  local row1 = InputFieldTable[i].row1
  InputFieldTable[i].text1 = UI.CreateLabel(row1).SetText('Terrain Type '..i).SetColor('#00D4FF')
  InputFieldTable[i].text2 = UI.CreateLabel(row1).SetText("Base AutoFind Number: ")
  InputFieldTable[i].C_Autofind = UI.CreateNumberInputField(row1)
	  .SetSliderMinValue(3)
	  .SetSliderMaxValue(1000)
	  .SetValue(auto);
	  UI.CreateButton(row1).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("Any territroy that has this army number on game creation will be added to this terrain type"); end);

	  -- Autofind for ports (second autoFind)
	  InputFieldTable[i].row2 = UI.CreateHorizontalLayoutGroup(vert)
	  local row2 = InputFieldTable[i].row2
	  UI.CreateButton(row2).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("A second Autofind number To make compatible with other auto placer/Autofind functions in other mods or other terrain types\nSet to the same number as autofind to disable") end);
	  InputFieldTable[i].text3 = UI.CreateLabel(row2).SetText('Port AutoFind ').SetColor('#dbddf4')
	  InputFieldTable[i].C_AutoP = UI.CreateNumberInputField(row2)
	  .SetSliderMinValue(0)
	  .SetSliderMaxValue(1000)
	  .SetValue(autoport)

	--Port logic
	--[[InputFieldTable[i].row22 = UI.CreateHorizontalLayoutGroup(vert)
	local row22 = InputFieldTable[i].row22
	UI.CreateButton(row22).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("1 - Same logic as base Autofind\n2 - Does not change ownership\n3 - Does not remove armies\n4 - Does not change ownership or remove armies") end)
	InputFieldTable[i].text24 = UI.CreateLabel(row22).SetText('Logic for Port AutoFind')
	InputFieldTable[i].C_Portlogic = UI.CreateNumberInputField(row22)
	.SetSliderMinValue(1)
	.SetSliderMaxValue(4)
	.SetValue(portL)
]]--
	  --Value land turned to
	  InputFieldTable[i].row20 = UI.CreateHorizontalLayoutGroup(vert)
	  local row20 = InputFieldTable[i].row20
	  UI.CreateButton(row20).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("What army value should the territory have when the terrain effect is applied\nSet to -1 to not change army value at all") end)
	  InputFieldTable[i].text22 = UI.CreateLabel(row20).SetText('Army Value function')
	  InputFieldTable[i].C_Value = UI.CreateNumberInputField(row20)
	  .SetSliderMinValue(-1)
	  .SetSliderMaxValue(500)
	  .SetValue(value)

	  --Start turn
	  InputFieldTable[i].row15 = UI.CreateHorizontalLayoutGroup(vert)
	  local row15 = InputFieldTable[i].row15
	  UI.CreateButton(row15).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("What turn does this terrain type function Begin\nSet turn start to -1 to disable the turn effect\nSet to 0 to start the game with the affect applied on game start") end)
	  InputFieldTable[i].text17 = UI.CreateLabel(row15).SetText('Turn Start').SetColor('#dbddf4')
	  InputFieldTable[i].C_Turnstart = UI.CreateNumberInputField(row15)
	  .SetSliderMinValue(-1)
	  .SetSliderMaxValue(100)
	  .SetValue(turnS)

	  --End turn
	  InputFieldTable[i].row3 = UI.CreateHorizontalLayoutGroup(vert)
	  local row3 = InputFieldTable[i].row3
	  UI.CreateButton(row3).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("What turn does this terrain type function end\nSet turn start to 0 to disable the turn effect") end)
	  InputFieldTable[i].text4 = UI.CreateLabel(row3).SetText('Turn End')
	  InputFieldTable[i].C_Turnend = UI.CreateNumberInputField(row3)
	  .SetSliderMinValue(0)
	  .SetSliderMaxValue(100)
	  .SetValue(turnE)

  -- ownerID
  InputFieldTable[i].row10 = UI.CreateHorizontalLayoutGroup(vert)
  local row10 = InputFieldTable[i].row10
  UI.CreateButton(row10).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("When the terrain type function applies, whos ownership does it turn to.\nset to 0 for neutral\nset to -1 for first territroy found use that ID for the remainder of that terrain type\nSet to -2 to not change ID at all\nSet to -3 for all current owners of each tile to be remembered\nManual playerID is accepted as well, for AI use this logic, AI1 is 1, AI2 is 2 ect. changes to neutral if error is found"); end)
  InputFieldTable[i].text12 = UI.CreateLabel(row10).SetText('Default ownership function').SetColor('#dbddf4')
  InputFieldTable[i].C_TerrainTypeID = UI.CreateNumberInputField(row10)
  .SetSliderMinValue(-3)
  .SetSliderMaxValue(9999)
  .SetValue(id)

  -- Mod Settings
  InputFieldTable[i].row11 = UI.CreateHorizontalLayoutGroup(vert)
  local row11 = InputFieldTable[i].row11
  UI.CreateButton(row11).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("What mod special units are defined \n0 - All mods defined\n1 - only Character packs mods defined\n2 - Antiquity \n3 - Ship props \n4 - Heros \n5 - Asian \n6 - World war \n7 - Greek Gods \n8 - Medieval \n9 - Medieval props \n10 - Modern \n11 - Monsters \n12 - People Gangsters \n13 - Game of thrones \n14 - Star wars \n15 - Star wars props \n16 - Victorian \n17 - Muv Luv 1 \n18 - Muv Luv Beta/Human") end)
  InputFieldTable[i].text13 = UI.CreateLabel(row11).SetText('What Mod is defined')
  InputFieldTable[i].C_Modsetting = UI.CreateNumberInputField(row11)
  .SetSliderMinValue(0)
  .SetSliderMaxValue(18)
  .SetValue(modsetting)


	--Unit type
	InputFieldTable[i].row22 = UI.CreateHorizontalLayoutGroup(vert)
	local row22 = InputFieldTable[i].row22
	UI.CreateButton(row22).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("What unit type template in character pack does this work with\nOnly works if the setting directly above is between 2 and 18\nSet to 0 for the entire character pack to applie or disable this feature ") end)
	InputFieldTable[i].text24 = UI.CreateLabel(row22).SetText('What Character pack unit type special unit is defined')
	InputFieldTable[i].C_Unittype = UI.CreateNumberInputField(row22)
	.SetSliderMinValue(0)
	.SetSliderMaxValue(8)
	.SetValue(type)

	-- Inverse
	local row100 = UI.CreateHorizontalLayoutGroup(vert) -- Inverse Special unit logic
	UI.CreateButton(row100).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("1 - Apply terrain type function(s) on all tiles with AutoFind/Port AutoFind unless Special units(defined in settings) are detected, then skip that tile\n2 - Apply all function(s) in Autofind/Portfind and remove special units(defined in settings)\n3 - Apply all functions on every tile not found in any other terrain type and Remove special units (defined in settings)\n4 - Apply all functions on every tile not found in any other terrain type, except tiles with Specil units(defined in settings) and skip that tile\n") end)
	UI.CreateLabel(row100).SetText('Standard Setting')
	InputFieldTable[i].C_Inverse = UI.CreateNumberInputField(row100)
	.SetSliderMinValue(1)
	.SetSliderMaxValue(4)
	.SetValue(invert)

	local row99 = UI.CreateHorizontalLayoutGroup(vert) -- can play Diplo cards
	UI.CreateButton(row99).SetText("?").SetColor('#0000FF').SetOnClick(function() UI.Alert("remove cities, Armycamps and Mercenary camp\nThis setting works with all Standard settings") end)
	UI.CreateLabel(row99).SetText('Remove buildings')
	InputFieldTable[i].C_RemoveBuild = UI.CreateCheckBox(row99).SetText("").SetIsChecked(build)

	--name of Terrain type
	InputFieldTable[i].row5 = UI.CreateHorizontalLayoutGroup(vert)
	local row5 = InputFieldTable[i].row5
	InputFieldTable[i].text9 = UI.CreateLabel(row5).SetText('Name of Terrain')
	InputFieldTable[i].C_Name = UI.CreateTextInputField(vert)
	.SetPlaceholderText(" Name of Terrain Type        ").SetText(name)
	.SetFlexibleWidth(1)
	.SetCharacterLimit(50)

	--spacer
	InputFieldTable[i].row8 = UI.CreateHorizontalLayoutGroup(vert)
	local row8 = InputFieldTable[i].row8
	InputFieldTable[i].text10 = UI.CreateEmpty(row8)
	InputFieldTable[i].text11 = UI.CreateLabel(row8).SetText('\n')


end
function TempAlreadyCreated(i)
print('template already created access')

InputFieldTable[i].TemplateStored = true

	for T, v in pairs (landconfig[i]) do
		if startsWith(T, "C_") then
			InputFieldTable[i][T] = landconfig[i][T]
		end
	end

end

function Destroy()

  for D = 1, BeforeMax do  -- deleting UI before generating a new one

	if InputFieldTable[D].Template.GetIsChecked() == true then -- if true, that means UI was not generated and can skip
		for i,v in pairs(InputFieldTable[D])do 
			UI.Destroy(InputFieldTable[D][i])
		end
	else 
		UI.Destroy(InputFieldTable[D].text180)
		UI.Destroy(InputFieldTable[D].Template)
	end

	landconfig[D] = {}

  end
  access = 1

end
