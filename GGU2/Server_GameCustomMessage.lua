require('Utilities')
require('WLUtilities')

--known bugs
-- when you buy a plan on turn 1, it causes a bug and doesn't detect when your over 75%

function Server_GameCustomMessage(game, playerID, payloadO, setReturnTable)
	Game = game
	local publicdate = Mod.PublicGameData

	-- check for payment plan data
	publicdate = DataCheck(publicdate,payloadO)

	print("payload0",payloadO.planid)
	local i = 1
	if payloadO.setup == 1 then -- continued setups
		if payloadO.setup == 1 or payloadO.setup == 3 then 
			publicdate.PayP.accessed = true
			publicdate.PayP.Sameturn = game.Game.TurnNumber
			
		end

	
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

			if v.Turntill <=  game.Game.TurnNumber and v.Turntill > 0 then
				payload.setup = 3
				i = i - 1

			end

			Paymentprocess(game,publicdate.Entity[payloadO.ourID],payload,setReturnTable,publicdate)
			i = i + 1

		end
	elseif payloadO.setup == 0 or payloadO.setup == 2 then --if payloadO.setup == 0 then -- single payment setup
		Paymentprocess(game,publicdate.Entity[payloadO.ourID],payloadO,setReturnTable,publicdate)
	elseif payloadO.setup == 5 then -- remove payment plan
		Removepayment(payloadO.planid,publicdate)
		setReturnTable({ Message = "Payment Plan removed" })
	elseif payloadO.setup == 6 then -- add member to account
	elseif payloadO.setup == 7 then -- add owner to account
	elseif payloadO.setup == 8 then -- remove member/owner from account
	elseif payloadO.setup == 9 then -- Withdraw funds
	elseif payloadO.setup == 10 then -- Create account
		Paymentprocess(game,publicdate.Entity[payloadO.ourID],payloadO,setReturnTable,publicdate)
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
function Addhistory(targetplayerid,publicdate, actualgold,playerid,reveal)
	if publicdate.PayP.History[#publicdate.PayP.History + 1] == nil then
		publicdate.PayP.History[#publicdate.PayP.History + 1] = {}
		local short = publicdate.PayP.History[#publicdate.PayP.History]
		short.from = playerid
		short.to = targetplayerid
		if reveal == false then short.noshow = "???" end 
		short.goldamount = actualgold

		short.turn = Game.Game.TurnNumber
	end
	
end
--Processing the payment itself
function Paymentprocess(game,Lentity,payload,setReturnTable,publicdate)
	--Entity variables
	local entity = Lentity
	--Base payment variables
	local id = payload.TargetPlayerID
	local setgold = payload.setgold
	local setturn = payload.setturn
	local contu = payload.Cont
	local ourid = entity.ID
	local newPlan = payload.setup
	local planid = payload.planid
	
	--Base gold variables
	local actualGoldSent = 0                 --- how much gold is actually sent
	local goldSending = payload.Gold; -- How much gold you sent before tax was applied
	local goldtax = payload.multiplier 
	local percent = payload.percent
	
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
	local goldHave = entity.Gold
	
	-- if new turn, reset taxidtable
	if (publicdate.orderaccess == false)then
		publicdate.taxidtable = {}
		publicdate.taxidtable[ourid] = {count = 0, gap = 0}
		publicdate.orderaccess = true
	end 
	
	-- Cannot gift yourself logic
	if (ourid == payload.TargetPlayerID) then
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
		if #publicdate.PayP.Plan > 0 and entity.Income *0.75 < Banked(publicdate,tempgold,ourid) then 
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
		actualGoldSent = (goldSending+gap2);
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
	publicdate.orderAlt[publicdate.orderamount].targetPlayer = id
	publicdate.orderAlt[publicdate.orderamount].us = payload.ourID
	publicdate.orderAlt[publicdate.orderamount].reveal = payload.reveal
	publicdate.HiddenOrders = payload.hidden


	
	-- History logic
	Addhistory(id,publicdate,actualGoldSent,ourid,payload.reveal)
	Mod.PublicGameData = publicdate -- Saving Data

	print("---------- End of updated Code ----------")
	--Subtract goldSending from ourselves, add goldSending to target

	-- Getting target player for gold and name
	local targetPlayer = game.Game.Players[payload.TargetPlayerID]
	local targetPlayerHasGold = game.ServerGame.LatestTurnStanding.NumResources(targetPlayer.ID, WL.ResourceType.Gold)

	game.ServerGame.SetPlayerResource(ourid, WL.ResourceType.Gold, goldHave - goldSending)
	game.ServerGame.SetPlayerResource(targetPlayer.ID, WL.ResourceType.Gold, targetPlayerHasGold + actualGoldSent)

	setReturnTable({ Message = "Sent " .. targetPlayer.DisplayName(nil, false) .. ': ' .. actualGoldSent .. ' gold.\nYou now have: ' .. (goldHave - goldSending) .. '.', realGold = actualGoldSent  })

end
 
-- Pre entry data creation/updating
function DataCheck(publicdate,payload)
	local ID = payload.ourID

	if publicdate.GlobalIDs == nil then publicdate.GlobalIDs =  -1 end
	if (publicdate.PayP == nil )then publicdate.PayP = {} end
	if (publicdate.PayP.Plan == nil)then publicdate.PayP.Plan = {} end
	if (publicdate.PayP.History == nil)then publicdate.PayP.History = {} end

	if publicdate.PayP.Sameturn == nil then publicdate.PayP.Sameturn = Game.Game.TurnNumber end
	if publicdate.PayP.accessed == nil then publicdate.PayP.accessed = true end

	--entities creation
	if publicdate.Entity == nil then publicdate.Entity = {} end
	if publicdate.Entity[ID] == nil then publicdate.Entity[ID] = {}
		local short = publicdate.Entity[ID]
		if Game.Game.PlayingPlayers[ID] ~= nil then
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
		else -- creating an account
			short.Name = payload.Accountname
			short.ID = publicdate.GlobalIDs
			short.Status = "A"
			short.Gold = 0
			short.members = {}
			short.owners = {}
			short.Gold = payload.Gold
			short.Income = 0
			local high = math.random(short.Gold ,short.Gold * 1.5)
			local low = math.random(short.Gold * 0.5,short.Gold)
			short.lowEstimate = low
			short.highEstimate = high
			--jijiji
			short.AlterGold() --jijij

			publicdate.GlobalIDs = publicdate.GlobalIDs - 1
		end
	end
	
	-- Entity Update check
	for i,v in pairs (publicdate.Entity) do
		 if v.Status == "P" then
			v.Gold = Game.ServerGame.LatestTurnStanding.NumResources(i, WL.ResourceType.Gold)
			local standing = Game.ServerGame.LatestTurnStanding
			local player = Game.Game.PlayingPlayers[ID]
			local income = {Total = 0}
			if player ~= nil then -- Making sure the player is actually still in the game
				income = player.Income(0, standing, false, false)
			end
			v.Income = income.Total
		 elseif v.Status == "A" then
			local high = math.random(v.Gold ,v.Gold * 1.5)
			local low = math.random(v.Gold * 0.5,v.Gold)
			v.lowEstimate = low
			v.highEstimate = high
		 else
			print("Error: no Status found for entity " .. i .. " " .. v.Name)
		 end 
	end

	return publicdate
end

function AlterGold(ID)
	
end
