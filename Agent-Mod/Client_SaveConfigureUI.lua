
function Client_SaveConfigureUI(alert)


        --agent cost
        local agent = InportAgentcost.GetValue()
        if agent > 5000 or agent < 0 then alert('Agent value not supported. please stay within 0-5000')
            Mod.Settings.Agentcost = 1
        else 
            Mod.Settings.Agentcost = agent 
        end

        --Decoy cost
        local decoy = InportDecoycost.GetValue()
        if decoy > 5000 or decoy < 0 then alert('Decoy value not supported. please stay within 0 - 5000')
            Mod.Settings.Decoycost = 1
        else 
            Mod.Settings.Decoycost = decoy 
        end

        --city amount removed
        local city = InportCityamount.GetValue()
        if city > 10 or city < 0 then alert('City value not supported. please stay within 0 - 10')
            Mod.Settings.Citylost = 1
        else 
            Mod.Settings.Citylost = city 
        end

        --armylost Allowed or not
        local armylost = InportArmieslost.GetValue()
        if armylost > 5000 or armylost < 0 then alert('Army value not supported. please stay within 0 - 5000') 
        else
            Mod.Settings.ArmiesLost = armylost
        end
        --Cooldown for agents
        local cooldown = InportCooldown.GetValue()
        if cooldown > 25 or cooldown < 1 then alert('Cool down value not supported. please stay within 1 - 25') 
        else
            Mod.Settings.Cooldown = cooldown
        end

        --Cards Allowed or not
        local Cardsallowed = InportCardsallowed.GetIsChecked()
        Mod.Settings.Cardsremoved = Cardsallowed

        --Operation cost
        local mission = Inportmissioncost.GetValue()
        if mission > 10000 or mission < 0 then alert('Mission Cost value not supported. please stay within 0 - 10000') 
        else
            Mod.Settings.MissionCost = mission
        end
        

        --Agency Creation feature
        local creation = Inportcreationfeecost.GetValue()
        if creation > 5000 or creation < 0 then alert('Agency creation value not supported. please stay within 0 - 5000')
            Mod.Settings.Creationfee = 1
        else 
            Mod.Settings.Creationfee = creation 
        end
    end
