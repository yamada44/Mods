
function Client_SaveConfigureUI(alert)

--mapping data
    local mapvalue = InputMap.GetValue()
    if mapvalue > Maplimit or mapvalue <= 0 then alert('Map value not supported. please stay within 1-5')
        Mod.Settings.maplist = {}
        Mod.Settings.maplist = Maploader(1) -- defaulted to one if nothing was picked
        Mod.Settings.mapreturnvalue = 1
    else 
        Mod.Settings.maplist = {}
        Mod.Settings.maplist = Maploader(mapvalue) 
        Mod.Settings.mapreturnvalue = mapvalue
    end

    --mod data
    local modinput = InputModpicker.GetValue()
    if modinput > Modlimit or modinput < 0 then alert('Mod value not supported. please stay within 1-'.. Modlimit)
        Mod.Settings.Modlist = Modloader(1) -- defaulted to one if nothing was picked
        Mod.Settings.modinputreturn = 1
    else 
        Mod.Settings.Modlist = Modloader(modinput) 
        Mod.Settings.modinputreturn = modinput
    end

        --neutral amount data
        local neutral = InputNeutralamount.GetValue()
        if neutral > 5000 or neutral < 0 then alert('Neutral value not supported. please stay within 0-5000')
            Mod.Settings.Neutral = 1
        else 
            Mod.Settings.Neutral = neutral 
        end

    print (Mod.Settings.maplist[1], Mod.Settings.maplist, mapvalue,modinput)
end


function Maploader(loadnumber)
    local list = {}

    if loadnumber == 1 then
        list = {'Caspian Sea',
        'Black Sea',
        'Aegean Sea',
        'Eastern Mediterranean Sea',
        'Western Mediterranean Sea',
        'Central Mediterranean Sea',
        'Adriatic Sea',
        'Tyrrhenian Sea',
        'Red Sea',
        'African Coast',
        'Iberian Coast',
        'Central Atlantic Gap',
        'Mid Atlantic Gap',
        'Biscay Bay',
        'North Atlantic Ridge',
        'Denmark Strait',
        'Danish Belts',
        'Norwegian Sea',
        'Norwegian Coast',
        'Barents Sea',
        'Upper Baltic Sea',
        'Lower Baltic Sea',
        'English Channel',
        'Western Approaches',
        'North Sea',
        'Eastern North Sea'
        }
    
    elseif loadnumber == 2 then
            list = {
        'Atlantic',
        'Indian',
        'Pacific',
        'Caspian Sea',
        'Aegean Sea',
        'Ionian Sea',
        'Tyrrhenian Sea',
        'Adriatic Sea',
        'Alboran Sea',
        'Celtic Sea',
        'Bay of Biscay',
        'East Siberian Sea',
        'Chukchi Sea',
        'Sea of Okhotsk',
        'Bering Sea',
        'Strait of Tartary',
        'Sea of Japan',
        'Bohai Sea',
        'Yellow Sea',
        'East China Sea',
        'South China Sea',
        'Sulu Sea',
        'Arabian Sea',
        'Bay of Bengal',
        'Red Sea',
        'Persian Gulf',
        'Banda Sea',
        'Java Sea',
        'Malacca Strait',
        'Andaman Sea',
        'Coral Sea',
        'Bass Strait',
        'Tasman Sea',
        'Gulf of Carpentaria',
        'Timor Sea',
        'Arafura Sea',
        'Celebes Sea',
        'Halmahera Sea',
        'Mozambique Channel',
        'Scotia Sea',
        'Chilean Sea',
        'Soloman Sea',
        'Philippine Sea',
        'Caribbean Sea',
        'Gulf of Mexico',
        'North Sea',
        'Gulf of Guinea',
        'Baltic Sea',
        'Greenland Sea',
        'Norwegian Sea',
        'Denmark Strait',
        'Labrador Sea',
        'Foxe Basin',
        'Hudson Bay',
        'Baffin Bay',
        'Gulf of St Lawrence',
        'Gulf of Aden',
        'Gulf of California',
        'Gulf of Alaska',
        'Makassar Strait'
      }
    end

    return list
    
end

function Modloader(loadnumber)
    local list = {}

    if loadnumber > 0 then
        list[1] = 'C&PA'
        list[2] = 'C&PB'
        --list[3] = 'C&PC'
        --list[4] = 'C&PD'
        --list[5] = 'C&PE'
        
    
    elseif loadnumber == 0 then 
        list[50] = 0
        loadnumber = 50 
    end 
        
    
    return list[loadnumber]
    
end