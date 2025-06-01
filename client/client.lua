MenuData = {}
local BtcCore = exports['btc-core']:GetCore()
local huntingPed = nil
local spawnedPeds = {} -- Encontra os peds para limpar caso de ensure
local AnimalPrompt
local AnimalGroup = GetRandomIntInRange(0, 0xffffff)
local isAnimalPromptUsed = false
local DBD = {}
local locale = Locale[Config.Locale]

----- Prompt de pegar a cabeça do animal

function AnimalPrompt()
    Citizen.CreateThread(function()
        local str = "Esfolar"
        AnimalPrompt = Citizen.InvokeNative(0x04F97DE45A519419)
        PromptSetControlAction(AnimalPrompt, 0xF3830D8E)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(AnimalPrompt, str)
        PromptSetEnabled(AnimalPrompt, true)
        PromptSetVisible(AnimalPrompt, true)
        PromptSetHoldMode(AnimalPrompt, true)
        PromptSetGroup(AnimalPrompt, AnimalGroup)
        PromptRegisterEnd(AnimalPrompt)
    end)
end

Citizen.CreateThread(function()
    AnimalPrompt()
    local isLoggedIn = BtcCore.framework.isPlayerReady()
    if isLoggedIn then
        TriggerServerEvent('btc-LegendaryHunting:server:getcoords')
    end
    if Config.DevMode then
        TriggerServerEvent('btc-LegendaryHunting:server:getcoords')
    end
end)

--------------- Create NPCS

local function createNPC(model, coords, k)
    model = model
    coords = coords
    k = k
    local sleep = 500
    while true do
        local playerCoords = GetEntityCoords(PlayerPedId())
        local distance = #(playerCoords - coords.xyz)

        if distance < 50 and not spawnedPeds[k] then
            local spawnedPed = NearPed(model, coords)
            spawnedPeds[k] = { spawnedPed = spawnedPed }
        end

        if distance >= 50 and spawnedPeds[k] then
            if true then
                for i = 255, 0, -51 do
                    Wait(50)
                    SetEntityAlpha(spawnedPeds[k].spawnedPed, i, false)
                end
            end
            DeletePed(spawnedPeds[k].spawnedPed)
            spawnedPeds[k] = nil
        end
        Wait(sleep)
    end
end


function NearPed(npcmodel, npccoords)
    RequestModel(npcmodel)
    while not HasModelLoaded(npcmodel) do
        Wait(50)
    end
    spawnedPed = CreatePed(npcmodel, npccoords.x, npccoords.y, npccoords.z - 1.0, npccoords.w, false, false, 0, 0)
    SetEntityAlpha(spawnedPed, 0, false)
    SetRandomOutfitVariation(spawnedPed, true)
    SetEntityCanBeDamaged(spawnedPed, false)
    SetEntityInvincible(spawnedPed, true)
    FreezeEntityPosition(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    -- set relationship group between npc and player
    SetPedRelationshipGroupHash(spawnedPed, GetPedRelationshipGroupHash(spawnedPed))
    SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(spawnedPed), `PLAYER`)

    -- end of relationship group
    if true then
        for i = 0, 255, 51 do
            Citizen.Wait(50)
            SetEntityAlpha(spawnedPed, i, false)
        end
    end
    -- target end
    return spawnedPed
end

