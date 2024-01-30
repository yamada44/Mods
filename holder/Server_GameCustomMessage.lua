require('Utilities2');
require('WLUtilities')

--known bugs
-- when you buy a plan on turn 1, it causes a bug and doesn't detect when your over 75%

function Server_GameCustomMessage(game, playerID, payloadO, setReturnTable)
	Game = game
	local publicdate = Mod.PublicGameData

	-- check for payment plan data
	if (publicdate.PayP == nil )then publicdate.PayP = {} end
	if (publicdate.PayP.Plan == nil)then publicdate.PayP.Plan = {} end
	if (publicdate.PayP.History == nil)then publicdate.PayP.History = {} end

	if publicdate.PayP.Sameturn == nil then publicdate.PayP.Sameturn = game.Game.TurnNumber end
	if publicdate.PayP.accessed == nil then publicdate.PayP.accessed = true end
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

			Paymentprocess(game,payload.ourID,payload,setReturnTable,publicdate)
			i = i + 1

		end
	elseif payloadO.setup == 0 or payloadO.setup == 2 then --if payloadO.setup == 0 then -- single payment setup
		Paymentprocess(game,playerID,payloadO,setReturnTable,publicdate)
	elseif payloadO.setup == 5 then
		Removepayment(payloadO.planid,publicdate)
		setReturnTable({ Message = "Payment Plan removed" })
		
	end


	Mod.PublicGameData = publicdate 

end

function Newpayment(payload,publicdate,playerid)
	local id = payload.TargetPlayerID
