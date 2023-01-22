ESX = exports['es_extended']:getSharedObject()

local spawnedProps = {}
local spawnedPropsCount = {}

Citizen.CreateThread(function()
	for i, zone in pairs(Config.plantZones) do
        if zone.blip then
            createBlipCircle(zone.coords, zone.blipName, zone.density, zone.spriteColor, zone.sprite, zone.circleColor)
        end

        spawnedProps[i] = {}
        spawnedPropsCount[i] = 0

        Citizen.CreateThread(function()
    
            while true do
        
                Wait(1000)
                local playerCoords = GetEntityCoords(PlayerPedId())
                local targetCoords = vector3(zone.coords)
                
                local distance = #(playerCoords - targetCoords)
        
                if (distance < zone.density * 2) then
                    spawnPlants(zone, i)
                else
                    Wait(500)
                end
        
            end
        
        end)
        
	end

end)

function spawnPlants(zone, i)

    while (spawnedPropsCount[i] < zone.maxPropCount) do

        if (zone.growTime) then
            Wait(zone.growTime * 1000)
        else
            Wait(0)
        end

        local plantCoords = generatePlantCoords(zone)

        ESX.Game.SpawnLocalObject(zone.plantProp, plantCoords, function(obj)
            Wait(100)
            PlaceObjectOnGroundProperly(obj)
            FreezeEntityPosition(obj, true)
            table.insert(spawnedProps[i], obj)

            local options = {
                {
                    icon = zone.icon,
                    label = zone.harvestText,
                    canInteract = function() return not IsPedInAnyVehicle(PlayerPedId(), false) end,
                    onSelect = function(data)
                        local nearbyId
                        for j = 1, #spawnedProps[i], 1 do
                            if data.entity == spawnedProps[i][j] then
                                nearbyId = j
                            end
                        end
                        local targetPropId = data.entity
                        pickUpItem(zone, targetPropId, nearbyId, i)
                    end
                }
            }
    
            exports.ox_target:addLocalEntity(obj, options)

        end)

        spawnedPropsCount[i] += 1

    end

end

function pickUpItem(zone, targetPropId, nearbyId, i)

    local canCarryIt = lib.callback.await('esx_illegal:canCarryItem', false, zone.giveItem, zone.giveAmount)
    local hasAllItems = lib.callback.await('esx_illegal:hasAllItems', false, zone.itemsRequired)

    if (hasAllItems == 1 and canCarryIt == 1) then

        if zone.skillCheck then

            local success = lib.skillCheck(zone.skillCheck)

            if success then
                plantCircle(zone, targetPropId, nearbyId, i)
            else
                lib.notify({
                    description = TranslateCap('skillFail'),
                    type = 'error',
                    position = 'top',
                    icon = 'ban'
                })
            end

        else
            plantCircle(zone, targetPropId, nearbyId, i)
        end
        
    else

        if (hasAllItems == 1) then
            lib.notify({
                description = TranslateCap('full'),
                type = 'error',
                position = 'top',
                icon = 'ban'
            })
        else

            local itemLabelsAndCounts = {}
            for itemName, itemData in pairs(exports.ox_inventory:Items()) do
                for requiredItemName, requiredCount in pairs(zone.itemsRequired) do
                    if itemData.name == requiredItemName then
                        itemLabelsAndCounts[requiredItemName] = { label = itemData.label, count = requiredCount }
                    end
                end
            end

            local itemList = ""
            for itemName, itemData in pairs(itemLabelsAndCounts) do
                itemList = itemList .. itemData.label .. ": " .. itemData.count
                if next(itemLabelsAndCounts, itemName) ~= nil then
                    itemList = itemList .. ", "
                end
            end

            lib.notify({
                description = TranslateCap("noItems") .. itemList,
                type = 'error',
                position = 'top',
                icon = 'ban'
            })
        end

    end

end

function plantCircle(zone, targetPropId, nearbyId, i)

    if lib.progressCircle({
        duration = zone.harvestDuration * 1000,
        label = zone.harvestingText,
        position = 'middle',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = false,
        },
        anim = {
            dict = zone.animDictionary,
            clip = zone.animClip
        },
    }) then
        ESX.Game.DeleteObject(targetPropId)
        table.remove(spawnedProps[i], nearbyId)
        spawnedPropsCount[i] -= 1

        TriggerServerEvent('esx_illegal:giveItem', zone)
    else
        lib.notify({
            description = TranslateCap('harvestCanceled'),
            type = 'error',
            position = 'top',
            icon = 'ban'
        })
    end

end

function generatePlantCoords(zone)
    while true do

        Wait(100)

        math.randomseed(GetGameTimer())
        local modX = math.random(-zone.density, zone.density)
        Wait(100)

        math.randomseed(GetGameTimer())
        local modY = math.random(-zone.density, zone.density)


        local plantCoordX = zone.coords.x + modX
        local plantCoordY = zone.coords.y + modY

        --Find Ground
        local groundCheckHeights = {
            zone.coords.z - 10,
            zone.coords.z - 9,
            zone.coords.z - 8,
            zone.coords.z - 7,
            zone.coords.z - 6,
            zone.coords.z - 5,
            zone.coords.z - 4,
            zone.coords.z - 3,
            zone.coords.z - 2,
            zone.coords.z - 1,
            zone.coords.z,
            zone.coords.z + 1,
            zone.coords.z + 2,
            zone.coords.z + 3,
            zone.coords.z + 4,
            zone.coords.z + 5,
            zone.coords.z + 6,
            zone.coords.z + 7,
            zone.coords.z + 8,
            zone.coords.z + 9,
            zone.coords.z + 10
        }

        local ground, plantCoordZ
        for i, height in ipairs(groundCheckHeights) do
            ground, plantCoordZ = GetGroundZFor_3dCoord(plantCoordX, plantCoordY, height)

            if ground then
                break;
            end

        end

        local generatedCoords = vector3(plantCoordX, plantCoordY, plantCoordZ)

        return generatedCoords

    end

end

AddEventHandler('onResourceStop', function(resource)

    if resource == GetCurrentResourceName() then

        for i, zone in pairs(Config.plantZones) do
            for j, v in pairs(spawnedProps[i]) do
                ESX.Game.DeleteObject(v)
            end
        end
    end

end)

function createBlipCircle(coords, blipName, radius, color, sprite, radiusColor)
	local blip = AddBlipForRadius(coords.x, coords.y, coords.z, radius)
	SetBlipHighDetail(blip, true)
	SetBlipColour(blip, radiusColor)
	SetBlipAlpha(blip, 128)

	blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipHighDetail(blip, true)
	SetBlipSprite (blip, sprite)
	SetBlipScale  (blip, 1.0)
	SetBlipColour (blip, color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(blipName)
	EndTextCommandSetBlipName(blip)
end