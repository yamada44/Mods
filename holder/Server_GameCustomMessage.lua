require('Utilities2');
require('WLUtilities');

function Server_GameCustomMessage(game, playerID, payload, setReturnTable)




local publicdate = Mod.PublicGameData
local id = payload.TargetPlayerID
local ourid = payload.ourID
-- check for turn passing


--tables for public data dhecks
if (publicdate.taxidtable == nil)then  publicdate.taxidtable = {}end
if (publicdate.taxidtable[ourid] == nil)then publicdate.taxidtable[ourid] = {count = 0, gap = 0}end;

--customOrder bypass logic 
if (publicdate.orderAlt == nil)then publicdate.orderAlt = {}end
if (publicdate.orderamount == nil)then publicdate.orderamount = 0 end
if (publicdate.orderaccess == nil)then publicdate.orderaccess = true end

if (publicdate.orderaccess == false)then -- if new turn, reset taxidtable
	publicdate.taxidtable = {}
	publicdate.taxidtable[ourid] = {count = 0, gap = 0}
	
	publicdate.orderaccess = true
end 

--sending gold variables
local actualGoldSent = 0                 --- how much gold is actually sent
local goldSending = payload.Gold;
local goldtax = payload.multiplier
local percent = payload.percent
local gap2 = 0
local storeC =  publicdate.taxidtable[ourid].count
local storegap = publicdate.taxidtable[ourid].gap
local goldHave = game.ServerGame.LatestTurnStanding.NumResources(playerID, WL.ResourceType.Gold);




	if (playerID == payload.TargetPlayerID) then
		setReturnTable({ Message = "You can't gift yourself" });
		return;
	end


	if (goldHave < goldSending) then  -- don't have enough money
		setReturnTable({ Message = "You have less then " .. goldSending .. " gold. your current gold reserve is: " .. goldHave .. '\n\n' .. 'Refresh Page for best results' });
			return;
	end

	-- checking to see if a gold tax was set during game creation
	if (goldtax == nil)then goldtax = 0 end;


	print (storeC .. ' :storeC')
	-- keeping track wheather or not players have exceeded tax by adding gap gold from last gift
	if (storegap + goldSending > goldtax and storegap > 0 )then
		gap2 = goldtax - storegap

		print(goldSending .. ' :goldsending')

		

		print( 'phase1 used')
		print(actualGoldSent .. ' '.. goldSending .. ' '.. storegap .. ' ' .. storeC.. ' :end')

		actualGoldSent = actualGoldSent + (gap2 / (storeC + 1))
		storegap = 0
		publicdate.taxidtable[ourid].gap = storegap
		storeC = storeC + 1

		print( 'phase2 used')
		print(actualGoldSent .. ' '.. goldSending .. ' '.. storegap ..' '.. gap2 .. ' ' .. ' :end')
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

	Mod.PublicGameData = publicdate -- end of packaging

	local targetPlayer = game.Game.Players[payload.TargetPlayerID];
	local targetPlayerHasGold = game.ServerGame.LatestTurnStanding.NumResources(targetPlayer.ID, WL.ResourceType.Gold);


	--Subtract goldSending from ourselves, add goldSending to target
	game.ServerGame.SetPlayerResource(playerID, WL.ResourceType.Gold, goldHave - goldSending);
	game.ServerGame.SetPlayerResource(targetPlayer.ID, WL.ResourceType.Gold, targetPlayerHasGold + actualGoldSent);
	setReturnTable({ Message = "Sent " .. targetPlayer.DisplayName(nil, false) .. ': ' .. actualGoldSent .. ' gold.\nYou now have: ' .. (goldHave - goldSending) .. '.', realGold = actualGoldSent  });

end

