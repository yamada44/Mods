require('Utilities')

-- Things to add to GameCreation settings
-- Max turns

function Client_PresentMenuUI(rootParent, setMaxSize, setScrollable, game, close)
	Game = game;
	Close = close;
	publicdate = Mod.PublicGameData
	
	local window = {rootParent, setMaxSize, setScrollable, game, close,true}

	if (game.Us == nil or game.Us.State ~= WL.GamePlayerState.Playing) then
		UI.CreateLabel(rootParent).SetText("You cannot gift gold since you're not in the game")
		return
	end
	if (game.Settings.CommerceGame == false) then
		UI.CreateLabel(rootParent).SetText("This mod only works in commerce games.  This isn't a commerce game.");
		return;
	end
-- updated features here
	GlobalFarm(game.Us.ID)

	--updating all Entities
	Serverload(nil,-1,-1,-1)

	MainMenuID(window)



end

--Ui info for your account
function CreateAccount(rootParent, setMaxSize, setScrollable, game, close)
	--Create the entity then preform a single payment
	setMaxSize(500, 450)

	Accountincome = Entities[GlobalID].Gold 
	table.insert(Ownerlist,GlobalID)

	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row00 = UI.CreateHorizontalLayoutGroup(vert)
	local row0 = UI.CreateHorizontalLayoutGroup(vert)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateHorizontalLayoutGroup(vert)
	local row5 = UI.CreateHorizontalLayoutGroup(vert)
	local rowbefore6 = UI.CreateHorizontalLayoutGroup(vert)
	local row6 = UI.CreateHorizontalLayoutGroup(vert)
	local row7 = UI.CreateHorizontalLayoutGroup(vert)
	local row8 = UI.CreateHorizontalLayoutGroup(vert)



	-- Name of account
	AddStringToUI(row00,"<#ffffff>Cost to create account: </><#ee882f>" .. AccountCost .. "</>",nil)
	AddStringToUI(vert,"<#ffffff>Name your account</>",nil)
	AcountName = UI.CreateTextInputField(vert).SetPlaceholderText(" Name of account          ").SetFlexibleWidth(1).SetCharacterLimit(25)
	
	--Inial Deposit
	UI.CreateLabel(row1).SetText('Inial Deposit ')
	GoldInput = UI.CreateNumberInputField(row1)
	.SetSliderMinValue(1)
	.SetSliderMaxValue(Accountincome)
	.SetValue(1)

	-- Kick rate
	UI.CreateLabel(row2).SetText('Voting requirment to kick owners ')
	KickInput = UI.CreateNumberInputField(row2)
	.SetSliderMinValue(1)
	.SetSliderMaxValue(100)
	.SetValue(60)

	--Add Owners
	UI.CreateLabel(row3).SetText("Add Owner to account ") -- selecting player
	TargetOwnerBtn = UI.CreateButton(row3).SetText("Select player...").SetOnClick(function () TargetPlayerClicked(0) end)
	--Add memeber
	UI.CreateLabel(row4).SetText("Add member to account ") -- selecting player
	TargetMemberBtn = UI.CreateButton(row4).SetText("Select player...").SetOnClick(function () TargetPlayerClicked(1) end)

	--Showing Owners/Members list
	AddStringToUI(row5,"<#ffffff>Owners ------</>",nil)
	AddStringToUI(rowbefore6,"<#1edc00>" .. Entities[GlobalID].Name .. "</>",nil)

	Ownernames = UI.CreateLabel(row6).SetText("")
	AddStringToUI(row7,"<#ffffff>Members ------</>",nil)
	membernames = UI.CreateLabel(row8).SetText("")



		Subbtn = UI.CreateButton(vert).SetText("Create Account").SetOnClick(function () SubmitClicked(close,0,1,Memberlist)end).SetInteractable(true).SetColor('#0021FF')

end
-- UI for The current accounts your currently in
function YourAccount(rootParent, setMaxSize, setScrollable, game, close)
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	UI.CreateLabel(row1).SetText("Your Accounts ").SetColor('#00F4FF')

	for i,v in pairs(Values2Table_key(Entities[GlobalID].YourAccounts,"AID")) do 
		local row2 = UI.CreateHorizontalLayoutGroup(vert)

		UI.CreateButton(row2).SetText("Account: " .. v.Name).SetOnClick(function () Dialogwindow(9,close,v) end )
	end

end
-- Your current open account
function OpenAccount(rootParent, setMaxSize, setScrollable, game, close)

	setMaxSize(500, 450)
	local Ent = Datatransfer
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row0 = UI.CreateHorizontalLayoutGroup(vert)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateHorizontalLayoutGroup(vert)
	local row5 = UI.CreateHorizontalLayoutGroup(vert)
	local row6 = UI.CreateHorizontalLayoutGroup(vert)
	local rowAfter6 = UI.CreateHorizontalLayoutGroup(vert)
	local row7Over = UI.CreateHorizontalLayoutGroup(vert)
	local rowSide = UI.CreateHorizontalLayoutGroup(vert)
	local row8 = UI.CreateVerticalLayoutGroup(rowSide)
	local row9 = UI.CreateVerticalLayoutGroup(rowSide)
	local IsOwner = FindmatchID(Ent.owners,GlobalID,2)

	--Account Name
	AddStringToUI(row0,"<#e09e3b>Account Name:</> <#0b9dff>" .. Ent.Name .. "</>",nil)

	-- Funds
	AddStringToUI(row1,"<#FFFFFF>Total Funds: </><#f8ff0b>" .. Ent.Gold .. "</>",nil)


	-- Change User
	AddStringToUI(row2,"<#FFFFFF>Transactions </>",nil)
	UI.CreateButton(row2).SetText("Open ...").SetOnClick(function () ChangeUserID(Ent.ID,close) end).SetInteractable(IsOwner)

	-- Reveal Funds
	AddStringToUI(row3,"<#FFFFFF>Reveal Funds to host</>",nil)
	UI.CreateCheckBox(row3).SetText("").SetIsChecked(Ent.Reveal).SetOnValueChanged(function () Serverload(close,nil,15,Ent.ID,"king") end).SetInteractable(IsOwner)

	-- kicking/Add/Leaving from account
	UI.CreateButton(row6).SetText("Notes").SetOnClick(function ()  Dialogwindow(12,close,Ent.ID) end)
	UI.CreateButton(row6).SetText("Owner History").SetOnClick(function ()  Dialogwindow(13,close,Ent.OwnerHistory) end)
	UI.CreateButton(rowAfter6).SetText("Kick/Add").SetOnClick(function () Dialogwindow(10,close,Ent.ID) end ).SetInteractable(IsOwner)
	UI.CreateButton(rowAfter6).SetText("Leave Account").SetOnClick(function () Serverload(close,GlobalID,9,Ent.ID,nil) end)
	--Voting Logic
	if Ent.KVote ~= nil then
		Votinglogic(Ent,row7Over,close)
	end 
	--Showing Owners/Members list  3be0df
	AddStringToUI(row8,"<#e09e3b>Owners ------</>",nil)
	AddStringToUI(row9,"<#e09e3b>Members ------</>",nil)

	for i,v in pairs (Values2Table(Ent.owners)) do
		AddStringToUI(row8,"<#3be0df>".. v.Name .. "</>",nil)

	end

	for i,v in pairs (Values2Table(Ent.members)) do
		local color = "#FF697A"
		if 	v.YourAccounts[Findmatch(v.YourAccounts,Ent.ID,"AID")].Turnadded + TurnsNeededInAccount < game.Game.TurnNumber then color = "#3be0df"  end
			UI.CreateLabel(row9).SetText(v.Name).SetColor(color)

	end
