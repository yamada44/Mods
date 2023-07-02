
function Client_SaveConfigureUI(alert)

--mapping data
    local mapvalue = InputMap.GetValue()
    if mapvalue > Maplimit or mapvalue < 1 then alert('Map value not supported. please stay within 1-'.. Maplimit)
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
        'Gulf of Thailand',
        'Beaufort Sea',
        'Barents Sea',
        'Makassar Strait',
        'Kora Sea',
        'Taiwan Strait',
        'Sibuyan Sea',
        'Mediterranean Sea',
        'Sea of Crete',
        'Black Sea',
        'Balearic Sea',
        'Northwestern Passage',
        'Gulf of Oman',
        'Hudson Strait',
        'English Channel',
        'Gulf of Bothnia',
        'White Sea',
        'Coronation Gulf',
        'Irish Sea'

      }
    
    elseif loadnumber == 3 then
     list = { '#'}
    

    elseif loadnumber == 4 then
    list = {
    'Sea of Elea',
    'Sea of Terina',
    'East Tyrrenikon Pelagos',
    'South Tyrrenikon Pelagos',
    'West Tyrrenikon Pelagos',
    'Sea of Lipara',
    'Sea of Naxos',
    'Sea of Syracousai',
    'Sea of Gela',
    'Sea of Selinous',
    'Sea of Lilyvaion',
    'Zephyrion Pelagos',
    'Path to Sicily',
    'South Sea of Kroton',
    'North Sea of Kroton',
    'North bay of Taras',
    'South bay of Taras',
    'East bay of Taras',
    'West bay of Taras',
    'Sea of Aquitania',
    'Sea of Epidamnia',
    'South Adriatike',
    'North Ionion Pelagos',
    'West Ionion Pelagos',
    'East sea of Calabria',
    'Central Ionion Pelagos',
    'North Sea of Kerkyra',
    'South Sea of Kerkyra',
    'Amvrakikos Kolpos',
    'Southwest Ionion Pelagos',
    'Southeast Ionion Pelagos',
    'Sea of Leukas',
    'Sea of Kephallenia',
    'Sea of Ithake',
    'Patraikos Kolpos',
    'East Korinthian Bay',
    'West Korinthian Bay',
    'South Kyparissiakos Kolpos',
    'North  Kyparissiakos Kolpos',
    'Messeniakos Kolpos',
    'Lakonikos Kolpos',
    'West Livykon Pelagos',
    'East Livykon Pelagos',
    'Central Livykon Pelagos',
    'West Kretikon Pelagos',
    'East Kretikon Pelagos',
    'Central Kretikon Pelagos',
    'Sea of Kythera',
    'East Myrtoon Pelagos',
    'West Myrtoon Pelagos',
    'South Myrtoon Pelagos',
    'Argolikos Kolpos',
    'Northern Saronikos',
    'East Saronikos',
    'West Saronikos',
    'South Saronikos',
    'South sea of Kyklades',
    'Central sea of Kyklades',
    'North Sea of Kyklades',
    'South Euvoikos Kolpos',
    'North Euvoikos Kolpos',
    'Euvoikon Pelagos',
    'Magnesiakos Kolpos',
    'North Thermaikos Kolpos',
    'South Thermaikos Kolpos',
    'Kolpos Kassandras',
    'Siggitikos Kolpos',
    'Sea of Sporadai',
    'Sea of Skyros',
    'Sea of Samothrake',
    'Sea of Samos',
    'Delta Eurou',
    'Sea of Lemnos',
    'Ellespontos',
    'South Propontis',
    'North Propontis',
    'Euxeinos Pontos',
    'Bay of Smyrne',
    'Ellatikos Kolpos',
    'Sea of Lesvos',
    'Voreion Mesopelagos',
    'South sea of Erythrai',
    'Samikon Pelagos',
    'Sea of Lykia',
    'Sea of Rhodes',
    'Outer sea of Karia',
    'Karpathian Sea',
    'Notion Mesopelagos',
    'Inner sea of Karia',
    'Sea of Ikaria',
    'Strymonikos Kolpos',
    'Sea of Thasos',
    'North sea of Erythrai',
    'North Myrtoon Pelagos',
    'Path to the edge of the world or whatever'
    }
    elseif loadnumber == 5 then
    list = { 
        'Housing', 
        'Bus Stop',
        'Moorfields Station',
        'James Street Station',
        'Liverpool Central Station',
        'Lime Street Station Platforms 1-6 (Regional)',
        'Edge Hill Station',
        'Lime Street Station Merseyrail Station'
        }
    

    elseif loadnumber == 6 then
    list = { 'Fire Nation Ship',
            'Fire Nation Airship',
            'Northern Water Tribe Ship',
            'Southern Water Tribe Ship',
            'Earth Kingdom Ship'
    }
    elseif loadnumber == 7 then
    list = { 
        'Pas de Calais',
"L'est de la Manche",
"l'ouest de la Manche",
'Baie de Seine',
'Baie de Lyme',
'Mer Celtique',
"Mer d'Armorica",
'Estuaire de la Gironde',
'Mer Cantabrique',
'Mer de Baléares',
'Golfe de Roses',
'Ouest du Golfe de Lion',
'Est du Golfe de Lion',
'Coût des étangs',
'Cap Toulon',
'Méditerranée occidentale',
'Méditerranée orientale',
'Côte dAzur',
'Côte Corse',
'Mer de Ligurie occidentale',
'Golfe de Gênes',
'Baie de Saint-Florent',
'Mer Tyrrhénienne',
'Le mer de Corse'

    }
    elseif loadnumber == 8 then

    list = { 
        'Bear Bay',
        'Bay of Ice',
        'Sea of Ice',
        'Northern Sunset Sea',
        'Sea Dragon Bay',
        'Stoney Bay',
        'Northern Fisher Waters',
        'Southern Fisher Waters',
        'Blazewater Rills',
        'Blazewater Bay',
        'Fever River',
        'The Neck Sunset Sea',
        'Sealskin Waters',
        'Northern Iron Route',
        'Southern Iron Route',
        'Iron Sunset Sea',
        'Lonely Waters',
        "Northern Ironman's Bay",
        "Eastern Ironman's Bay",
        "Southern Ironman's Bay",
        "Central Ironman's Bay",
        'Drowned Bay',
        'Harlaw Waters',
        'Mallister Ships',
        'Stonetree Waters',
        'Kenningport Waters',
        'Pyke Waters',
        'Pebbleton Strait',
        'Fair Bay',
        'Saltcliffe Waters',
        'Sunset Sea Westerlands',
        'Prester Waters',
        'Lannister Ships',
        'Crakehall Ships',
        "Lion's Bay",
        'Northern Shield Bay',
        'Sunset Shield Bay',
        'Southern Shield Bay',
        'Northern Redwyne Strait',
        'Redwyne Strait',
        'Hightower Bay',
        'Torentine Bay',
        'Arbor Deepwaters',
        'Southern Sunset Sea',
        'Western Summer Sea',
        'Eastern Summer Sea',
        'Elbow Waters',
        'Spice Ships',
        'Shores of Brimstone',
        'Salty Waters',
        'Saltstone Waters',
        'Shores of Sunspear',
        'Redstone Waters',
        'Summer Isles Route (Dorne)',
        'Summer Isles Route (Lys)',
        'Lysene Waters',
        'Lysene Deepwaters',
        'Lyson Waters',
        'Strait of Lys',
        'Bloody Shore',
        'Summer Sea Deepwaters',
        'Windward Shore',
        'Orange Coast',
        'Volant Waters',
        'Summer Waters',
        'Rhoyne Estuary',
        'Bay of Sighs',
        'Stepstones Deepwaters',
        'Stepstones Waterways',
        'Pirate Ships',
        'Eastern Sea of Dorne',
        'Western Sea of Dorne',
        'Ghaston Bay',
        'Cape Wrath Waters',
        'Strait of Estermont',
        'Sea of Myrth',
        'Tyrosh Waters',
        'Southern Shipbreaker Bay',
        'Northern Shipbreaker Bay',
        'Stormlands Narrow Sea',
        'Essosi Narrow Sea',
        'Crownlands Narrow Sea',
        'Andalos Narrow Sea',
        'Vale Narrow Sea',
        'Northern Narrow Sea',
        "Narrow's End",
        'Tyroshi Traders Route',
        'Myrish Traders Route',
        'Pentosi Traders Route',
        'Bay of Pentos',
        'The Gullet',
        'Blackwater Bay',
        'Northern Blackwater Bay',
        'The Tides',
        'Dragonstone Waters',
        'Crackclaw Waters',
        'South Andalos Coastwaters',
        'North Andalos Coastwaters',
        'Bay of Crabs',
        'Sea of Crabs',
        'Strait of Crabs',
        'Braavosian South Coast',
        'Braavosian North Coast',
        'Braavos Waters',
        'Pointy Waters',
        'Runestone Waters',
        'Sea of Lorath',
        'Strait of Lorath',
        'Lorath Bay',
        'Sealwaters',
        'Salt Cod Waters',
        'Wild Shivering Sea',
        'Leviathan Sea',
        'Leviathan Gulf',
        'Blue Whale Hunters',
        'Sarnori Fleet',
        'Axebay',
        'Bay of Horik',
        'The Fingers',
        'Shivering Bite',
        'Shivering Bay',
        'West Bite',
        'East Bite',
        'Pebble Bite',
        'Breakwater Bite',
        'Broken Branch Outlet',
        "Widow's Waters",
        'Weeping River Outlet',
        'Last River Outlet',
        'Southern Shivering Coast',
        'Northern Shivering Sea',
        'Grey Cliff Waters',
        'Strait of Seals',
        'Bay of Seals',
        'Sealstorm Currents',
        'Sealstorm Strait',
        'Whalespotters',
        'Wildling Ships',
        'Eastwatch Waters'        

    }
    elseif loadnumber == 9 then
    list = {

        'North Atlantic Current',
        'Norwegian Sea',
        'Dogger Bank',
        'Skaggerak',
        'Southern Baltic Sea',
        'Oresund',
        'Northern Baltic Sea',
        'Gulf of Finland and Bothnia',
        'Neva Estuary',
        'Wadden Sea',
        'Strait of Dover',
        'The Channel',
        'Celtic Sea',
        'Irish Sea',
        'Lusitanian Sea',
        'Bay of Biscay',
        'Strait of Gibraltar',
        'Gulf of Cadiz',
        'Barbary Coast',
        'Balearic Sea',
        'Ligurian Sea',
        'Tyrrhenian Sea',
        'Carthaginian Sea',
        'Gulf of Sidra',
        'Gulf of Venice',
        'Ionian Sea',
        'Nile Estuary',
        'Levantine Sea',
        'Gulf of Antalya',
        'Southern Aegean Sea',
        'Northern Aegean Sea',
        'Eastern Black Sea',
        'Western Black Sea',
        'Sea of Azov',
        'Caspian Sea',
        'Skagerrak'
    }
