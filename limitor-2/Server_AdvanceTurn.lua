require('Utilities')


function Server_AdvanceTurn_Start(game, addNewOrder)

    local unitdata = {}


local place = 0
        for n,ts in pairs(game.ServerGame.LatestTurnStanding.Territories) do
            if place < 1000 then
                place = place + 1
                local mod = WL.TerritoryModification.Create(ts.ID)
     

                local UnitdiedMessage = "unit " .. place

                local builder = WL.CustomSpecialUnitBuilder.Create(ts.OwnerPlayerID);
                builder.Name = "";
                builder.IncludeABeforeName = true;
                builder.ImageFilename =  Filefinder(0);
                builder.AttackPower = 0;
                builder.DefensePower = 0;
                builder.CombatOrder = 3415; --defends commanders
                builder.DamageToKill = 0;
                builder.DamageAbsorbedWhenAttacked = 0;
                builder.CanBeGiftedWithGiftCard = true;
                builder.CanBeTransferredToTeammate = true;
                builder.CanBeAirliftedToSelf = true;
                builder.CanBeAirliftedToTeammate = true;
                builder.TextOverHeadOpt = ""
                builder.IsVisibleToAllPlayers = true;
                local unit = builder.Build()
                


                local mod = WL.TerritoryModification.Create(ts.ID)
                mod.AddSpecialUnits = {builder.Build()};


                addNewOrder(WL.GameOrderEvent.Create(0, UnitdiedMessage, nil, {mod}));

                
            end
            
        end
    

end


function Filefinder(image)

	if image == 0 then image = math.random(1,5) end
	local filestorage = {}
	
		filestorage[1] = 'pack 1.a.png'
		filestorage[2] = 'pack 1.b.png'
		filestorage[3] = 'pack 1.c.png'
		filestorage[4] = 'pack 1.d.png'
		filestorage[5] = 'pack 1.e.png'
	
	return filestorage[image]
end