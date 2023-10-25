
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
        if decoy > 5000 or decoy < 0 then alert('Decoy value not supported. please stay within 0-5000')
            Mod.Settings.Decoycost = 1
        else 
            Mod.Settings.Decoycost = decoy 
        end

        --city amount removed
        local city = InportCityamount.GetValue()
        if city > 10 or city < 0 then alert('City amount value not supported. please stay within 0-10')
            Mod.Settings.Citylost = 1
        else 
            Mod.Settings.Citylost = city 
        end

        --City Allowed or not
        local cityallowed = InportCityallowed.GetIsChecked()
        Mod.Settings.Cityremoved = cityallowed

        --Cards Allowed or not
        local Cardsallowed = InportCardsallowed.GetIsChecked()
        Mod.Settings.Cardsremoved = Cardsallowed

        print (agent,decoy,city,cityallowed,Cardsallowed)

        --Agency Creation feature
        local creation = Inportcreationfeecost.GetValue()
        if creation > 5000 or creation < 0 then alert('Agency creation value not supported. please stay within 0-5000')
            Mod.Settings.Creationfee = 1
        else 
            Mod.Settings.Creationfee = creation 
        end
    end
