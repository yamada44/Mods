require('Utilities')

--known bugs
-- when you buy a plan on turn 1, it causes a bug and doesn't detect when your over 75%

function Server_GameCustomMessage(game, playerID, payloadO, setReturnTable)
	--if true then print("return HIT Server 2") return  end
	local publicdate = Mod.PublicGameData

	Game = game


	-- check for payment plan data
	publicdate = DataCheck(publicdate,payloadO,game)


	local i = 1
	publicdate.PayP.accessed = true
	publicdate.PayP.Sameturn = game.Game.TurnNumber
	if payloadO.setup == -1 then -- Entity update
		setReturnTable({Ent = publicdate.Entity})
	elseif payloadO.setup == 1 then -- continued setups
	
		while i <=  #publicdate.PayP.Plan do
			local v = publicdate.PayP.Plan[i]
			local payload = {};
			payload.TargetPlayerID = v.targetplayer
			payload.Gold = v.goldsent
			payload.multiplier = v.goldtax
			payload.ourID = v.ID
			payload.reveal = v.reveal
			payload.hidden = v.hidden
			payload.percent = v.percent
			payload.setgold = v.goldsent
			payload.setturn = 0
			payload.Cont = v.cont
			payload.setup = 1
			payload.planid = i
			payload.Desc = v.text

			if v.Turntill <=  game.Game.TurnNumber and v.Turntill > 0 then
				payload.setup = 3
				i = i - 1

			end

			Paymentprocess(game,payload,setReturnTable,publicdate)
			i = i + 1

		end
	elseif payloadO.setup == 0 or payloadO.setup == 2 then -- single payment
		Paymentprocess(game,payloadO,setReturnTable,publicdate)
	elseif payloadO.setup == 5 then -- remove payment plan
		Removepayment(payloadO.planid,publicdate)
		setReturnTable({ Message = "Payment Plan removed" })
	elseif payloadO.setup == 6 then -- add member to account
		AddMembers(publicdate,payloadO)
		setReturnTable({Ent = publicdate.Entity})
	elseif payloadO.setup == 7 then -- add owner to account
		AddOwner(publicdate,payloadO)
		setReturnTable({Ent = publicdate.Entity})
	elseif payloadO.setup == 8 then -- remove member
		RemoveMember(publicdate,payloadO)
		setReturnTable({Ent = publicdate.Entity})
	elseif payloadO.setup == 9 then -- Leave Account
		LeavingAccount(publicdate,payloadO)
		setReturnTable({Ent = publicdate.Entity})
	elseif payloadO.setup == 10 then -- Create account
		AccountCreation(payloadO,publicdate,setReturnTable)
		if payloadO.Gold > 0 then
			Paymentprocess(game,payloadO,setReturnTable,publicdate)
		end
		
	elseif payloadO.setup == 11 then -- kicking Vote
		KickingVoteCreation(publicdate,game,payloadO)
		setReturnTable({Ent = publicdate.Entity})
	elseif payloadO.setup == 12 then -- Enter Notes
		EnterText(publicdate,payloadO,game)
		setReturnTable({Ent = publicdate.Entity})
	elseif payloadO.setup == 13 then -- Add Vote / Remove Owner
		Addvote(publicdate,payloadO)
		setReturnTable({Ent = publicdate.Entity})
	elseif payloadO.setup == 14 then -- Remove Vote
		Removevote(publicdate,payloadO)
		setReturnTable({Ent = publicdate.Entity})
	elseif payloadO.setup == 15 then -- Reveal change (still must add on client in all accounts)
		Revealtoggle(publicdate,payloadO) 
		setReturnTable({Ent = publicdate.Entity})
	elseif payloadO.setup == 16 then -- Clear Notes
		ClearText(publicdate,payloadO,game)
		setReturnTable({Ent = publicdate.Entity})
	end

	


	Mod.PublicGameData = publicdate 