end
	

-- UI for All accounts that exist
function AllAccounts(rootParent, setMaxSize, setScrollable, game, close)

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local SortedTable = SortTable(Entities,"Gold")
	UI.CreateLabel(row1).SetText("All Accounts ").SetColor('#00F4FF')


	for i,v in pairs(SortedTable) do 
		if v.Status == "A" then
			local row2 = UI.CreateHorizontalLayoutGroup(vert)
			UI.CreateButton(row2).SetText("Account: " .. v.Name).SetOnClick(function () Dialogwindow(11,close,v) end )
		end
	end
end
--PeakAccount
function PeakAccount(rootParent, setMaxSize, setScrollable, game, close)

	setMaxSize(400, 420)
	local Ent = Datatransfer
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local row0 = UI.CreateVerticalLayoutGroup(vert)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local rowSide = UI.CreateHorizontalLayoutGroup(vert)
	local row8 = UI.CreateVerticalLayoutGroup(rowSide)
	local row9 = UI.CreateVerticalLayoutGroup(rowSide)
	local Funds = "<#ffffff>Gold Estimate: </><#f2ee00>" .. Ent.lowEstimate .. "</>- <#f2ee00>" ..  Ent.highEstimate .. "</>"
	if Ent.Reveal then Funds = "Gold Revealed: <#f2ee00>" .. Ent.Gold .. "<#f2ee00>" end


	AddStringToUI(row0,"<#ffffff>Account Name: </><#b2efe0>" .. Ent.Name .. "</>",nil)

	-- Funds
	AddStringToUI(row1,Funds,nil)
	--Owner History button
	UI.CreateButton(row2).SetText("Owner History").SetOnClick(function ()  Dialogwindow(13,close,Ent.OwnerHistory) end)


	--Showing Owners/Members list

	AddStringToUI(row8,"<#ffffff>Owners ------</>",nil)
	AddStringToUI(row9,"<#ffffff>Members ------</>",nil)

	for i,v in pairs (Values2Table(Ent.owners)) do
		AddStringToUI(row8,"<#b2efe0>".. v.Name .. "</>",nil)

	end

	for i,v in pairs (Values2Table(Ent.members)) do
		local color = "#FF697A"
		if 	v.YourAccounts[Findmatch(v.YourAccounts,Ent.ID,"AID")].Turnadded + TurnsNeededInAccount < game.Game.TurnNumber then color = "#0021FF"  end
			UI.CreateLabel(row9).SetText(v.Name).SetColor(color)

	end

end

--UI for single payments gifting gold
function Giftgold(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(450, 320)
	local vert = UI.CreateVerticalLayoutGroup(rootParent)
	local GoldHave = Entities[GlobalID].Gold

 -- creating rows
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)

	local row4 = UI.CreateHorizontalLayoutGroup(vert)

	UI.CreateLabel(row1).SetText("Gift gold to this player: ") -- selecting player
	TargetPlayerBtn = UI.CreateButton(row1).SetText("Select player...").SetOnClick(function() TargetEntityClicked(-1) end)

	UI.CreateLabel(row2).SetText('Amount of gold to give away: ') -- selecting gold amount
    GoldInput = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(GoldHave)
		.SetValue(1)

-- enacting the gift gold logic	
	Giftbtn = UI.CreateButton(vert).SetText("Gift").SetOnClick(function () SubmitClicked(close,0)end).SetInteractable(false).SetColor('#0021FF')

	--Tax logic
	GoldText = UI.CreateTextInputField(vert).SetPlaceholderText("Describe Gold Gift (Optional)").SetFlexibleWidth(1).SetCharacterLimit(25)


	Reveal = UI.CreateCheckBox(row4).SetText("Reveal Gold amount").SetIsChecked(true)