local function LegendaryMap(missiontype)
    local flowblockHash = -980176693
    local flowblockEnteringHash = -980176693
    local flowblock = UiflowblockRequest(flowblockHash)
    local statemachineHash = 978408792
    repeat Wait(0) until UiflowblockIsLoaded(flowblock) == 1
    UiflowblockEnter(flowblock, flowblockEnteringHash)
    if (UiStateMachineExists(statemachineHash) == 0) then
        UiStateMachineCreate(statemachineHash, flowblock)
    end
    if DBD and DBD.a then
        DatabindingRemoveDataEntry(DBD.a)
    end

    DBD = {}
    DBD.a = DatabindingAddDataContainerFromPath('', 'DynamicAnimalMap')

    for zoneIndex = 1, #Config.zones do
        local zoneKey = "Zone" .. zoneIndex
        local zoneStr = GetTextSubstring_2(zoneKey, GetLengthOfLiteralString(zoneKey))
        local zoneContainer = DatabindingAddDataContainer(DBD.a, zoneStr)
        DatabindingAddDataBool(zoneContainer, "isVisible", false) -- Marca como no visible
        DatabindingRemoveDataEntry(zoneContainer)                 -- Limpia la zona
        Wait(1)
    end

    local selectedZone = math.random(1, #Config.zones)
    local txt = 'Zone' .. selectedZone
    local str = GetTextSubstring_2(txt, GetLengthOfLiteralString(txt))
    local animalHash = Config.Animals[missiontype].animalhash

    DBD.b = DatabindingAddDataContainer(DBD.a, str)
    DBD.c = DatabindingAddDataHash(DBD.b, 'animalType', animalHash)
    DBD.d = DatabindingAddDataBool(DBD.b, 'isVisible', true)

    return selectedZone
end

RegisterNetEvent('btc-legendaryhunting:client:usemap', function()
    local playerPed = PlayerPedId()
    if InMission then
        TaskItemInteraction(playerPed, 17745825, 889797228, 1, 0, -1082130432)
    else
        Notify(locale[57], 5000, "error")
    end
end)

------ Função para o EagleEye

function EnableEagleeye(player, enable)
    Citizen.InvokeNative(0xA63FCAD3A6FEC6D2, player, enable)
end

--- Criar blip e NPC
RegisterNetEvent('btc-legendaryhunting:client:createnpc', function(npcoords)
    local coords = npcoords
    local model = Config.MissionNpcs.Model
    ------------- Criar Blip
    if Config.MissionNpcs.ShowBlip == true then
        HunterBlip = BlipAddForCoords(1664425300, coords.xyz)
        SetBlipSprite(HunterBlip, joaat(Config.MissionNpcs.Blip), true)
        SetBlipScale(HunterBlip, 0.8)
        SetBlipName(HunterBlip, locale[56])
    end

    --------------
    BtcCore.prompts.createPrompt('LegendaryHunting', coords.xyz, GetHashKey(Config.KeybindMenu),
        locale[1], {
            type = 'client',
            event = 'btc-legendaryhunting:client:openmenu',
            args = {},
        })

    if Config.UseItems then
        BtcCore.prompts.createPrompt('LegendaryHuntingSell', coords.xyz, GetHashKey(Config.KeybindSell),
            locale[2], {
                type = 'client',
                event = 'btc-legendaryhunting:client:sellitem',
                args = {},
            })
    end

    createNPC(model, coords, 'legendaryhunting')
end)

RegisterNetEvent('btc-legendaryhunting:client:sellitem', function()
    for k, v in pairs(Config.Animals) do
        local hasItem = BtcCore.framework.hasItem(v.item, 1)
        if hasItem then
            TriggerServerEvent('btc-legendaryhunting:server:sellitem', v.item)
            break
        end
    end
end)

local elements = {
    {
        label = locale[4],
        value = 'Bear',
        desc = locale[5],
    },

    {
        label = locale[6],
        value = 'Beaver',
        desc = locale[7],
    },

    {
        label = locale[8],
        value = 'Bison',
        desc = locale[9],
    },

    {
        label = locale[10],
        value = 'Alligator',
        desc = locale[11],
    },

    {
        label = locale[12],
        value = 'Moose',
        desc = locale[13],
    },

    {
        label = locale[14],
        value = 'Boar',
        desc = locale[15],
    },

    {
        label = locale[16],
        value = 'Wolf',
        desc = locale[17],
    },

    {
        label = locale[18],
        value = 'Fox',
        desc = locale[19],
    },

    {
        label = locale[20],
        value = 'Phanter',
        desc = locale[21],
    },
    {
        label = locale[22],
        value = 'Cougar',
        desc = locale[23],
    },
    {
        label = locale[24],
        value = 'Buck',
        desc = locale[25],
    },
    {
        label = locale[26],
        value = 'Elk',
        desc = locale[27],
    },
    {
        label = locale[28],
        value = 'Coyote',
        desc = locale[29],
    },
    {
        label = locale[30],
        value = 'Ram',
        desc = locale[31],
    },
}

function ApplyPosfx()
    AnimpostfxPlay("OJDominoBlur")
    AnimpostfxSetStrength("OJDominoBlur", 0.5)
end

local function openMenu()
    local missionData = {} -- Inicializa como uma tabela vazia (que será um array)
    local hasItem = BtcCore.framework.hasItem(Config.MapItem, 1)

    if not InMission then
        if hasItem then
            for k, v_config_animal in pairs(Config.Animals) do -- Renomeei 'v' para clareza
                local animalType = k
                -- Suponho que 'elements' é uma tabela que contém detalhes dos animais
                -- e que você quer filtrar 'elements' para encontrar o 'animalType' correspondente.
                -- Se 'elements' já é o Config.Animals[animalType], o loop interno pode ser desnecessário.
                -- Vou assumir que 'elements' é uma lista onde você procura 'animalType'.

                -- A chamada ao servidor parece ser para verificar cooldown,
                -- o 'animal' retornado aqui pode não ser o que você usa para os detalhes da NUI.
                local isAnimalAvailable = BtcCore.callback.triggerServerSync(
                    'btc-legendaryhunting:server:cooldownmission', animalType)

                if isAnimalAvailable then
                    -- Se 'elements' é uma lista de todos os animais e você precisa encontrar o 'animalType'
                    for _, animalDetail in pairs(elements) do                      -- Renomeei 'animal' para 'animalDetail' para evitar conflito
                        if animalDetail.value == animalType then                   -- Ou alguma outra forma de identificar o animal correto em 'elements'
                            local mission_lvl = Config.Animals[animalType].lvlNeed -- Pega o lvl da Config.Animals
                            local mission_value = animalDetail
                                .value                                             -- O 'value' para a NUI é o 'animalType' (k)
                            local mission_label = animalDetail.label               -- Pega o label da Config.Animals
                            local mission_desc = animalDetail.desc                 -- Pega a desc da Config.Animals

                            -- Cria uma nova tabela para a missão atual
                            local currentMission = {
                                label = mission_label,
                                value = mission_value,
                                desc = mission_desc,
                                level = mission_lvl -- Adiciona o nível
                            }

                            -- Adiciona a missão atual à lista missionData
                            table.insert(missionData, currentMission)

                            break -- Se encontrou o animal em 'elements', pode sair deste loop interno
                        end
                    end
                end
            end
        else
            Notify(locale[35], 5000, "error")
            return
        end
    else
        Notify(locale[34], 5000, "error")
        return
    end

    -- Após o loop, você enviaria missionData para a NUI:
    if #missionData > 0 then
        ApplyPosfx()

        SendNUIMessage({
            action = "showNUI",
            missions = missionData,
            useLevelSystem = Config.playerSkills.use -- Certifique-se que Config.UseLvl está definido (true/false)
        })
        SetNuiFocus(true, true)                      -- Não se esqueça de dar foco à NUI

        -- isNuiOpen = true -- Controle o estado da NUI
    else
        -- Lógica para quando não há missões disponíveis (ex: notificação)
        BtcCore.framework.notify("Nenhuma missão de caça lendária disponível no momento.", "inform")
    end
end

function FecharNuiCaca()
    SetNuiFocus(false, false)
    AnimpostfxStop("OJDominoBlur")
end

-- No callback "acceptMission" (se você tiver um no Lua para quando uma missão é aceita pela NUI):
RegisterNUICallback("acceptMission", function(data, cb)
    local missionValue = data.missionValue
        FecharNuiCaca()
    cb({ status = "ok" })

    if Config.playerSkills.use then
        local skilldata = BtcCore.callback.triggerServerSync('btc-legendaryhunting:server:getxp')
        local lvl = skilldata.lvl
        local lvlMin = Config.Animals[data.missionValue].lvlNeed
        if lvl < lvlMin then
            Notify(locale[59], 5000, "error")
            return
        end
    end

        TriggerServerEvent('btc-legendaryhunting:server:startcooldownmission', missionValue)
end)

RegisterNUICallback("closeNui", function(data, cb)
    FecharNuiCaca()
    cb({ status = "ok" })
end)

if Config.DevMode then
    RegisterCommand('lendaria', function()
        openMenu()
    end)
end

---- Menu
RegisterNetEvent('btc-legendaryhunting:client:openmenu', function()
    openMenu()
end)

RegisterNetEvent('btc-legendaryhunting:client:startmission', function(missiontype)
    InMission = true
    local selectedZone = LegendaryMap(missiontype)
    local player = PlayerPedId()
    local npcmodel = missiontype
    local coords = Config.zones[selectedZone].coords[math.random(1, #Config.zones[selectedZone].coords)]
    local firstname, lastname = BtcCore.framework.getName()
    local citizenid = BtcCore.framework.getCitizenId()
    local name = firstname .. ' ' .. lastname
    Notify(locale[36], 5000, "success")
    TriggerServerEvent('btc-legendaryhunting:server:StartMissionsendToDiscord', Config.WebhookUrl, 'Iniciou a missão',
        name, npcmodel, citizenid)

    local fakecoords = vector3(coords.x + math.random(20, 80), coords.y + math.random(20, 80), coords.z)
    ----- Ciar GPS and Local Blip
    if Config.LocationBlip then
        ClearGpsMultiRoute()
        StartGpsMultiRoute(GetHashKey('COLOR_YELLOW'), true, true)
        AddPointToGpsMultiRoute(fakecoords)
        SetGpsMultiRouteRender(true, 8, 8)
        missionblip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, fakecoords, 500.0)
        BlipAddModifier(missionblip, GetHashKey('BLIP_MODIFIER_AREA_PULSE'))
    end

    ---------- Indo para o local
    while true do
        Wait(50)
        local playerCoords = GetEntityCoords(player)
        local distance = #(playerCoords - coords.xyz)
        if distance < 150 and Config.LocationBlip then
            RemoveBlip(missionblip)
            SetGpsMultiRouteRender(false, 8, 8)
            ClearGpsCustomRoute()
            break
        end

        if distance < 150 and not Config.LocationBlip then
            break
        end

        if IsEntityDead(player) then
            RemoveBlip(missionblip)
            SetGpsMultiRouteRender(false, 8, 8)
            ClearGpsCustomRoute()
            InMission = false
            Notify(locale[37], 5000, "error")
            return
        end
    end

    ----------------- Spawn do animal

    for k, v in pairs(Config.Animals) do
        if v.model == Config.Animals[npcmodel].model then
            model = joaat(v.model)
        end
    end
    if model == nil then return end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end

    if npcmodel == 'Moose' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 6, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    elseif npcmodel == 'Bear' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 2, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    elseif npcmodel == 'Fox' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 3, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    elseif npcmodel == 'Phanter' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 2, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    elseif npcmodel == 'Cougar' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 4, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    elseif npcmodel == 'Buck' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 6, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    elseif npcmodel == 'Elk' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 4, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    elseif npcmodel == 'Coyote' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 4, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    elseif npcmodel == 'Ram' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 5, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    elseif npcmodel == 'Boar' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 5, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    elseif npcmodel == 'Wolf' then
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 5, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    else
        npc = CreatePed(model, coords, true, true, 0, 0)
        Citizen.InvokeNative(0x283978A15512B2FE, npc, true)
        Citizen.InvokeNative(0x77FF8D35EEC6BBC4, npc, 2, 1) -- ID 1 como exemplo
        SetPedCombatAbility(npc, 2)
        -- TaskCombatPed(npc, PlayerPedId())
        SetEntityHealth(npc, Config.Animals[npcmodel].health, 0)
    end

    if Config.EnableEagleeye then
        EnableEagleeye(PlayerId(), true)
        Notify(locale[38], 5000, "success")
    else
        Notify(locale[39], 5000, "success")
    end

    while true do
        Wait(10)
        local playerCoords = GetEntityCoords(player)
        local animalCoords = GetEntityCoords(npc)
        local distance = #(playerCoords - animalCoords)

        if distance < 50 and not Config.LocationBlip then
            Notify(locale[40], 5000, "success")
            break
        end

        if distance < 50 and Config.LocationBlip then
            Notify(locale[40], 5000, "success")
            Citizen.InvokeNative(0x23f74c2fda6e7c61, 953018525, npc) -- Cria Blip no NPC
            break
        end

        if IsEntityDead(player) then
            InMission = false
            EnableEagleeye(PlayerId(), false)
            Notify(locale[37], 5000, "success")
            return
        end
    end

    while true do
        Wait(1)
        local anim1 = `WORLD_HUMAN_CROUCH_INSPECT`
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local animalCoords = GetEntityCoords(npc)
        local distance = #(pedCoords - animalCoords)

        if IsEntityDead(npc) then
            TriggerServerEvent('btc-legendaryhunting:server:givexp')
            if Config.UseItems then
                InMission = false
                EnableEagleeye(PlayerId(), false)
                if distance <= 2 then
                    local animal = CreateVarString(10, 'LITERAL_STRING', 'Retire a pele')
                    PromptSetActiveGroupThisFrame(AnimalGroup, animal)
                    if PromptHasHoldModeCompleted(AnimalPrompt) and isAnimalPromptUsed == false then
                        isAnimalPromptUsed = true
                        TaskStartScenarioInPlace(ped, anim1, 0, true)
                        TriggerServerEvent('btc-legendaryhunting:server:additem', npcmodel)
                        Wait(5000)
                        ClearPedTasks(ped)
                        DeletePed(npc)
                        Notify(locale[41], 5000, "success")
                        isAnimalPromptUsed = false
                        break
                    end
                end
            else
                InMission = false
                EnableEagleeye(PlayerId(), false)
                break
            end
        end

        if distance > Config.DistanceFailed then
            InMission = false
            Notify(locale[42], 5000, "error")
            DeletePed(npc)
            EnableEagleeye(PlayerId(), false)
            break
        end

        if IsEntityDead(player) then
            InMission = false
            Notify(locale[37], 5000, "error")
            Wait(60000)
            DeletePed(npc)
            EnableEagleeye(PlayerId(), false)
            break
        end
    end
end)


-- cleanup
AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end

    BtcCore.prompts.deletePrompt('LegendaryHunting')
    RemoveBlip(HunterBlip)

    if Config.UseItems then
        BtcCore.prompts.deletePrompt('LegendaryHuntingSell')
    end
    for k, v in pairs(spawnedPeds) do
        DeletePed(spawnedPeds[k].spawnedPed)
        spawnedPeds[k] = nil
    end
end)
