package.path = package.path .. ';./Character-Pack-Antiquity/?.lua'

local describe, it, assert = require("busted").describe, require("busted").it, require("busted").assert
local Utilities = require("Utilities")
local Server_StartGame = require("Server_StartGame")

-- Mock WL calls
local mockWL = {
    CustomSpecialUnitBuilder = {
        Create = function(territoryOwnerID)
            local builder = {
                Build = function()
                    return {isBuilt = true, ownerID = territoryOwnerID}
                end,
                set = function(_, key, value)
                    print("Setting " .. key .. " to " .. tostring(value))
                    return builder
                end,
            }
            return setmetatable(builder, {
                __index = function(t, k)
                    return function(_, v)
                        t[k] = v
                        return t
                    end
                end
            })
        end,
    },
}

describe("generateUnitAttributes", function()
    before_each(function()
        -- Mock to return fixed value for predictability
        stub(math, "random", function(min, max) return (min + max) / 2 end)
    end)
    after_each(function()
        math.random:revert()  -- Revert math.random to its original implementation
    end)

    it("correctly generates unit attributes", function()
        local unit = {
            Name = "TestUnit",
            unitpower = 2,
            AttackMax = 4,
            Defend = 3,
            CombatOrder = 1,
            Visible = true,
            image = "testunit.png",
            Minlife = 1,
            Maxlife = 3,
            Level = 0,
            Altmoves = false,
            Assassination = 1,
        }
        local attributes = generateUnitAttributes(unit, 10)  -- Assuming game turn number is 10

        assert.are.same("TestUnit", attributes.name)
        assert.are.equals(3, attributes.attackPower)  -- (2+4)/2
        assert.are.equals(3, attributes.defensePower)
        assert.are.equals(-123, attributes.combatOrder)  -- CombatOrder == 1
        assert.is_true(attributes.isVisible)
        -- Continue with other assertions as needed
    end)
end)

describe("Server_StartGame", function()
    local capturedAttributes = {}

    before_each(function()
        math.random = function(min, max) return max end
        _G.fileFinder = function(filename) return "/mock/path/" .. filename end
        _G.modSign = function() return "mockedModSign" end
        _G.WL = mockWL

        -- Mock WL.CustomSpecialUnitBuilder.Create to capture builder calls
        WL.CustomSpecialUnitBuilder.Create = function(territoryOwnerID)
            local builder = {}
            function builder.Build() 
                return {isBuilt = true, ownerID = territoryOwnerID, attributes = capturedAttributes} 
            end
            -- Capture attributes set on the builder for verification
            setmetatable(builder, {
                __index = function(t, k)
                    return function(_, v)
                        capturedAttributes[k] = v
                        return t  -- Allow chaining
                    end
                end
            })
            return builder
        end

        -- Reset capturedAttributes before each test
        capturedAttributes = {}
    end)

    after_each(function()
        math.random = originalMathRandom
        _G.fileFinder = originalFileFinder
        _G.modSign = originalModSign
        _G.WL = originalWL
    end)

    it("creates a unit with expected parameters", function()
        local game = {Game = {TurnNumber = 1}}
        local standing = {
            Territories = {
                {OwnerPlayerID = 1, NumArmies = {NumArmies = 3}},
            }
        }

        -- Define expected unit attributes for the test case
        local expectedAttributes = {
            name = "LV0 Infantry",
            image = "/mock/path/infantry.png",
            attackPower = 5,  -- Assuming math.random(max) returns max for simplification
            defensePower = 2,
            combatOrder = -123,
            damageToKill = 3.5,  -- Simplified example calculation
            isVisible = true,
            modData = "mockedModSign;5;;0;5;2;0;0",  -- Expected modData format
        }

        -- Execute the Server_StartGame function
        Server_StartGame(game, standing)

        -- Verify that a unit was attempted to be created with the correct attributes
        for key, expectedValue in pairs(expectedAttributes) do
            assert.are.equals(expectedValue, capturedAttributes[key], "Attribute mismatch for " .. key)
        end
    end)
end)
