require('Utilities2');
require('WLUtilities');

function Server_GameCustomMessage(game, playerID, payload, setReturnTable)




local publicdate = Mod.PublicGameData
local id = payload.TargetPlayerID
-- check for turn passing


--tables for public data dhecks
if (publicdate.taxidtable == nil)then  publicdate.taxidtable = {count = 0, gap = 0, turn = game.Game.TurnNumber}end;
--customOrder bypass logic 
if (publicdate.orderAlt == nil)then publicdate.orderAlt = {}end
if (publicdate.orderamount == nil)then publicdate.orderamount = 0 end
if (publicdate.orderaccess == nil)then publicdate.orderaccess = true end

if (publicdate.taxidtable.turn ~= game.Game.TurnNumber)then -- if new turn, reset taxidtable
	publicdate.taxidtable.turn = game.Game.TurnNumber
	publicdate.taxidtable.gap = 0
	publicdate.taxidtable.count = 0
	
	publicdate.orderaccess = true
end 

--sending gold variables
local actualGoldSent = 0                 --- how much gold is actually sent
local goldSending = payload.Gold;
local goldtax = payload.multiplier
local storeC =  publicdate.taxidtable.count
local storegap = publicdate.taxidtable.gap
local goldHave = game.ServerGame.LatestTurnStanding.NumResources(playerID, WL.ResourceType.Gold);




	if (playerID == payload.TargetPlayerID) then
		setReturnTable({ Message = "You can't gift yourself" });
		return;
	end


	if (goldHave < goldSending) then  -- don't have enough money
		setReturnTable({ Message = "You can't gift " .. goldSending .. " when you only have " .. goldHave });
		return;
	end

	-- checking to see if a gold tax was set during game creation
	if (goldtax == nil)then goldtax = 0 end;


	print (storeC .. ' :storeC')
	-- keeping track wheather or not players have exceeded tax by adding gap gold from last gift
	if (storegap + goldSending > goldtax and storegap > 0 )then
		local gap2 = goldtax - storegap

		print(goldSending .. ' :goldsending')

		goldSending = goldSending - gap2

		print( 'phase1 used')
		print(actualGoldSent .. ' '.. goldSending .. ' '.. storegap .. ' ' .. storeC.. ' :end')

		actualGoldSent = actualGoldSent + (gap2 / (storeC + 1))
		storegap = 0
		publicdate.taxidtable.gap = storegap
		publicdate.taxidtable.count = publicdate.taxidtable.count + 1

		print( 'phase2 used')
		print(actualGoldSent .. ' '.. goldSending .. ' '.. storegap ..' '.. gap2 .. ' ' .. ' :end')
	end




-- tax multiplier logic
	if (goldtax > 0 )then -- if 0, host wants no Tax applied
	local ga = goldtax        --- how many units in each group
	local group = math.ceil(goldSending / ga)                  --- how many groups of Ga are in goldsending


		for C = 1, group, 1 do

			if (C < group)then
				actualGoldSent = actualGoldSent + (ga / (C + storeC)) --appliy Tax to gold divided into groups

			elseif (C >= group) then -- this means your in the last group
				local gap = goldSending - (ga * (C-1)) -- finding the difference between the last group and current amount in 'actualGoldSent'
				actualGoldSent = actualGoldSent + (gap / (C + storeC))


				print(gap.. ' '.. storegap)

				if (gap == goldtax)then -- cancel gap logic if you sent the exact amount
					storeC = storeC + 1
					gap = 0
					print ('gap == goldtax')
				end

				 publicdate.taxidtable.count = ((C + storeC) - 1) -- tracking tax rate group
				publicdate.taxidtable.gap = publicdate.taxidtable.gap + gap -- tracking gap between next group
				print(gap.. ' '.. publicdate.taxidtable.gap)
			end
		end
	else
		actualGoldSent = goldSending;

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

