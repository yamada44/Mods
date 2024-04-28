package.path = package.path .. ';../CharacterPackTemplate/?.lua'
Utilities = require('Utilities')
Server_AdvanceTurn = require('Server_AdvanceTurn')

local busted = require('busted')
local describe, it, assert = busted.describe, busted.it, busted.assert

describe("isValidMove function", function()
    local originalModSign

    busted.before_each(function()
        originalModSign = _G.modSign

        _G.modSign = function(mode)
            if mode == 0 then
                return "C&PA"
            elseif mode == 1 then
                return {"Barbarian", "Roman Legion", "Horse", "Man", "Woman", "Random"}
            end
        end
    end)

    busted.after_each(function()
        if originalModSign then
            _G.modSign = originalModSign
        else
            _G.modSign = nil
        end
    end)

    local function mockSlowSpecialUnit(slowValue)
        return {
            proxyType = "CustomSpecialUnit",
            ModData = "C&PA;;0;;0;;0;;0;;0;;0;;0;;" .. slowValue .. ";;0"
        }
    end

    it("should return false if any special unit has a slow attribute greater than 0", function()
        local result = {
            ActualArmies = {
                SpecialUnits = {
                    mockSlowSpecialUnit(0),
                    mockSlowSpecialUnit(1)
                }
            }
        }
        assert.is_false(isValidMove(result))
    end)

    it("should return true if no special unit has a slow attribute greater than 0", function()
        local result = {
            ActualArmies = {
                SpecialUnits = {
                    mockSlowSpecialUnit(0),
                    mockSlowSpecialUnit(0)
                }
            }
        }
        assert.is_true(isValidMove(result))
    end)
end)

-- describe("Server_AdvanceTurn_Start", function()
--     local game, addNewOrder

--     -- Setup common game structure and mocks before each test
--     before_each(function()
--         game = {
--             ServerGame = {
--                 LatestTurnStanding = {
--                     Territories = {
--                         { ID = 1, NumArmies = { SpecialUnits = {} } },
--                         { ID = 2, NumArmies = { SpecialUnits = {} } }
--                     }
--                 }
--             },
--             Game = { TurnNumber = 5 }
--         }
        
--         addNewOrder = stub.new()
        
--         -- Mocking external dependencies
--         _G.isSpecialUnit = stub.new(true)  -- Assume all units are special
--         _G.getUnitData = stub.new()
--         _G.WL = {
--             TerritoryModification = {
--                 Create = function(id) return { RemoveSpecialUnitsOpt = {} } end
--             },
--             GameOrderEvent = {
--                 Create = function(ownerId, message, _, modifications)
--                     return { ownerId = ownerId, message = message, modifications = modifications }
--                 end
--             }
--         }
--     end)

--     after_each(function()
--         addNewOrder:revert()
--         isSpecialUnit:revert()
--         getUnitData:revert()
--     end)

--     it("should handle expired units correctly", function()
--         -- Setting up a unit that should expire
--         local unit = {
--             ID = 1, 
--             OwnerID = 100,
--             TextOverHeadOpt = "Unit",
--             Name = "Hero"
--         }
--         game.ServerGame.LatestTurnStanding.Territories[1].NumArmies.SpecialUnits = { unit }

--         getUnitData.on_call_with(unit).returns({ expiryTurn = 4 })  -- Expired last turn

--         Server_AdvanceTurn_Start(game, addNewOrder)

--         -- Check that addNewOrder was called with the correct parameters
--         assert.stub(addNewOrder).was_called_with(match.is_table_containing({
--             ownerId = 100,
--             message = "Unit the Hero has died of natural causes",
--             modifications = match.is_table_containing({ RemoveSpecialUnitsOpt = match.is_table_containing({1}) })
--         }))
--     end)

--     it("should not remove units that have not expired", function()
--         -- Setting up a unit that should not expire yet
--         local unit = {
--             ID = 2, 
--             OwnerID = 200,
--             TextOverHeadOpt = "Unit",
--             Name = "Villain"
--         }
--         game.ServerGame.LatestTurnStanding.Territories[1].NumArmies.SpecialUnits = { unit }

--         getUnitData.on_call_with(unit).returns({ expiryTurn = 6 })  -- Expires next turn

--         Server_AdvanceTurn_Start(game, addNewOrder)

--         -- Check that addNewOrder was not called
--         assert.stub(addNewOrder).was_not_called()
--     end)
-- end)
