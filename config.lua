Config = {}

---------------------------------
-- Webhook
---------------------------------
Config.ServerName = 'BTC - Legendary Hunting'
Config.UrlIcon = 'https://i.imgur.com/NWr0YFA.png'
Config.UrlIconThumb = 'https://i.imgur.com/NWr0YFA.png'
Config.WebhookColor = 3037669 -- Decimal Color
Config.WebhookUrl = ''

------- Geral
Config.DevMode = true
Config.Locale = 'pt-br'
Config.KeybindMenu = 'INPUT_CREATOR_ACCEPT'         -- Botão para abrir o menu
Config.KeybindSell = 'INPUT_OPEN_JOURNAL'           -- Botão para entregar cabeça dos animais
Config.LocationBlip = false
Config.EnableEagleeye = true                        -- Só funciona quando a pessoa está próxima o suficiente do animal
Config.MapItem = 'legendarymap'
Config.HuntingCooldown = 7200                       -- Segundos
Config.DistanceFailed = 200                         -- Distancia do animal para falhar a missão
Config.UseItems = true                             -- Se true o animal irá dropar item e o colecionador irá comprar(valor em reward) -- se false você pode esfolar o animal
Config.PriceMultiplier = math.random(80, 102) / 100 -- Multiplicador de preço -- se UseItems = true

Config.MissionNpcs = {
    Model = 'cs_mp_gus_macmillan',
    Blip = 1735233562,
    ShowBlip = true,
    Locations = {
        vector4(515.11, 566.97, 110.22, 96.75),
        vector4(-1818.23, -372.48, 163.31, 6.07),
        vector4(-5426.84, -2915.83, 1.68, 262.59),
        vector4(-1440.21, -2276.72, 43.47, 154.21),
        vector4(2536.29, 774.48, 76.13, 3.44),
        vector4(-249.65, 959.44, 138.65, 251.99),
        vector4(-1503.96, -791.84, 104.43, 223.36),

    },
}

Config.Animals = {
    Bear = {
        model = 'A_C_Bear_01',
        lvlNeed = 5, -- LvL que o jogador precisa ter para pegar essa missão ( Precisa do Btc-PlayerSkills)
        health = 1200,
        item = 'bearskin',
        reward = 60 * Config.PriceMultiplier,
        animalhash = -1005924273
    },
    Beaver = {
        model = 'mp_a_c_beaver_01',
        health = 500,
        lvlNeed = 1,
        item = 'beaverskin',
        reward = 40 * Config.PriceMultiplier,
        animalhash = -617397357,
    },
    Bison = {
        model = 'a_c_buffalo_tatanka_01',
        health = 1100,
        lvlNeed = 2,
        item = 'buffaloskin',
        reward = 40 * Config.PriceMultiplier,
        animalhash = -1753771781,
    },
    Alligator = {
        model = 'a_c_alligator_02',
        health = 2000,
        lvlNeed = 5,
        item = 'alligatorskin',
        reward = 60 * Config.PriceMultiplier,
        animalhash = -768169834,
    },
    Moose = {
        model = 'A_C_Moose_01',
        health = 2150,
        lvlNeed = 3,
        item = 'mooseskin',
        reward = 40 * Config.PriceMultiplier,
        animalhash = -4270809,
    },
    Boar = {
        model = 'mp_a_c_boar_01',
        health = 1800,
        lvlNeed = 4,
        item = 'boarskin',
        reward = 60 * Config.PriceMultiplier,
        animalhash = 2046336256,
    },
    Wolf = {
        model = 'MP_A_C_Wolf_01',
        health = 1100,
        lvlNeed = 4,
        item = 'wolfskin',
        reward = 60 * Config.PriceMultiplier,
        animalhash = -888046168,
    },
    Fox = {
        model = 'A_C_Fox_01',
        health = 900,
        lvlNeed = 2,
        item = 'foxskin',
        reward = 40 * Config.PriceMultiplier,
        animalhash = 1520433456,
    },
    Phanter = {
        model = 'A_C_Panther_01',
        health = 1500,
        lvlNeed = 5,
        item = 'phanterskin',
        reward = 60 * Config.PriceMultiplier,
        animalhash = 2073533311
    },

    ------ NEWS

    Cougar = {
        model = 'mp_a_c_cougar_01',
        health = 1500,
        lvlNeed = 4,
        item = 'cougarskin',
        reward = 60 * Config.PriceMultiplier,
        animalhash = -1632720801
    },
    Buck = {
        model = 'mp_a_c_buck_01',
        health = 1100,
        lvlNeed = 3,
        item = 'buckskin',
        reward = 40 * Config.PriceMultiplier,
        animalhash = -110898462
    },
    Elk = {
        model = 'mp_a_c_elk_01',
        health = 1800,
        lvlNeed = 3, 
        item = 'elkskin',
        reward = 40 * Config.PriceMultiplier,
        animalhash = -1165067836
    },
    Coyote = {
        model = 'mp_a_c_coyote_01',
        health = 1000,
        lvlNeed = 2,
        item = 'coyoteskin',
        reward = 40 * Config.PriceMultiplier,
        animalhash = 1950895318
    },
    Ram = {
        model = 'mp_a_c_bighornram_01',
        health = 2500,
        lvlNeed = 2,
        item = 'ramskin',
        reward = 40 * Config.PriceMultiplier,
        animalhash = -1077605376
    },

}