end
--Creating a new payment plan (not used for single payments)
function Newpayment(payload,publicdate,playerid)
	local setturn = (payload.setturn) + Game.Game.TurnNumber
	local contu = payload.Cont

	-- 1 = continues || 2 = set
	if contu == true then
	contu = 2
	else 
		setturn = 0
		contu = 1
	end
	if (publicdate.PayP.Plan[#publicdate.PayP.Plan + 1] == nil )then publicdate.PayP.Plan[#publicdate.PayP.Plan + 1] = {}
	local short = publicdate.PayP.Plan[#publicdate.PayP.Plan]	
	short.goldsent = payload.setgold
	short.aftertax = payload.setgold
	short.targetplayer = payload.TargetPlayerID
	short.cont = contu -- what kind of plan needed for the action
	short.Turntill = setturn - 1
	short.reveal = payload.reveal
	short.hidden = payload.hidden
	short.percent = payload.percent
	short.goldtax = payload.multiplier
	short.setup = payload.setup -- what kind of action needed for plan
	short.ID = playerid
	short.bank = 0
	short.text = payload.Desc
	end
	return payload.setgold
end
-- calculating all plans you have to make sure you don't exceed 75% of your income through payments
function Banked(publicdate,setgold,ID)
	local total = 0
	for i, v in pairs (publicdate.PayP.Plan) do
		if ID == v.ID then
		total = total + v.goldsent end
	end

	return total + setgold
end
--Removing a payment plan
function Removepayment(planid,publicdate)
	table.remove(publicdate.PayP.Plan,planid)
end
--Tracking all payments ever made
function Addhistory(targetplayerid,publicdate, actualgold,playerid,reveal,text,trans)
	if publicdate.PayP.History[#publicdate.PayP.History + 1] == nil then
		publicdate.PayP.History[#publicdate.PayP.History + 1] = {}
		local short = publicdate.PayP.History[#publicdate.PayP.History]
		if text == nil then text = "" end
		short.from = playerid
		short.to = targetplayerid
		if reveal == false then short.noshow = "???" end 
		short.goldamount = actualgold
		short.text = text
		short.trannum = trans
		short.turn = Game.Game.TurnNumber
	end
	
end
--Processing the payment itself
function Paymentprocess(game,payload,setReturnTable,publicdate)

	--Entity variables
	print(payload.ourID,"ourid")
	local Ourentity = publicdate.Entity[payload.ourID]
	local TargetEntity = publicdate.Entity[payload.TargetPlayerID]
	--Base payment variables
	--local id = payload.TargetPlayerID
	local setgold = payload.setgold
	local setturn = payload.setturn
	local contu = payload.Cont
	local ourid = Ourentity.ID
	local targetID = TargetEntity.ID
	local newPlan = payload.setup
	local planid = payload.planid
	
	--Base gold variables
	local actualGoldSent = 0                 --- how much gold is actually sent
	local goldSending = payload.Gold; -- How much gold you sent before tax was applied
	local goldtax = payload.multiplier 
	local percent = payload.percent
	if Ourentity.Status == "A" then
		if goldtax > 0 then
			goldtax = Mod.Settings.ATax or goldtax * 4
		elseif percent > 0 then
			percent = 0
		else
			goldtax = Mod.Settings.ATax or 0
		end
	end

	--tables for public data dhecks
	if (publicdate.taxidtable == nil)then  publicdate.taxidtable = {}end
	if (publicdate.taxidtable[ourid] == nil)then publicdate.taxidtable[ourid] = {count = 0, gap = 0}end
	
	--customOrder bypass logic 
	if (publicdate.orderAlt == nil)then publicdate.orderAlt = {}end
	if (publicdate.orderamount == nil)then publicdate.orderamount = 0 end
	if (publicdate.orderaccess == nil)then publicdate.orderaccess = true end
	
	-- variables for Gap Gold (current gold already sent to calculate the gap before we hit a new Tax bracket )
	local gap2 = 0
	local storeC =  publicdate.taxidtable[ourid].count
	local storegap = publicdate.taxidtable[ourid].gap
	local goldHave = Ourentity.Gold
	
	-- if new turn, reset taxidtable
	if (publicdate.orderaccess == false)then
		publicdate.taxidtable = {}
		publicdate.taxidtable[ourid] = {count = 0, gap = 0}
		publicdate.orderaccess = true
	end 
	
	-- Cannot gift yourself logic
	if (ourid == targetID) then
		setReturnTable({ Message = "You can't gift yourself" });
		return
	end
  -- don't have enough money

	if (goldHave < goldSending) then
		setReturnTable({ Message = "You have less then " .. goldSending .. " gold. your current gold reserve is: " .. goldHave .. '\n\n' .. 'Refresh Page for best results' })
			return
	end
	
	-- Adding continued/Set turns logic
	if newPlan > 0 then -- Adding continued/Set turns logic
		local tempgold = 0 
		if newPlan == 2 then tempgold = setgold end
		-- checking to see if You have to much gold
		if #publicdate.PayP.Plan > 0 and Ourentity.Income *0.75 < Banked(publicdate,tempgold,ourid) then 
			-- if this is a timed plan, increment
			if contu == 2 then publicdate.PayP.Plan[planid].Turntill = publicdate.PayP.Plan[planid].Turntill + 1 end

			setReturnTable({ Message = "Your combined payments exceed 75% of your income\nPayment plan cancelled"})
			return 
		end
		if newPlan == 2 then --creating new payment plan
			goldSending = Newpayment(payload,publicdate,ourid)	
		elseif newPlan == 3 then -- removing payment plan
			Removepayment(planid,publicdate)
		end
	end

	-- checking to see if a gold tax was set during game creation
	if (goldtax == nil)then goldtax = 0 end;

	-- keeping track wheather or not players have exceeded tax by adding gap gold from last gift
	if (storegap + goldSending > goldtax and storegap > 0 )then
		gap2 = goldtax - storegap
		actualGoldSent = actualGoldSent + (gap2 / (storeC + 1))
		storegap = 0
		publicdate.taxidtable[ourid].gap = storegap
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
			publicdate.taxidtable[ourid].count = ((C + storeC) - 1) -- tracking tax rate group
			publicdate.taxidtable[ourid].gap = publicdate.taxidtable[ourid].gap + gap -- tracking gap between next group
		end
	end
	elseif (percent > 0 )then 	-- Percent Tax
		local temppercent = 100 - percent
		local percentGold = goldSending * (temppercent / 100)
		actualGoldSent = (percentGold+gap2);
	else 	--No tax
		actualGoldSent = (goldSending) -- +gap2 was here (if errors occure add back)
	end
	
	actualGoldSent = math.floor(actualGoldSent)
	-- end of tax multiplier logic
	
	-- taking multiper amount and using that for our for loop limit. then taking the value within each group
	--	(GA), dividing that by our current Tax (C). each group should be divided by 1 more every loop.  
	-- gold Actual Gold sent (AG). if your on the last group, find the gap since the ga isn't the same. 
	-- and use gap for our ga instead
	
	--packaging everything up and sending it over to Server_AdvanceTurn_Order
	publicdate.orderamount = publicdate.orderamount + 1 
	if (publicdate.orderAlt[publicdate.orderamount] == nil)then publicdate.orderAlt[publicdate.orderamount] = {}end

	publicdate.orderAlt[publicdate.orderamount].realgold = actualGoldSent
	publicdate.orderAlt[publicdate.orderamount].targetPlayer = targetID
	publicdate.orderAlt[publicdate.orderamount].us = payload.ourID
	publicdate.orderAlt[publicdate.orderamount].reveal = payload.reveal
	publicdate.orderAlt[publicdate.orderamount].Trannumber = publicdate.trannum
	publicdate.HiddenOrders = payload.hidden

	
	-- History logic
	Addhistory(payload.TargetPlayerID,publicdate,actualGoldSent,ourid,payload.reveal,payload.Desc,publicdate.trannum )

	--transaction number
	publicdate.trannum = publicdate.trannum + 1

	-- Getting target player for gold and name
	
	publicdate = AlterGold(Ourentity.ID,goldSending,publicdate,"-")
	publicdate = AlterGold(TargetEntity.ID,actualGoldSent,publicdate,"+")

	Mod.PublicGameData = publicdate -- Saving Data
	setReturnTable({ Message = "Sent " .. TargetEntity.Name .. ': ' .. actualGoldSent .. ' gold.\nYou now have: ' .. (goldHave - goldSending) .. ' gold.', realGold = actualGoldSent,NewtargetID =TargetEntity.ID   })

end
 
-- Pre entry data creation/updating
function DataCheck(publicdate,payload,game)
	local ID = payload.ourID

	if publicdate.GlobalIDs == nil then publicdate.GlobalIDs =  -1 end
	if (publicdate.PayP == nil )then publicdate.PayP = {} end
	if (publicdate.PayP.Plan == nil)then publicdate.PayP.Plan = {} end
	if (publicdate.PayP.History == nil)then publicdate.PayP.History = {} end

	if publicdate.PayP.Sameturn == nil then publicdate.PayP.Sameturn = Game.Game.TurnNumber end
	if publicdate.PayP.accessed == nil then publicdate.PayP.accessed = true end

	-- Random Variables
	if publicdate.RandomVar == nil then publicdate.RandomVar = {DeleteID = 0} end
	if (publicdate.trannum == nil)then publicdate.trannum = 1 end --keeping track of transactions to properly track
	publicdate.ServerAccess = false

	--entities creation
	if publicdate.Entity == nil then publicdate.Entity = {} 
	PlayerEntityCreation(publicdate)
	end
	--updating all entities
	EntityUpdate(publicdate)
	-- Voting Time Update
	UpdateVote(publicdate,game)

	return publicdate
end
--Creating all entities for the first time
function PlayerEntityCreation(publicdate)
		--Entity Creation

	local TrashID = publicdate.RandomVar.DeleteID

	if publicdate.Entity == nil then publicdate.Entity = {} end
	for ID,v in pairs (Game.Game.PlayingPlayers) do
		if publicdate.Entity[ID] == nil then publicdate.Entity[ID] = {}
			local short = publicdate.Entity[ID]
				short.Name = Game.Game.Players[ID].DisplayName(nil, false)
				short.ID = ID
				short.Status = "P"
				short.Gold = Game.ServerGame.LatestTurnStanding.NumResources(ID, WL.ResourceType.Gold)
				-- Income data
				local standing = Game.ServerGame.LatestTurnStanding
				local player = Game.Game.PlayingPlayers[ID]
				local income = {Total = 0}
				if player ~= nil then -- Making sure the player is actually still in the game
					income = player.Income(0, standing, false, false)
				end
				short.Income = income.Total
				short.lowEstimate = -1
				short.highEstimate = -1
				short.YourAccounts = {}

		end
	end
	if publicdate.Entity[TrashID] == nil then publicdate.Entity[TrashID] = {} -- Trash Can
		local short = publicdate.Entity[TrashID]
		short.Name = "Delete Gold"
		short.ID = TrashID
		short.Status = "D"
		short.Gold = 0
		short.Income = 0
		short.lowEstimate = -1
		short.highEstimate = -1

	end

	return publicdate
end
--updating all entities
function EntityUpdate(publicdate)

	-- Entity Update check
	for i,v in pairs (publicdate.Entity) do
		--Update players
		if v.Status == "P" then
		   v.Gold = Game.ServerGame.LatestTurnStanding.NumResources(i, WL.ResourceType.Gold)
		   local standing = Game.ServerGame.LatestTurnStanding
		   local player = Game.Game.PlayingPlayers[v.ID]
		   local income = {Total = 0}
		   if player ~= nil then -- Making sure the player is actually still in the game
			   income = player.Income(0, standing, false, false)
		   end
		   v.Income = income.Total
		--Update Accounts
		elseif v.Status == "A" then
			local high = math.random(v.Gold ,v.Gold * 1.5)
			local low = math.random(v.Gold * 0.4,v.Gold )
		   v.lowEstimate = low
		   v.highEstimate = high
		   v.Income = v.Gold
		--error Handling
		elseif v.Status ~= "D" then
			
		   print("Error: no Status found for entity " .. i .. " " .. v.Name)
		end 
   end
   return publicdate
end
--creating a account
function AccountCreation(payload,publicdate,setReturnTable)
	local currentEnt = 0
	-- Gold check for account Cost
	if (publicdate.Entity[payload.ourID].Gold < payload.Acost) then
		setReturnTable({ Message = "You have less then " .. payload.Acost .. " gold. your current gold reserve is: " .. publicdate.Entity[payload.ourID].Gold .. '\n\n' .. 'Refresh Page for best results' })
			return
	else 
		AlterGold(payload.ourID,payload.Acost,publicdate,"-")
	end


	if publicdate.Entity[publicdate.GlobalIDs] == nil then publicdate.Entity[publicdate.GlobalIDs] = {}
		local short = publicdate.Entity[publicdate.GlobalIDs]
			print(#payload.members,"member amount")
		 -- creating an account
			short.Name = payload.Accountname
			short.ID = publicdate.GlobalIDs
			short.Status = "A"
			short.Gold = 0
			short.members = payload.members
			short.owners = payload.owners
			short.Income = 0
			local high = math.random(short.Gold,short.Gold * 1.5)
			local low = math.random(short.Gold * 0.4,short.Gold)
			if low < 0 then low = 0 end
			short.lowEstimate = low
			short.highEstimate = high
			short.kickrate = payload.Rate
			short.Reveal = false
			short.Notes = {}
			short.OwnerHistory = {}
			publicdate.GlobalIDs = publicdate.GlobalIDs - 1 -- account ID tracker
			currentEnt = short.ID
			table.insert(short.owners,payload.ourid) 

			--Adding this account to the owner and member list
		for i,v in pairs (payload.owners)do
			
				table.insert(publicdate.Entity[v].YourAccounts,{AID = short.ID,Turnadded = Game.Game.TurnNumber})
		end
		for i,v in pairs (payload.members)do
			table.insert(publicdate.Entity[v].YourAccounts,{AID = short.ID,Turnadded = Game.Game.TurnNumber})
		end
		
	end
	payload.TargetPlayerID = publicdate.Entity[currentEnt].ID

end
-- Alter gold inside Accounts
function AlterGold(ID,Subtract,publicdata,process)
	local Entity = publicdata.Entity[ID]
	if Entity.Status == "A" then
		if process == "-" then
			Entity.Gold = Entity.Gold - Subtract
		elseif process == "+" then
			Entity.Gold = Entity.Gold + Subtract
		else
			Print("wrong process inputed")
		end

	elseif Entity.Status == "P" then

		if process == "-" then
			Game.ServerGame.SetPlayerResource(ID, WL.ResourceType.Gold, Entity.Gold - Subtract)
		elseif process == "+" then
			Game.ServerGame.SetPlayerResource(ID, WL.ResourceType.Gold, Entity.Gold + Subtract)
		else
			Print("wrong process inputed")
		end

	else
		print("Error: No Status found for Entity " .. ID .. " " .. Entity.Name .. " on function 'Altergold'")
	end
	return publicdata
end
-- Kicking Vote Creation
function KickingVoteCreation(publicdate,game,payload)
	local Ent = publicdate.Entity[payload.accountID]
	local addedvoteID = payload.Default
	print(payload.voteof,"ourID kick",addedvoteID)
	if Ent.KVote == nil then Ent.KVote = {} end
	if Ent.KVote[#Ent.KVote + 1] == nil then Ent.KVote[#Ent.KVote + 1] = {} 
		local short = Ent.KVote[#Ent.KVote]
		short.voteof = payload.voteof
		short.Vlist = {addedvoteID}
		short.Turncreated = game.Game.TurnNumber

	end
end
--Add vote 
function Addvote(publicdata,payload)
	local Ent = publicdata.Entity[payload.accountID]
	local KvoteID = payload.TargetID
	print(payload.plan,"voting ID")
	table.insert(Ent.KVote[KvoteID].Vlist,payload.Default)

	Ownerremovelogic(publicdata,payload,Ent,KvoteID)
end
--Remove Vote
function Removevote(publicdata,payload)
	local Ent = publicdata.Entity[payload.accountID]
	local KvoteID = payload.TargetID

	table.remove(Ent.KVote[KvoteID].Vlist,FindmatchID(Ent.KVote[KvoteID].Vlist,payload.Default,1)) -- remove ID from vote
	if #Ent.KVote[KvoteID].Vlist == 0 then 
		table.remove(Ent.KVote,KvoteID) -- Remove the Vote itself
	end

end
--Add owner to account
function AddOwner(publicdata,payload)

	table.insert(publicdata.Entity[payload.accountID].owners,payload.voteof)

end
--Add member to account
function AddMembers(publicdata,payload)

	table.insert(publicdata.Entity[payload.voteof].YourAccounts,{AID = payload.accountID,Turnadded = Game.Game.TurnNumber})
	table.insert(publicdata.Entity[payload.accountID].members,payload.voteof)

end
--remove owner to account
function RemoveOwner(publicdata,payload,removeID,accountID)
	local Ent = publicdata.Entity[payload.accountID]
	local Youraccounts = publicdata.Entity[removeID].YourAccounts
	print("did delete")
	table.remove(Youraccounts,Findmatch(Youraccounts,payload.accountID,"AID")) -- Remove account from your list of accounts
	table.remove(Ent.owners,FindmatchID(Ent.owners,removeID,1)) -- remove yourself from ownerlist
	

end

--check to see if kicking rate is above threshold
function Ownerremovelogic(publicdata,payload,Ent,KID)
	-- Variables
	local totalplayers = #Ent.members + #Ent.owners
	local KvoteT = Ent.KVote[KID]
	local didnotdelete = true

	-- vote percent calculations
	local Votedplayers = SearchValue2Table(Ent.owners,KvoteT.Vlist,nil)
	Votedplayers = SearchValue2Table(Ent.members,KvoteT.Vlist,Votedplayers)
	local percentVote = math.floor((#Votedplayers / totalplayers) * 100)
	-- vote percent rate
	if percentVote > Ent.kickrate then  
		didnotdelete = false

		print(payload,"payload check")
		table.remove(Ent.KVote,KID) -- Remove the Vote itself
		RemoveOwner(publicdata,payload,payload.Default,Ent.ID) -- remove logic
	end
	return didnotdelete
end

function RemoveMember(publicdate,payload)
	local AccountEnt = publicdate.Entity[payload.accountID]
	local Youraccounts = publicdate.Entity[payload.voteof].YourAccounts

	table.remove(Youraccounts,Findmatch(Youraccounts,payload.accountID,"AID")) -- Remove account from your list of accounts
	table.remove(AccountEnt.members,FindmatchID(AccountEnt.members,payload.voteof,1)) -- remove yourself from memberlist
end
-- Leaving Account
function LeavingAccount (publicdate,payload)
	-- variables
	local AccountEnt = publicdate.Entity[payload.accountID]
	local YourEnt = publicdate.Entity[payload.Default].YourAccounts
	local IsOwner = true
	--Member or Owner logic
	if not FindmatchID(AccountEnt.owners,payload.Default,2) then IsOwner = false end
	--remove from accountlist
	table.remove(YourEnt, Findmatch(YourEnt,payload.accountID,"AID")) -- Remove account from your list of accounts
	--remove from proper other list
	if IsOwner then
		table.remove(AccountEnt.owners,FindmatchID(AccountEnt.owners,payload.Default,1)) -- remove yourself from ownerlist
		LastOwner( publicdate, AccountEnt) 
	else
		table.remove(AccountEnt.members,FindmatchID(AccountEnt.members,payload.Default,1)) -- remove yourself from memberlist
	end


end
--update Vote status
function UpdateVote(publicdate,game)
	local CustomPayload = {Default = 0,accountID = 0}
	local breakLoop = false
	while breakLoop == false do -- keep redoing loop cause we deleted while looping
		breakLoop = true
		for i,v in pairs(publicdate.Entity) do
			if v.KVote ~= nil then
				for i2,v2 in pairs(v.KVote) do
					print("update vote")
					CustomPayload.Default = v2.voteof
					CustomPayload.accountID = v.ID
					if Ownerremovelogic(publicdate,CustomPayload,v,i2) then
						print("Access over time")
						if v2.Turncreated + 3 <= game.Game.TurnNumber then
							print("removed vote")
							table.remove(v.KVote,i2) -- Remove the Vote itself
							breakLoop = false
							break
						end
					end
				end
			end
		end
	end

end
-- Reveal Toggle of gold to players
function Revealtoggle(publicdate,payload)
	local Ent = publicdate.Entity[payload.accountID]
	print("toggled")
	if Ent.Reveal then Ent.Reveal = false 
	else Ent.Reveal = true end
end

function LastOwner (public,Ent) 

	if #Ent.owners == 0 then

		if #Ent.members > 0 then 
			local CustomPayload = {voteof = Ent.members[1],accountID = Ent.ID}

			AddOwner (public,CustomPayload)
			RemoveMember(public,CustomPayload)
		else 
			--delete account
			public.Entity[Ent.ID] = nil
			
		end
	end

end

function EnterText(publicdate,payload,game)

	table.insert(publicdate.Entity[payload.accountID].Notes,{Name = publicdate.Entity[payload.Default].Name,notes = payload.TargetID,Turn = game.Game.TurnNumber} )
end
function ClearText(publicdate,payload,game)

	publicdate.Entity[payload.accountID].Notes = {}
	
end