local setgold = payload.setgold
local setturn = (payload.setturn) + Game.Game.TurnNumber
local contu = payload.Cont
local goldtax = payload.multiplier
local percent = payload.percent
	-- 1 = continues || 2 = set


		if contu == true then
		contu = 2
		else 
			setturn = 0
			contu = 1
		end


	if (publicdate.PayP.Plan[#publicdate.PayP.Plan + 1] == nil )then publicdate.PayP.Plan[#publicdate.PayP.Plan + 1] = {}
	local short = publicdate.PayP.Plan[#publicdate.PayP.Plan]	
	short.goldsent = setgold
	short.aftertax = setgold
	short.targetplayer = id
	short.cont = contu -- what kind of plan needed for the action
	short.Turntill = setturn 
	short.reveal = payload.reveal
	short.hidden = payload.hidden
	short.percent = percent
	short.goldtax = goldtax
	short.setup = payload.setup -- what kind of action needed for plan
	short.ID = playerid
	short.bank = 0
	print(short.ID,"payment create")
	end
	print("interesting")
	return setgold
end
function Banked(publicdate,setgold,ID)
	local total = 0
	for i, v in pairs (publicdate.PayP.Plan) do
		if ID == v.ID then
		total = total + v.goldsent end
	end

	return total + setgold
end

function Removepayment(planid,publicdate)
	table.remove(publicdate.PayP.Plan,planid)
end

function Paymentprocess(game,playerID,payload,setReturnTable,publicdate)


	local id = payload.TargetPlayerID
	local setgold = payload.setgold
	local setturn = payload.setturn
	local contu = payload.Cont
	local ourid = payload.ourID
	local newPlan = payload.setup
	local planid = payload.planid
	
	
	--sending gold variables
	local actualGoldSent = 0                 --- how much gold is actually sent
	local goldSending = payload.Gold;
	local goldtax = payload.multiplier
	local percent = payload.percent
	


	
	--tables for public data dhecks
	if (publicdate.taxidtable == nil)then  publicdate.taxidtable = {}end
	if (publicdate.taxidtable[ourid] == nil)then publicdate.taxidtable[ourid] = {count = 0, gap = 0}end
	
	--customOrder bypass logic 
	if (publicdate.orderAlt == nil)then publicdate.orderAlt = {}end
	if (publicdate.orderamount == nil)then publicdate.orderamount = 0 end
	if (publicdate.orderaccess == nil)then publicdate.orderaccess = true end
	
	
	--if (publicdate.PayP.ID)
	
	if (publicdate.orderaccess == false)then -- if new turn, reset taxidtable
		publicdate.taxidtable = {}
		publicdate.taxidtable[ourid] = {count = 0, gap = 0}
		
		publicdate.orderaccess = true
	end 
	
	
	
	
	local gap2 = 0
	local storeC =  publicdate.taxidtable[ourid].count
	local storegap = publicdate.taxidtable[ourid].gap
	local goldHave = game.ServerGame.LatestTurnStanding.NumResources(playerID, WL.ResourceType.Gold);
	
	
	
	
		if (ourid == payload.TargetPlayerID) then
			setReturnTable({ Message = "You can't gift yourself" });
			return
		end
		
		if newPlan > 0 then -- Adding continued/Set turns logic
			local standing = game.ServerGame.LatestTurnStanding
			local player = game.Game.PlayingPlayers[ourid]
			local income = player.Income(0, standing, false, false) 
			print(#publicdate.PayP.Plan,"plans")
			local tempgold = 0 
			if newPlan == 2 then tempgold = setgold end
			if #publicdate.PayP.Plan > 0 and income.Total *0.75 < Banked(publicdate,tempgold,ourid) then 
				print("did not pay payment")
				if contu == 2 then
					publicdate.PayP.Plan[planid].Turntill = publicdate.PayP.Plan[planid].Turntill + 1 end
					setReturnTable({ Message = "Your combined payments exceed 75% of your income\nPayment plan cancelled"})
			return end

			if newPlan == 2 then --creating new payment plan
	
				goldSending = Newpayment(payload,publicdate,playerID)
					
			elseif newPlan == 3 then -- removing payment plan
				Removepayment(planid,publicdate)


			end
		end
	
		if (goldHave < goldSending) then  -- don't have enough money
			setReturnTable({ Message = "You have less then " .. goldSending .. " gold. your current gold reserve is: " .. goldHave .. '\n\n' .. 'Refresh Page for best results' })
				return
		end
	
		-- checking to see if a gold tax was set during game creation
		if (goldtax == nil)then goldtax = 0 end;
	

	






		print (storeC .. ' :storeC')
		-- keeping track wheather or not players have exceeded tax by adding gap gold from last gift
		if (storegap + goldSending > goldtax and storegap > 0 )then
			gap2 = goldtax - storegap
	
			actualGoldSent = actualGoldSent + (gap2 / (storeC + 1))
			storegap = 0
			publicdate.taxidtable[ourid].gap = storegap
			storeC = storeC + 1
	
		end
	
	
	
	
	-- tax multiplier logic
		if (goldtax > 0 )then -- if 0, host wants no Tax applied
		local ga = goldtax        --- how many units in each group
		local group = math.ceil((goldSending - gap2) / ga)                  --- how many groups of Ga are in goldsending
	
	
			for C = 1, group, 1 do
	
				if (C < group)then
					actualGoldSent = actualGoldSent + (ga / (C + storeC)) --appliy Tax to gold divided into groups
	
				elseif (C >= group) then -- this means your in the last group
					local gap = (goldSending-gap2) - (ga * (C-1)) -- finding the difference between the last group and current amount in 'actualGoldSent'
					actualGoldSent = actualGoldSent + (gap / (C + storeC))
	
	
					print(gap.. ' '.. storegap)
	
					if (gap == goldtax)then -- cancel gap logic if you sent the exact amount
						storeC = storeC + 1
						gap = 0
						print ('gap == goldtax')
					end
	
					 publicdate.taxidtable[ourid].count = ((C + storeC) - 1) -- tracking tax rate group
					publicdate.taxidtable[ourid].gap = publicdate.taxidtable[ourid].gap + gap -- tracking gap between next group
					print(gap.. ' '.. publicdate.taxidtable[ourid].gap)
				end
			end
		
		elseif (percent > 0 )then
			local temppercent = 100 - percent
			local percentGold = goldSending * (temppercent / 100)
			actualGoldSent = (percentGold+gap2);
	
		else
			actualGoldSent = (goldSending+gap2);
	
		end
	 
	
	print ('----------------')
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
	
		local targetPlayer = game.Game.Players[payload.TargetPlayerID];
		local targetPlayerHasGold = game.ServerGame.LatestTurnStanding.NumResources(targetPlayer.ID, WL.ResourceType.Gold)
		
		Addhistory(id,publicdate,actualGoldSent,playerID,payload.reveal)
		Mod.PublicGameData = publicdate -- end of packaging

		--Subtract goldSending from ourselves, add goldSending to target
		game.ServerGame.SetPlayerResource(ourid, WL.ResourceType.Gold, goldHave - goldSending)
		game.ServerGame.SetPlayerResource(targetPlayer.ID, WL.ResourceType.Gold, targetPlayerHasGold + actualGoldSent)
		setReturnTable({ Message = "Sent " .. targetPlayer.DisplayName(nil, false) .. ': ' .. actualGoldSent .. ' gold.\nYou now have: ' .. (goldHave - goldSending) .. '.', realGold = actualGoldSent  })

end

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