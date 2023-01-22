spawnedProps = {}
spawnedPropsCount = {}


for i, zone in pairs(Config.plantZones) do
    
    Citizen.CreateThread(function()
        if zone.blip then
            createBlip(zone.coords, zone.blipName, zone.density, zone.spriteColor, zone.sprite, zone.circleColor)
        end
    end)

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
                        itemCheck(zone, targetPropId, nearbyId, i)
                    end
                }
            }
    
            exports.ox_target:addLocalEntity(obj, options)

        end)

        spawnedPropsCount[i] += 1

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