end
-- UI for Set turns 
function SetTurns(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(500, 320)
	if Mod.Settings.Plan ~= nil then
		MaxTurns = Mod.Settings.Plan
	end

	Max75 = math.floor(Entities[GlobalID].Income * 0.75)

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateHorizontalLayoutGroup(vert)

	UI.CreateLabel(row1).SetText("Gift gold to this player: ") -- selecting player
	TargetPlayerBtn = UI.CreateButton(row1).SetText("Select player...").SetOnClick(function() TargetEntityClicked(-1)end)

	UI.CreateLabel(row2).SetText("The amount of gold to send per turn")
    GoldSetbtn = UI.CreateNumberInputField(row2)
		.SetSliderMinValue(1)
		.SetSliderMaxValue(Max75)
		.SetValue(1)

	UI.CreateLabel(row3).SetText("The amount of turns this process will last")
    TurnSetbtn = UI.CreateNumberInputField(row3)
		.SetSliderMinValue(2)
		.SetSliderMaxValue(MaxTurns)
		.SetValue(2).SetInteractable(false)

		Cont = UI.CreateCheckBox(row4).SetText("Locked ").SetIsChecked(Contbool).SetOnValueChanged(Numberson)
		Reveal = UI.CreateCheckBox(row4).SetText("Reveal Gold amount").SetIsChecked(true).SetInteractable(false)
		AdvanceBtn = UI.CreateButton(row4).SetText("Gift").SetOnClick(function () SubmitClicked(close,0)end).SetInteractable(false).SetColor('#0021FF')
		GoldText = UI.CreateTextInputField(vert).SetPlaceholderText("Describe Gold Gift (optional)").SetFlexibleWidth(1).SetCharacterLimit(25)


		UI.CreateLabel(vert).SetText("You cannot cancel this payment early if the 'Locked' button is selected").SetColor('#E5FF00')

end
-- UI display for current plans
function Plans(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(560, 320)
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	if publicdate.PayP ~= nil and #publicdate.PayP.Plan > 0 then

		local row0 = UI.CreateHorizontalLayoutGroup(vert)
		local sortedPlans = SortTable(publicdate.PayP.Plan,"Turntill")
		for i = 1, #sortedPlans do
			local rowT = UI.CreateHorizontalLayoutGroup(vert)
	
			local playername = Entities[sortedPlans[i].ID].Name
			if temphidden == true then playername = "???" end
			UI.CreateLabel(rowT).SetText(playername ).SetColor('#FFE5B4')
			UI.CreateLabel(rowT).SetText( " sends " .. sortedPlans[i].aftertax .. " gold per turn to ").SetColor('#FF697A')
			UI.CreateLabel(rowT).SetText(Entities[sortedPlans[i].targetplayer].Name .. "  ").SetColor('#FFE5B4')

			print(sortedPlans[i].cont,"cont")
			if sortedPlans[i].cont == 2 then -- Set amount

				UI.CreateLabel(rowT).SetText("  Turns left: " .. sortedPlans[i].Turntill - game.Game.TurnNumber).SetColor('#00B5FF')

			elseif sortedPlans[i].cont == 1 then -- only continues
				local mind = true
				if sortedPlans[i].ID ~= GlobalID then mind = false end
				UI.CreateButton(rowT).SetText("Cancel Plan").SetColor('#1274A4').SetOnClick(function () SubmitClicked(close,i)end).SetInteractable(mind)
			end
		end
	else 
		UI.CreateLabel(vert).SetText("No payment plans have been created")
	end
end
-- Main UI display for all history functions
function History(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(500, 450)
	Destroygroup = {}

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row0 = UI.CreateHorizontalLayoutGroup(vert)

	
	if publicdate.PayP ~= nil and #publicdate.PayP.History > 0 then
	OptionA = UI.CreateButton(row0).SetText("Total payments").SetInteractable(true).SetColor('#0021FF').SetOnClick(function () OptionAfunc(vert)end)
	OptionB = UI.CreateButton(row0).SetText("Payments by players").SetInteractable(true).SetColor('#0021FF').SetOnClick(function () OptionBfunc(vert)end)

	else 
		UI.CreateLabel(vert).SetText("No one has gifted gold yet")
	end


end
-- UI display for all gold payments
function OptionAfunc(vert)
	OptionA.SetInteractable(false).SetColor("#FF0000")
	OptionB.SetInteractable(true).SetColor("#0021FF")
	Destroylogic()
	local ROver = UI.CreateVerticalLayoutGroup(vert)

	table.insert(Destroygroup,ROver)


	local sortedpayments = SortTable(publicdate.PayP.History,"turn")
	local color = '#FF697A'
	local turn = 1
	for i, v in pairs (sortedpayments) do
		if turn ~= v.turn then -- colors
			turn = v.turn
			if color == "#BABABC" then color = '#FF697A'
			else 
			color = "#BABABC"
			end end -- end of colors

		local row2 = UI.CreateHorizontalLayoutGroup(ROver)
		local row1 = UI.CreateHorizontalLayoutGroup(ROver)

		table.insert(Destroygroup,row1)
		table.insert(Destroygroup,row2)
		local spacer = v.goldamount
		table.insert(Destroygroup,row1)
		local Entname = Entities[v.from].Name
		local text = nil
		if v.noshow ~= nil then spacer = v.noshow end
		if v.text ~= nil then text = "#" .. v.trannum  .. " " .. v.text end

		if text ~= nil then
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row2).SetText(text).SetColor(color) end
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText(Entname ).SetColor('#FFE5B4')
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText( " sent " .. spacer .. " gold to ").SetColor(color)
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText( " " .. Entities[v.to].Name .. "  ").SetColor('#FFE5B4')
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText( " On turn ".. v.turn).SetColor(color)


	end


end
-- UI display for payment by player
function OptionBfunc(vert)
	OptionB.SetInteractable(false).SetColor("#FF0000")
	OptionA.SetInteractable(true).SetColor("#0021FF")
	Destroylogic()


	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	TargetPlayerBtn = UI.CreateButton(row1).SetText("from player...").SetOnClick(function() TargetEntityClicked(-1)end)
	Searchbtn = UI.CreateButton(row1).SetText("search").SetOnClick(function()Byplayer(vert)end).SetInteractable(false)
	table.insert(Destroygroup,TargetPlayerBtn)
	table.insert(Destroygroup,row1)
	table.insert(Destroygroup,Searchbtn)




end
-- UI functionally and logic for viewing payment histroy by players
function Byplayer(vert)
	local searchtable = {}
	for i, v in pairs (publicdate.PayP.History) do
		if TargetPlayerID == publicdate.PayP.History[i].from then
			if searchtable[v.to] == nil then
				searchtable[v.to] = {}
				if v.noshow ~= nil then searchtable[v.to].hide = v.noshow
					searchtable[v.to].gold = 0
				else 
					searchtable[v.to].gold = v.goldamount 
				end

				
			else
				if v.noshow ~= nil then searchtable[v.to].hide = v.noshow 
				else 
				searchtable[v.to].gold = searchtable[v.to].gold + v.goldamount end
			end
		end
	end
	local row0 = UI.CreateHorizontalLayoutGroup(vert)
	table.insert(Destroygroup,row0)
	local playername = Entities[TargetPlayerID].Name

	Destroygroup[#Destroygroup+1] = UI.CreateLabel(row0).SetText("Total gold sent by " ).SetColor('#00FF05')
	Destroygroup[#Destroygroup+1] = UI.CreateLabel(row0).SetText(" " ..playername ).SetColor('#FFE5B4')
	for i, v in pairs (searchtable) do
		local row1 = UI.CreateHorizontalLayoutGroup(vert)
		local spacer = ""
		if v.hide ~= nil then spacer = v.hide .. " + "end
		table.insert(Destroygroup,row1)
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText(spacer .. v.gold .. " gold to ").SetColor('#FF697A')
		Destroygroup[#Destroygroup+1] = UI.CreateLabel(row1).SetText( " " .. Entities[i].Name .. "  ").SetColor('#FFE5B4')
	end
end

-- Submit orders for payments
function SubmitClicked(close,plan,data,data2)
close()
	--Check for negative gold. We don't need to check to ensure we have this much since the server does that check in Server_GameCustomMessage
	local gold = 0
	local goldtext = ""
	if GoldInput ~= nil then gold = GoldInput.GetValue() end
	local setturns = 0
	local setgold = 0
	local setup = 0
	if data2 == -1 then setup = data2 end
	local addedturns = 0
	local con = false
	local rev = false
	local owner = {}
	local member = {}
	local Aname = ""
	local kickrate = 0
	
	if GoldText ~= nil then goldtext = GoldText.GetText() end
	if KickInput ~= nil then 
		if KickInput.GetValue() > 100 or KickInput.GetValue() < 0 then 	
			UI.Alert("Your Kick rate cannot be greater than 100 or less than 0")
			return 
		else
			kickrate = KickInput.GetValue() 

		end
	end
	if Reveal ~= nil then rev = Reveal.GetIsChecked() end
	if Cont ~= nil then con = Cont.GetIsChecked() end
	if (gold < 1 and GoldInput ~= nil) then
		UI.Alert("Gold to gift must be a positive number")
		return
	end
	--making sure you dont send to much gold to someone
	if GoldSetbtn ~= nil and plan == 0 and gold == 0 then
		if GoldSetbtn.GetValue() < 1 or TurnSetbtn.GetValue() < 2  or TurnSetbtn.GetValue() > MaxTurns or GoldSetbtn.GetValue() > Max75 then
			 UI.Alert("Your Turns cannot go below 2\nYour Gold cannot exceed 75% (" .. Max75 .." gold) of your income and cannot go below 1\nYour Turns cannot exceed " .. MaxTurns .. " turns")
				 return end
		setturns = TurnSetbtn.GetValue()
		setgold = GoldSetbtn.GetValue()
		setup = 2
	end
	if data == 1 then -- create account logic
		if Entities[GlobalID].Gold < AccountCost then UI.Alert("Dont have enough gold to create an account") return end 
		if GoldInput.GetValue() > Accountincome then UI.Alert("You cannot Deposit more money than you have in your account")  return end
		if AccountCost + GoldInput.GetValue() > Accountincome then UI.Alert("Your Deposit is to high, dont have enough money to create an account and deposit " .. GoldInput.GetValue() .. " gold" ) return end
		if string.len(AcountName.GetText()) <= 0 then UI.Alert("Must give your account a name") 
			return
		end
		setup = 10
		rev = true
		member = Memberlist
		owner = Ownerlist
		Aname = AcountName.GetText()
	end
	if plan > 0 then setup = 5 end 

	local payload = {}
	payload.TargetPlayerID = TargetPlayerID -- ID of player sent to 
	payload.Gold = gold -- Gold amount sent
	payload.multiplier = tempGoldtax -- how much gold sent before tax is applied
	payload.ourID = GlobalID -- Senders ID
	payload.reveal = rev -- if the payment amount is revealed in order list
	payload.hidden = temphidden -- if the ID is hidden in order list
	payload.percent = Temppercent -- if tax is percent, what is it
	payload.setgold = setgold -- Gold amount sent but its continues gold
	payload.setturn = setturns -- how many turns gold amount is
	payload.Cont = con -- if the gold amount is continuis 
	payload.setup = setup -- what kind of access to server needed
	payload.planid = plan -- whats the payment ID
	payload.owners = owner -- list of players that are owners on a ID
	payload.members = member -- list of players that are members
	payload.Accountname = Aname -- account name
	payload.Rate = kickrate
	payload.Acost = AccountCost
	payload.Desc = goldtext

	----------------------- new shit

	Game.SendGameCustomMessage("Gifting gold...", payload, function(returnValue) 
		UI.Alert(returnValue.Message)

		if (returnValue.realGold ~= nil)then
			local msg = "" 
			if setup == 10 then
				msg =  "you created a new account called " .. Aname .. " with a deposite of " .. gold .. " gold pretax"
			else
				msg = '(Local info) \n' .. returnValue.realGold  .. ' Gold sent from ' .. Entities[GlobalID].Name .. ' to ' .. Entities[returnValue.NewtargetID].Name
			end
			print(gold ,returnValue.realGold , returnValue.NewtargetID,"final")
			local payload = 'GiftGold2' .. gold .. ',' .. returnValue.realGold  .. ',' .. returnValue.NewtargetID
			
			local orders = Game.Orders
			table.insert(orders, WL.GameOrderCustom.Create(Game.Us.ID, msg, payload))
			Game.Orders = orders
			if setup ~= 10 then
			Dialogwindow(8,nil,nil) end 
		end
		publicdate = Mod.PublicGameData

	end)
end
-- Serverload Non Payment
function Serverload(close,plan,data1,data2,data3)
--Payload Creation
	--Note check
	print(data3,"data3")
if (data1 ~= -1) then close() end
	local payload = {}
	if data3 == "" then data1 = nil end -- skip setup if no text from notes but still load main menu by going through server

	payload.Default = plan -- default ID 
	payload.setup = data1 -- what kind of access to server needed
	payload.accountID = data2 -- Account ID
	payload.voteof = TargetPlayerID
	payload.TargetID = data3


	Game.SendGameCustomMessage("Gifting gold...", payload, function(returnValue) 
		publicdate = Mod.PublicGameData
		if returnValue.Ent ~= nil then

		Entities = returnValue.Ent
		print("created 0")
		if data1 ~= -1 then
		Dialogwindow(8,nil,nil) end
		end

	end)
end

--promptlist functionally for everyone 
function TargetEntityClicked(action)
	Action = action
	local playergroup = Entities

	playergroup = filter(playergroup, function (p) return (p.ID ~= GlobalID) end) -- Remove self


	local options = map(playergroup, PlayerButton)
	UI.PromptFromList("Select the player you would like to add to you'd like to send money to", options)
end

--promptlist Add to account (players only)
function TargetPlayerClicked(action)
	Action = action
	local playergroup = Entities
	--updating list from old UI cycle
	Ownerlist = Ownerlist
	Memberlist = Memberlist
	local Newplayergroup = filter(playergroup, function (p) return (p.ID ~= GlobalID) end) -- Remove self
	local thirdplayergroup = filter(Newplayergroup, function (p) return (p.Status ~= "A") end) -- Remove all non player Entities
	playergroup = filter(thirdplayergroup, function (p) return (p.Status ~= "D") end) -- Remove Trash can Entity

	-- filtering out ownerlist from Entity pool
	for i,v in pairs(Ownerlist) do 
		playergroup = filter(playergroup, function (p) return (p.ID ~= v) end)
	end	
	-- filtering out memberlist from Entity pool
	for i,v in pairs(Memberlist) do
		playergroup = filter(playergroup, function (p) return (p.ID ~= v) end)
	end


	local options = map(playergroup, PlayerButton)
	UI.PromptFromList("Select the player you would like to send money to", options)
end
--promptlist KickList (players only)
function PromptKicklist(list,type)
	Action = type

	local playergroup = Values2Table(list) -- create list of entities outta list of entity ID's


	local options = map(playergroup, PlayerButton)
	UI.PromptFromList("Select the Owner/Member of the account", options)
end
--promptlist Add to Owner from members (players only)
function PromptAddOwners(Ent,action)
	Action = action
	local TurnsMustBeInAccount = TurnsNeededInAccount
	local playergroup =  Values2Table(Ent.members) -- creates a table of Ents only of members
	local Newplayergroup = filter(playergroup, function (p) return (p.ID ~= GlobalID) end) -- Remove self
	playergroup = filter(Newplayergroup, function (p) 
		for i,v in pairs (p.YourAccounts)do
			if v.AID == Ent.ID then
		return (v.Turnadded +TurnsMustBeInAccount < Game.Game.TurnNumber) end end end) -- Remove all members who haven't been there long enough Entities


	local options = map(playergroup, PlayerButton)
	UI.PromptFromList("Can only add Blue members who have been on the account for 3 turns", options)
end
--Add nenber
function PromptAddMember(Ent,action)
	Action = action
	local localEnt = Ent
	local playergroup = Entities
	--updating list from old UI cycle
	local Ownerlist = localEnt.owners
	local Memberlist = localEnt.members
	local Newplayergroup = filter(playergroup, function (p) return (p.ID ~= GlobalID) end) -- Remove self
	local thirdplayergroup = filter(Newplayergroup, function (p) return (p.Status ~= "A") end) -- Remove all non player Entities
	playergroup = filter(thirdplayergroup, function (p) return (p.Status ~= "D") end) -- Remove Trash can Entity

	-- filtering out ownerlist from Entity pool
	for i,v in pairs(Ownerlist) do 
		playergroup = filter(playergroup, function (p) return (p.ID ~= v) end)
	end	
	-- filtering out memberlist from Entity pool
	for i,v in pairs(Memberlist) do
		playergroup = filter(playergroup, function (p) return (p.ID ~= v) end)
	end


	local options = map(playergroup, PlayerButton)
	UI.PromptFromList("Select the player you would like to add to the account", options)

end

-- voted player
function PromptVotedplayers(voted)

	local playergroup =  voted-- Votedplayers list

	local options = map(playergroup, PlayerButton)
	UI.PromptFromList("All players who voted to kick", options)
end
-- actual logic for each button
function PlayerButton(entity)

	local name = entity.Name
	local ret = {};
	ret["text"] = name;
	ret["selected"] = function() 
		TargetPlayerID = entity.ID

		if TargetPlayerBtn ~= nil then -- Non account logic
			TargetPlayerBtn.SetText(name)

			if Giftbtn ~= nil then -- Single payment logic
				Giftbtn.SetInteractable(true) 
				-- Trashcan logic
				if TargetPlayerID == publicdate.RandomVar.DeleteID  then TargetPlayerBtn.SetColor('#76FF7A') -- Trashcan logic
					Giftbtn.SetText("Erase Gold")
				else -- everyone else
					TargetPlayerBtn.SetColor('#FFFFFF') 
					Giftbtn.SetText("Gift")
				end 
			end

			if Searchbtn ~= nil then Searchbtn.SetInteractable(true) end
			if AdvanceBtn ~= nil then 
				AdvanceBtn.SetInteractable(true) -- Set turns logic
				if TargetPlayerID == publicdate.RandomVar.DeleteID  then -- Trashcan logic
					TargetPlayerBtn.SetColor('#76FF7A') 
					AdvanceBtn.SetText("Erase Gold")
				else --everyone else
					TargetPlayerBtn.SetColor('#FFFFFF')
					AdvanceBtn.SetText("Gift")
				end 
			 end 
		end
		--Create Account logic
		if Action == 0 then -- owner
			table.insert(Ownerlist,TargetPlayerID) 
			OwnernamesText = OwnernamesText .. Entities[TargetPlayerID].Name .. "\n"
			Ownernames.SetText(OwnernamesText).SetColor("#1edc00")
			TargetOwnerBtn.SetText("Total Owners " .. #Ownerlist)
		elseif Action == 1 then -- members
			table.insert(Memberlist, TargetPlayerID)
			MembernamesText = MembernamesText .. Entities[TargetPlayerID].Name .. "\n"
			membernames.SetText(MembernamesText).SetColor("#1edc00")
			TargetMemberBtn.SetText("Total Members " .. #Memberlist) 
		-- Adding Owners/Members (after account creation)
		elseif Action == 3 then -- Owners
			AddOwnerbtn.SetInteractable(true)	
			addowner.SetText(entity.Name)
		elseif Action == 4 then -- Members
			Addmemberbtn.SetInteractable(true)
			addmember.SetText(entity.Name) 
		--kick ownerVote
		elseif Action == 5 then Kickbutton.SetInteractable(true)	
			Kickowner.SetText(entity.Name)
		-- Kick member
		elseif Action == 6 then 
			kickmemberbtn.SetInteractable(true)
			Kickmember.SetText(entity.Name)
		end
		end

	return ret

end
-- Text storage Function
function TaxText(row3)
	if (tempGoldtax > 0 )then
		UI.CreateLabel(row3).SetText("Gifting Gold to someone applies a Tax. First tax applies after " .. tempGoldtax .. " gold has been sent. each gold piece after that cost 1 gold for every " .. tempGoldtax .. " you send").SetColor('#00F4FF')
		UI.CreateLabel(row3).SetText("| Account multipler Tax is: " .. AccountTax ).SetColor('#00F4FF')
	
	elseif (Temppercent > 0)then
			UI.CreateLabel(row3).SetText("Gifting Gold to someone applies a Tax. Tax is equal to " .. Temppercent .. "%").SetColor('#00F4FF')
			UI.CreateLabel(row3).SetText("| No account Percent Tax").SetColor('#00F4FF')

		else 
			UI.CreateLabel(row3).SetText("No Tax Applied").SetColor('#00F4FF')
			UI.CreateLabel(row3).SetText("| Account Tax is: " .. AccountTax).SetColor('#00F4FF')

		end
end

-- Display window for creating new popup windows

function Dialogwindow(window, close, data) -- middle function to open up new windows
publicdate = Mod.PublicGameData
	Datatransfer = nil

	if window == 1 then --Base options
		Game.CreateDialog(Giftgold)
		close()
    elseif window == 2 then -- Payment plans
		Game.CreateDialog(Plans)
		close()
	elseif window == 3 then -- Payment history
		Game.CreateDialog(History)

	elseif window == 4 then -- Set Turns
		Game.CreateDialog(SetTurns)
		close()
	elseif window == 5 then --  Create an account
		Game.CreateDialog(CreateAccount)
		close()
	elseif window == 6 then -- your account
		Game.CreateDialog(YourAccount)
		close()
	elseif window == 7 then -- All Accounts
		Game.CreateDialog(AllAccounts)
		close()
	elseif window == 8 then -- create main menu
		Game.CreateDialog(WrapperMainmeunID)
		if close ~= nil then close() end
	elseif window == 9 then -- Open account
	Datatransfer = data -- giving what account to open
		Game.CreateDialog(OpenAccount)
		if close ~= nil then close() end
	elseif window == 10 then -- Kicking window
		Datatransfer = data -- giving what account to open
		Game.CreateDialog(KickingWindow)
		close()
	elseif window == 11 then -- Peak Account
		Datatransfer = data -- giving what account to open
		Game.CreateDialog(PeakAccount)
	elseif window == 12 then -- Note tracking
		Datatransfer = data
		Game.CreateDialog(OpenNotes)
		if close ~= nil then close() end
	elseif window == 13 then-- Owner tracker
		Datatransfer = data
		Game.CreateDialog(OwnerHistory) 
	elseif window == 14 then -- Calculator
		Datatransfer = data
		Game.CreateDialog(Calculator) 
	end
end

-- wrapper function
function Numberson()
	TurnSetbtn.SetInteractable(Cont.GetIsChecked())
end
	--Logic to destroy elements in view money history
function Destroylogic()
	for i=1 ,#Destroygroup do 
		UI.Destroy(Destroygroup[i])
	end
	Destroygroup = {}
end
function GlobalFarm(ID)
	temphidden = Mod.Settings.Hidden -- if game has already started. set values
	tempGoldtax = Mod.Settings.GoldTax
	Temppercent = Mod.Settings.Percent
	Contbool = false
	GoldSetbtn = nil
	TargetPlayerBtn = nil
	Reveal = nil
	AdvanceBtn = nil
	Cont = nil
	GoldInput = nil
	TurnSetbtn = nil
	Searchbtn = nil
   if(temphidden == nil)then temphidden = false end
   if(tempGoldtax == nil)then tempGoldtax = 0 end
   if(Temppercent == nil)then Temppercent = 0 end
   playerpicked = false
   Memberlist = {}
   Ownerlist = {}
   MembernamesText = ""
   OwnernamesText = ""
   MaxTurns = 20
   GlobalID = ID
   KickInput = nil
   AccountCost = Mod.Settings.ACost or 0
   AccountTax = Mod.Settings.ATax or 0
   TurnsNeededInAccount = 1



end
--wrapper for main menu
function WrapperMainmeunID(rootParent, setMaxSize, setScrollable, game, close)
	local window = {rootParent, setMaxSize, setScrollable, game, close,false}

	MainMenuID(window)
end
-- Main logic of mainmenu
function MainMenuID(Window)
		TargetPlayerBtn = nil

	local setMaxSize = Window[2]
	local rootParent = Window[1]
	local close = Window[5]
	local setScrollable = Window[3]
	local game = Window[4]
	local access = Window[6]
	local Name = "You"
	local CalReady = false
	if publicdate.taxidtable ~= nil then CalReady = true end
	setMaxSize(470, 350)

	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row0 = UI.CreateHorizontalLayoutGroup(vert)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateHorizontalLayoutGroup(vert)
	
--Payment options
	UI.CreateButton(row0).SetText("Single payment").SetOnClick(function () Dialogwindow(1,close,nil) end )
	UI.CreateButton(row0).SetText("Set payments").SetOnClick(function () Dialogwindow(4,close,nil) end )
-- Payment history
	UI.CreateButton(row0).SetText("Payment History").SetOnClick(function () Dialogwindow(3,close,nil) end ).SetInteractable(not temphidden)
	UI.CreateButton(row0).SetText("Payment Plans").SetOnClick(function () Dialogwindow(2,close,nil) end )

	if access or Entities[GlobalID].Status ~= "A" then
	--Account Info
		UI.CreateButton(row1).SetText("Create Account").SetOnClick(function () Dialogwindow(5,close,nil) end )
		UI.CreateButton(row1).SetText("Your Accounts").SetOnClick(function () Dialogwindow(6,close,nil) end )
		UI.CreateButton(row1).SetText("All Accounts").SetOnClick(function () Dialogwindow(7,close,nil) end )
	end
	UI.CreateButton(row2).SetText("Calculator").SetOnClick(function () Dialogwindow(14,close,nil) end ).SetInteractable(CalReady)

	TaxText(row3)
	if Entities ~= nil then Name = Entities[GlobalID].Name end
	UI.CreateLabel(row4).SetText("Current User: " .. Name).SetColor('#6eef41')
end
--Kicking/Add Window
function KickingWindow(rootParent, setMaxSize, setScrollable, game, close)

	setMaxSize(450, 320)
	local Ent = Entities[Datatransfer]
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row0 = UI.CreateHorizontalLayoutGroup(vert)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateHorizontalLayoutGroup(vert)
	local row5 = UI.CreateHorizontalLayoutGroup(vert)

	--Create Owner Kick Vote
	UI.CreateLabel(row1).SetText("Create Owner Kick Vote") -- selecting player
	Kickowner = UI.CreateButton(row1).SetText("Select Owner...").SetOnClick(function () PromptKicklist(Ent.owners,5) end)
	Kickbutton = UI.CreateButton(row1).SetText("submit...").SetOnClick(function () 	Serverload(close,GlobalID,11,Datatransfer) end).SetInteractable(false)
	--Kick Member
	UI.CreateLabel(row2).SetText("Remove Member")
	Kickmember = UI.CreateButton(row2).SetText("Select Member...").SetOnClick(function () PromptKicklist(Ent.members,6) end)
	kickmemberbtn = UI.CreateButton(row2).SetText("Submit...").SetOnClick(function () Serverload(close,GlobalID,8,Datatransfer,nil) end ).SetInteractable(false)

	--Add Owners
	UI.CreateLabel(row4).SetText("Add Owner") 
	addowner = UI.CreateButton(row4).SetText("Select Owner...").SetOnClick(function () PromptAddOwners(Ent,3) end)
	AddOwnerbtn = UI.CreateButton(row4).SetText("Submit...").SetOnClick(function () Serverload(close,GlobalID,7,Datatransfer,nil) end ).SetInteractable(false)

	--Add memeber
	UI.CreateLabel(row5).SetText("Add Member") -- selecting player
	addmember = UI.CreateButton(row5).SetText("Select player...").SetOnClick(function () PromptAddMember(Ent,4) end) 
	Addmemberbtn = UI.CreateButton(row5).SetText("Submit...").SetOnClick(function () Serverload(close,GlobalID,6,Datatransfer,nil) end ).SetInteractable(false)


end

-- Voting UI logic
function Votinglogic(Ent,row7Over,close)

	local totalplayers = (#Ent.members + #Ent.owners) - 1
	if totalplayers == 0 then totalplayers = 1 end
	for i,v in pairs (Ent.KVote) do 

		local YourVote = FindmatchID(v.Vlist,GlobalID,2)
		local Votedplayers = SearchValue2Table(Ent.owners,v.Vlist,nil)
		Votedplayers = SearchValue2Table(Ent.members,v.Vlist,Votedplayers)
		local percentVote = math.floor((#Votedplayers / totalplayers) * 100)
		local row7 = UI.CreateHorizontalLayoutGroup(row7Over)

		UI.CreateLabel(row7).SetText(percentVote .. "% of users Voted to kick " .. Entities[v.voteof].Name .. "\n" .. Ent.kickrate .. "% needed\n" .. (v.Turncreated +3) - Game.Game.TurnNumber .. " Turns left")   -- selecting player
		UI.CreateButton(row7).SetText("Voted players").SetOnClick(function () PromptVotedplayers(Values2Table(v.Vlist)) end )
		UI.CreateButton(row7).SetText("Add Vote").SetOnClick(function () Serverload(close,GlobalID,13,Datatransfer,i) end ).SetInteractable(not YourVote)
		UI.CreateButton(row7).SetText("Remove Vote").SetOnClick(function () Serverload(close,GlobalID,14,Datatransfer,i) end ).SetInteractable(YourVote)

	end
end
--Change User ID
function ChangeUserID (ID,close)
	GlobalID = ID

	Dialogwindow(8,close,nil)
end
-- Notes for account
function OpenNotes(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(450, 320)
	local Ent = Entities[Datatransfer]
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row0 = UI.CreateHorizontalLayoutGroup(vert)

	local IsOwner = FindmatchID(Ent.owners,GlobalID,2)

	NoteField = UI.CreateTextInputField(vert).SetPlaceholderText("Notes").SetFlexibleWidth(1)
	EnterBtn = UI.CreateButton(row0).SetText("Enter").SetOnClick(function ()  wrapperOpenaccount_fromNotes(close,GlobalID,12,Ent.ID,nil) end) -- Enter
	ClearBtn = UI.CreateButton(row0).SetText("Clear").SetOnClick(function ()  wrapperOpenaccount_fromNotes(close,GlobalID,16,Ent.ID,nil)end).SetInteractable(IsOwner) -- Clear

	--Displaying Notes
	if Ent.Notes ~= nil then
		local SortedT = SortTable(Ent.Notes,"Turn")
		local turn = 0
		for i,v in pairs (SortedT) do
			
			if v.Turn ~= turn then
				local row1 = UI.CreateHorizontalLayoutGroup(vert)
				AddStringToUI(row1,"<#8340fb>-------</><#FFFFFF> Turn " .. v.Turn .. "</><#8340fb> -------</>",nil)
				turn = v.Turn
				
			end
			local row2 = UI.CreateHorizontalLayoutGroup(vert)
			AddStringToUI(row2,"<#75fb40>".. v.Name.."</>",nil)
			AddStringToUI(row2,"<#FFFFFF>"..v.notes.."</>",nil)


		end
	end
end
--Wrapper To open notes and load data
function wrapperOpenaccount_fromNotes (close,globid,setup,EntID,data)

	local data0 = nil
	if NoteField ~= nil then data0 = NoteField.GetText() end

	Serverload(close,globid,setup,EntID,data0)
end
-- Owner Histor data
function OwnerHistory(rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(350, 390)
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row0 = UI.CreateHorizontalLayoutGroup(vert)
	local OwnerHist = Datatransfer


	if OwnerHist ~= nil and #OwnerHist ~= 0 then
		print(#OwnerHist,"ownerhist")
		local SortedT = SortTable(OwnerHist,"Turn")
		local turn = 0
		for i,v in pairs (SortedT) do
			
			if v.Turn ~= turn then
				local row1 = UI.CreateHorizontalLayoutGroup(vert)
				AddStringToUI(row1,"<#ff3400>---</><#FFFFFF> Turn " .. v.Turn .. "</><#ff3400> ---</>",nil)

				turn = v.Turn
				
			end
			local row2 = UI.CreateHorizontalLayoutGroup(vert)
			UI.CreateButton(row2).SetText(#v.List .." Owners").SetOnClick(function () PromptKicklist(v.List,nil) end)


		end
	else
		UI.CreateLabel(row0).SetText("Owners are added at turn end. wait for turn to process") 

	end
end
--Calculator Tax UI
function Calculator (rootParent, setMaxSize, setScrollable, game, close)
	setMaxSize(450, 350)
	
	-- Price
	local vert = UI.CreateVerticalLayoutGroup(rootParent).SetFlexibleWidth(1)
	local row1 = UI.CreateHorizontalLayoutGroup(vert)
	local row2 = UI.CreateHorizontalLayoutGroup(vert)
	local row2after = UI.CreateHorizontalLayoutGroup(vert)
	local row3 = UI.CreateHorizontalLayoutGroup(vert)
	local row4 = UI.CreateHorizontalLayoutGroup(vert)
	local row5 = UI.CreateHorizontalLayoutGroup(vert)
	local row6 = UI.CreateHorizontalLayoutGroup(vert)
	local tax = tempGoldtax
	local secondtax = tempGoldtax
	local accounttax = AccountTax
	local spacer = tax..""
	local spacer2 = AccountTax..""
	if tax == 0 then 
		secondtax = Temppercent 
		accounttax = 0 
		spacer = secondtax .. "%"
		spacer2 = "0%"
	end


	UI.CreateLabel(row1).SetText('Calculate tax for this amount of Gold ').SetColor("#FFFFFF")
	CalGold = UI.CreateNumberInputField(row1)
	.SetSliderMinValue(1)
	.SetSliderMaxValue(500)
	.SetValue(1)
	UI.CreateButton(row2).SetText("Calculate Base").SetOnClick(function () CrunchNumbers(tax,secondtax,tax) end)
	AddStringToUI(row2,'----Tax Rate: <#1c6aad>'.. spacer..'</>',nil)

	UI.CreateButton(row2after).SetText("Calculate Account").SetOnClick(function () CrunchNumbers(tax,secondtax,accounttax) end)
	AddStringToUI(row2after,'----Tax Rate: <#1c6aad>'.. spacer2..'</>',nil)




	UI.CreateLabel(row3).SetText('Gold Sent: ')
	CalSent = UI.CreateLabel(row3).SetText('0')

	UI.CreateLabel(row4).SetText('Gold Recived: ')
	CalReci = UI.CreateLabel(row4).SetText('0')

	UI.CreateLabel(row5).SetText('Tax Paid: ')
	CalTax = UI.CreateLabel(row5).SetText('0')


end
--Calculate Tax data
function CrunchNumbers(Tax,Percent,truetax)

	local newtax = Tax
	local percent = 0
	if newtax == 0 then 
		truetax = 0
		percent = Percent
		 end 

	newtax = truetax
	local ourid = GlobalID
	local gap2 = 0
	local storeC =  publicdate.taxidtable[ourid].count
	local storegap = publicdate.taxidtable[ourid].gap
	local goldtax = newtax
	local actualGoldSent = 0
	local goldSending = CalGold.GetValue()


	--Tax Logic
	if (storegap + goldSending > goldtax and storegap > 0 )then
		gap2 = goldtax - storegap
		actualGoldSent = actualGoldSent + (gap2 / (storeC + 1))
		storegap = 0

		storeC = storeC + 1
	end

-- tax multiplier logic ( 0 means no Tax)
	if (goldtax > 0 )then 
	local ga = goldtax        --- how many units in each group
	local group = math.ceil((goldSending - gap2) / ga) --- how many groups of Ga are in goldsending

	for C = 1, group, 1 do

		if (C < group)then
			actualGoldSent = actualGoldSent + (ga / (C + storeC)) --appliy Tax to gold divided into groups
		elseif (C >= group) then -- this means your in the last group
			local gap = (goldSending-gap2) - (ga * (C-1)) -- finding the difference between the last group and current amount in 'actualGoldSent'
			actualGoldSent = actualGoldSent + (gap / (C + storeC))
			if (gap == goldtax)then -- cancel gap logic if you sent the exact amount
				storeC = storeC + 1
				gap = 0
			end
		end
	end
	elseif (percent > 0 )then 	-- Percent Tax
		local temppercent = 100 - percent
		local percentGold = goldSending * (temppercent / 100)
		actualGoldSent = (percentGold+gap2);
	else 	--No tax
		actualGoldSent = (goldSending)

	end



	CalSent.SetText(goldSending).SetColor("#45ad1c")
	CalReci.SetText(math.floor(actualGoldSent)).SetColor("#f8ff0b")
	CalTax.SetText(goldSending - math.floor(actualGoldSent)).SetColor("#FF697A")
end