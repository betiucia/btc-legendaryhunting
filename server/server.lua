local BtcCore = exports['btc-core']:GetCore()
local locale = Locale[Config.Locale]


----- Item Utilizavel
---

BtcCore.framework.createUseableItem(Config.MapItem, false, function(source, metadata)
    local src = source
    TriggerClientEvent('btc-legendaryhunting:client:usemap', src)
end)
---- Seta uma nova localização a cada RR

Citizen.CreateThread(function()
    -- Set initial position
    coords = Config.MissionNpcs.Locations[math.random(1, #Config.MissionNpcs.Locations)]
end)

RegisterNetEvent('btc-LegendaryHunting:server:getcoords', function()
    local src = source
    local npcoords = coords
    TriggerClientEvent('btc-legendaryhunting:client:createnpc', src, npcoords)
end)

RegisterNetEvent('btc-legendaryhunting:server:additem', function(animaltype)
    local src = source

    for k, v in pairs(Config.Animals) do
        if k == animaltype then
            local havespace = BtcCore.framework.canAddItem(src, v.item, 1)
            if havespace then
                BtcCore.framework.addItem(src, v.item, 1)
                TriggerEvent('btc-legendaryhunting:server:FinishMissionsendToDiscord', src, animaltype, v.item)
            else
                Notify(locale[43], 5000, "error", src)
            end
            break
        end
    end
end)

RegisterNetEvent('btc-legendaryhunting:server:sellitem', function(item)
    local src = source
    local SellItem = false

    if not Player then return end


    if SellItem == false then
        for k, v in pairs(Config.Animals) do
            if v.item == item then
                SellItem = true
                GiveItem = v.item
                if BtcCore.framework.removeItem(src, v.item, 1) then
                    BtcCore.framework.addMoney(src, 'cash', v.reward)
                    Notify(locale[44] .. v.reward, 5000, "success", src)
                    TriggerEvent('btc-legendaryhunting:server:SellsendToDiscord', src, v.item, v.reward)
                    break
                end
            end
        end
    else
        Notify(locale[45], 5000, "error", src)
    end

    if SellItem == true then
        Wait(10000)
        SellItem = false
    end
end)

local HuntAnimalCooldowns = {}
BtcCore.callback.register('btc-legendaryhunting:server:cooldownmission', function(source, cb, animalType)
    local src = source
    local cooldownTimer = Config.HuntingCooldown
    local shopid = 1
    local callback = true


    if not HuntAnimalCooldowns[animalType] then
        callback = true
        HuntAnimalCooldowns[animalType] = {}
    end

    if HuntAnimalCooldowns[animalType][shopid] then
        if os.difftime(os.time(), HuntAnimalCooldowns[animalType][shopid]) >= cooldownTimer then
            callback = true
        else
            callback = false
        end
    else
        callback = true
    end
    return cb(callback)
end)

BtcCore.callback.register('btc-legendaryhunting:server:getxp', function(source, cb)
    local src = source
    exports['btc-playerskills']:createskill(src, "hunting", locale[58], "legendaryhunting", locale[32], 0, 1, 5)
    Wait(500)
    local experience = exports['btc-playerskills']:getxp(src, "hunting", "legendaryhunting")
    return cb(experience)
end)



RegisterNetEvent('btc-legendaryhunting:server:givexp')
AddEventHandler('btc-legendaryhunting:server:givexp', function()
    local src = source
    exports['btc-playerskills']:addxp(src, "hunting", "legendaryhunting", Config.playerSkills.exp)
end)

RegisterNetEvent('btc-legendaryhunting:server:startcooldownmission', function(animalType)
    local src = source
    local cooldownTimer = Config.HuntingCooldown
    local animalHash = tonumber(Config.Animals[animalType].animalhash)
    local shopid = 1

    if not HuntAnimalCooldowns[animalType] then
        HuntAnimalCooldowns[animalType] = {}
    end

    if HuntAnimalCooldowns[animalType][shopid] then
        if os.difftime(os.time(), HuntAnimalCooldowns[animalType][shopid]) >= cooldownTimer then
            HuntAnimalCooldowns[animalType][shopid] = os.time()
            TriggerClientEvent('btc-legendaryhunting:client:startmission', src, animalType)
        else
            Notify(
            locale[46] ..
            os.difftime(os.time(), HuntAnimalCooldowns[animalType][shopid]) .. locale[47] .. cooldownTimer .. locale[48],
                5000, "error", src)
        end
    else
        HuntAnimalCooldowns[animalType][shopid] = os.time()
        TriggerClientEvent('btc-legendaryhunting:client:startmission', src, animalType)
    end
end)

RegisterNetEvent('btc-legendaryhunting:server:StartMissionsendToDiscord',
    function(discord, title, name, label, identifiers)
        local embed = {
            {
                ["color"] = 3037669,
                ["icon_url"] = Config.UrlIcon,
                ["title"] = "**" .. title .. "**",

                author = {
                    name = Config.ServerName,
                    icon_url = Config.UrlIcon,

                },

                thumbnail = {
                    url = Config.UrlIconThumb,
                },

                ["description"] = locale[49],

                fields = {
                    { name = locale[50], value = name,        inline = true },
                    { name = locale[51], value = identifiers, inline = true },
                    { name = locale[52], value = label,       inline = false },
                },

                ["footer"] = {
                    ["text"] = Config.ServerName,
                },
            }
        }

        PerformHttpRequest(discord, function(err, text, headers) end, 'POST',
            json.encode({ username = title, embeds = embed }),
            { ['Content-Type'] = 'application/json' })
    end)


RegisterNetEvent('btc-legendaryhunting:server:FinishMissionsendToDiscord', function(source, missionType, item)
    local src = source
    local firstname, lastname = BtcCore.framework.getName(src)
    local citizenid = BtcCore.framework.getCitizenID(src)
    local label = missionType
    local title = locale[53]

    local embed = {
        {
            ["color"] = 3037669,
            ["icon_url"] = Config.UrlIcon,
            ["title"] = locale[53],

            author = {
                name = Config.ServerName,
                icon_url = Config.UrlIcon,

            },

            thumbnail = {
                url = Config.UrlIconThumb,
            },

            fields = {
                { name = locale[50], value = firstname .. ' ' .. lastname, inline = true },
                { name = locale[51], value = citizenid,                    inline = true },
                { name = locale[52], value = label,                        inline = false },
                { name = locale[54], value = item,                         inline = false },

            },

            ["footer"] = {
                ["text"] = Config.ServerName,
            },
        }
    }

    PerformHttpRequest(Config.WebhookUrl, function(err, text, headers) end, 'POST',
        json.encode({ username = title, embeds = embed }),
        { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent('btc-legendaryhunting:server:SellsendToDiscord', function(source, item, reward)
    local src = source
    local firstname, lastname = BtcCore.framework.getName(src)
    local citizenid = BtcCore.framework.getCitizenID(src)
    local title = 'BTC-LegendaryHunting'
    local embed = {
        {
            ["color"] = 3037669,
            ["icon_url"] = Config.UrlIcon,
            ["title"] = locale[55],

            author = {
                name = Config.ServerName,
                icon_url = Config.UrlIcon,

            },

            thumbnail = {
                url = Config.UrlIconThumb,
            },

            ["description"] = locale[49],

            fields = {
                { name = locale[50], value = firstname .. ' ' .. lastname, inline = true },
                { name = locale[51], value = citizenid,                    inline = true },
                { name = locale[52], value = item,                         inline = false },
                { name = locale[54], value = reward,                       inline = false },

            },

            ["footer"] = {
                ["text"] = Config.ServerName,
            },
        }
    }

    PerformHttpRequest(Config.WebhookUrl, function(err, text, headers) end, 'POST',
        json.encode({ username = title, embeds = embed }),
        { ['Content-Type'] = 'application/json' })
end)