elseif loadnumber == 10 then
    list = {

        'Kvitøyrenna',
        'Wijdefjorden',
        'Kongsfjorden',
        'Isfjorden',
        'Van Mijenfjorden',
        'Sørkapp',
        'Storfjorden (Svalbard)',
        'Hinlopenstredet',
        'Eriksenstredet',
        'Olgastredet',
        'Jan Mayen-Svalbard route',
        'Jan Mayen sea',
        'Bjørnøya-Svalbard route',
        'Bjørnøya sea',
        'Nordkapp-Bjørnøya route',
        'Lofoten-Jan Mayen route',
        'Varangerfjorden',
        'Tanafjorden',
        'Porsangerfjorden',
        'Altafjorden',
        'Kvænangen',
        'Lyngen fjord',
        'Balsfjorden',
        'Andfjorden',
        'Vesterålsfjorden',
        'Lofothavet',
        'Røsthavet',
        'Ofotfjorden',
        'Vestfjorden',
        'Saltfjorden',
        'Ranfjorden',
        'Vefsnfjorden',
        'Bindalsfjorden',
        'Folda',
        'Frohavet',
        'Frøyhavet',
        'Tingvollfjorden',
        'Romsdalsfjorden',
        'Storfjorden (Møre)',
        'Nordfjorden',
        'Sognefjorden',
        'Osterfjorden',
        'Hardangerfjorden',
        'Boknafjorden',
        'Eigersundet',
        'Fedafjorden',
        'Østergapet',
        'Central Skagerrak',
        'Langesundbukta',
        'Outer Oslofjorden',
        'Inner Oslofjorden',
        'Trondheimsfjorden'
    }
    end

    return list
    
end

function Modloader(loadnumber)
    local list = {}

    if loadnumber > 0 then
        list[1] = 'C&PA'
        list[2] = 'C&PB'
        list[3] = 'C&PC'
        list[4] = 'C&PD'
        list[5] = 'C&PE'
        
    
    elseif loadnumber == 0 then 
        list[50] = 0
        loadnumber = 50 
    end 
        
    
    return list[loadnumber]
    
end