Config.playerSkills = {
    use = true, -- You need Btc-playerskills
    exp = 15, -- quanto de XP ganha por caçar um animal -- LVL MAXIMO É 5
}

Config.zones = {
    {
        zone = 1,
        coords = {
            vector4(-6144.56, -3667.35, 22.36, 0.1), --- DON'T TOUCH!
            ---Adicione mais porém proximo a primeira coordenada
            -- vector4(-6046.25, -3616.48, -1.55, 258.49),
            -- vector4(-6070.75, -3462.53, 13.26, 325.50),
            -- vector4(-6097.19, -3375.83, 22.82, 77.22),
        }
    },
    -- {
    --     zone = 2,
    --     coords = {
    --         vector4(-4796.84, -2397.45, 7.83, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 3,
    --     coords = {
    --         vector4(-4013.84, -3518.40, 47.19, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 4,
    --     coords = {
    --         vector4(-2882.20, -2387.66, 72.24, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 5,
    --     coords = {
    --         vector4(-2039.58, -2785.12, 69.11, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 6,
    --     coords = {
    --         vector4(-2682.72, -1472.06, 147.18, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 7,
    --     coords = {
    --         vector4(-1083.08, -1710.34, 75.03, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 8,
    --     coords = {
    --         vector4(-2654.31, -439.72, 159.84, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 9,
    --     coords = {
    --         vector4(-1830.47, -1120.46, 88.31, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 10,
    --     coords = {
    --         vector4(52.39, -500.69, 60.62, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 11,
    --     coords = {
    --         vector4(-2358.97, 333.03, 215.72, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 12,
    --     coords = {
    --         vector4(-1433.82, 144.25, 90.32, 210.32), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 13,
    --     coords = {
    --         vector4(-1897.03, 1701.23, 251.41, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 14,
    --     coords = {
    --         vector4(-1374.61, 2219.60, 316.39, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 15,
    --     coords = {
    --         vector4(-967.44, 1626.29, 247.27, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 16,
    --     coords = {
    --         vector4(810.68, 1495.87, 206.15, 37.36), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 17,
    --     coords = {
    --         vector4(1499.16, 2070.64, 296.51, 261.56), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 18,
    --     coords = {
    --         vector4(2394.88, 2019.12, 171.72, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 19,
    --     coords = {
    --         vector4(280.16, 1295.55, 198.09, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 20,
    --     coords = {
    --         vector4(1591.66, 1099.64, 186.21, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 21,
    --     coords = {
    --         vector4(299.49, 67.15, 104.09, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 22,
    --     coords = {
    --         vector4(2296.96, 512.78, 83.90, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 23,
    --     coords = {
    --         vector4(2619.66, 214.58, 63.16, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 24,
    --     coords = {
    --         vector4(892.76, -1241.87, 55.24, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 25,
    --     coords = {
    --         vector4(1755.00, -533.91, 44.65, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 26,
    --     coords = {
    --         vector4(2331.92, -805.24, 41.07, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 27,
    --     coords = {
    --         vector4(1225.64, -2208.79, 52.74, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
    -- {
    --     zone = 28,
    --     coords = {
    --         vector4(1950.99, -1675.86, 42.26, 0.1), --- DON'T TOUCH!
    --         ---Adicione mais porém proximo a primeira coordenada
    --     },
    -- },
}

---- Notificações

local isServerSide = IsDuplicityVersion()
function Notify(message, timer, type, source) -- translateNumber é o número da tradução conforme o Config.Translate
    if timer then
        timer = timer
    else
        timer = 5000
    end

    if isServerSide then
        TriggerClientEvent('ox_lib:notify', source, { title = message, type = type, duration = timer })
    else
        TriggerEvent('ox_lib:notify', { title = message, type = type, duration = timer })
    end
end
