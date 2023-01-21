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
                    canInteract = function()
                        if IsPedInAnyVehicle(PlayerPedId(), false) then
                            return false
                        else
                            return true
                        end
                    end,
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

    local canCarryIt = lib.callback.await('esx_illegal:canCarryItem', false, zone.item)
    local hasAllItems = lib.callback.await('esx_illegal:hasAllItems', false, zone.itemsRequired)

    if (hasAllItems == 1 and canCarryIt == 1) then

        if zone.skillCheck then

            local success = lib.skillCheck(zone.skillCheck)

            if success then
                progCircle(zone, targetPropId, nearbyId, i)
            else
                lib.notify({
                    description = zone.skillFailText,
                    type = 'error',
                    position = 'top',
                    icon = 'ban'
                })
            end

        else
            progCircle(zone, targetPropId, nearbyId, i)
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
            local itemNames = {}
            for item, data in pairs(exports.ox_inventory:Items()) do

                for i, v in ipairs(zone.itemsRequired) do
                    if data.name == zone.itemsRequired[i] then
                        itemNames[i] = data.label
                    end
                end

            end

            local itemList = ""
            for i, v in ipairs(itemNames) do
                if i < #itemNames then
                    itemList = itemList .. v .. ', '
                else
                    itemList = itemList .. v
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

function progCircle(zone, targetPropId, nearbyId, i)

    if lib.progressCircle({
        duration = zone.harvestDuration * 1000,
        label = zone.harvestingText,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
            mouse = false,
        },
        anim = {
            dict = 'amb@world_human_gardener_plant@female@exit',
            clip = 'exit_female'
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