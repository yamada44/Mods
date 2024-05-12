require('Utilities')

function Client_PresentSettingsUI(rootParent)

	local vert = UI.CreateVerticalLayoutGroup(rootParent)

	for i,v in pairs(Mod.Settings.Landdata)do
		Stats(v,vert)
	end

		


end

function Stats(data, vert)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local Data = data

	local Name = "<#DEF265>Terrain Name: </><#FF7AF3>" .. Data.C_Name .. "</>\n"
	UI.CreateLabel(row1).SetText("-------------").SetColor('#4EC4FF')
	UI.CreateLabel(row1).SetText("terrain Info type").SetColor('#4EC4FF')
	AddStringToUI(vert,Name,nil) -- Included first cause no terrain type might be found

	AddStringToUI(vert,"<#DEF265>AutoFind number: </><#FF7AF3>" .. Data.C_Autofind .. "</>\n",nil)
	AddStringToUI(vert,"<#DEF265>AutoFind port number: </><#FF7AF3>" .. Data.C_AutoP .. "</>\n",nil)

-- Settings Display
	local armyrules = Data.C_Value
		if armyrules == -1 then armyrules = "Keep current army Value" 
		else armyrules = "Army value changed to " .. armyrules end
	local ownerrules = Data.C_TerrainTypeID
			if ownerrules == 0 then ownerrules = "Terrain Owner is neutral"
			elseif ownerrules == nil then ownerrules = "No ownership change"
			else
				ownerrules = "Manual player ID input"
			end
	local Modrules = Data.C_Modsetting
			if Modrules == -1 then Modrules = "No Mods defined"
			elseif Modrules == 0 then Modrules = "All mods defined"
			elseif Modrules == 1 then Modrules = "Only Character pack mods defined"
			else Modrules = " Only " .. Characterpackloader(Modrules) .. " Characters Defined" end
	local unittype = Data.C_Unittype
			if unittype == 0 then unittype = "Entire Character pack Defined"
			else unittype = "The " .. unittype .. "th character unit type defined. (view settings for unit type)" end
	local Basesettings = Data.C_Inverse

			if Basesettings == 1 then Basesettings = "Apply function on terrain unless Special units (defined in settings) are detected"
			elseif Basesettings == 2 then Basesettings = "Apply function on on terrain and remove special units (defined in settings)"
			elseif Basesettings == 3 then Basesettings = "Apply function on terrain and Remove special units (defined in settings)"
			elseif Basesettings == 4 then Basesettings =  "Apply function on terrain except tiles with Specil units (defined in settings)" end
	local turn = Data.C_Turnstart
			if turn == 0 then turn = "Always active"
			else turn = "The Terrain last between the turns " .. Data.C_Turnstart .. " - " .. Data.C_Turnend - 1 end
	local build = Data.C_RemoveBuild
			if build == true then build = "Cities/Forts/Fort Tactics builds are removed" 
			else build = "no structures removed" end
			AddStringToUI(vert,"<#DEF265>Army Rules: </>" .. armyrules,nil)
			AddStringToUI(vert,"<#DEF265>Terrain ID: </>" .. ownerrules,nil)
			AddStringToUI(vert,"<#DEF265>Mod Special units: </>".. Modrules,nil)
			AddStringToUI(vert,"<#DEF265>Unit Type: </>" .. unittype,nil)
			AddStringToUI(vert,"<#DEF265>Base Rules: </>" .. Basesettings,nil)
			AddStringToUI(vert,"<#DEF265>Structure Rules: </>" .. build,nil)
			AddStringToUI(vert,"<#DEF265>Duration: </>" .. turn,nil)
			



end