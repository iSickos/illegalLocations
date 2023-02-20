spawnedProps = {}
spawnedPropsCount = {}

for i, zone in pairs(Config.plantZones) do
    CreateThread(function()
        if zone.blipOptions.blip then
            createBlip(zone.coords, zone.blipOptions.blipName, zone.density, zone.blipOptions.spriteColor, zone.blipOptions.sprite, zone.blipOptions.circleColor)
        end
    end)

    spawnedProps[i] = {}
    spawnedPropsCount[i] = 0

    local plantZone = lib.points.new(zone.coords, zone.density * 2, {zone = zone, index = i})
    
    function plantZone:onExit()
        -- Maybe remove all plants idk could be a feature
        print('left the zone')
    end

    function plantZone:nearby()
        spawnPlants(self.zone, self.index)
    end
end

function spawnPlants(zone, i)
    while spawnedPropsCount[i] < zone.maxPlantCount do
        if zone.growTime then
            Wait(zone.growTime * 1000)
        else
            Wait(0)
        end

        local plantCoords = generatePlantCoords(zone)

        local plant = CreateObject(zone.plantProp, plantCoords.x, plantCoords.y, plantCoords.z, false, false, false)
        Wait(100)
        PlaceObjectOnGroundProperly(plant)
        FreezeEntityPosition(plant, true)
        table.insert(spawnedProps[i], plant)

        local options = {
            {
                icon = zone.icon,
                label = zone.harvestText,
                canInteract = function()
                    return not IsPedInAnyVehicle(PlayerPedId(), false)
                end,
                onSelect = function(data)
                    local nearbyId

                    for j = 1, #spawnedProps[i] do
                        if data.entity == spawnedProps[i][j] then
                            nearbyId = j
                        end
                    end

                    local targetPropId = data.entity
                    runCheck(zone, targetPropId, nearbyId, i)
                end
            }
        }
        exports.ox_target:addLocalEntity(plant, options)

        spawnedPropsCount[i] += 1
    end
end

function generatePlantCoords(zone)
    Wait(100)

    math.randomseed(GetGameTimer())
    local modX = math.random(-zone.density, zone.density)
    Wait(100)

    math.randomseed(GetGameTimer())
    local modY = math.random(-zone.density, zone.density)

    local plantCoordX = zone.coords.x + modX
    local plantCoordY = zone.coords.y + modY

    -- Find Ground
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
        if ground then break end
    end

    local generatedCoords = vector3(plantCoordX, plantCoordY, plantCoordZ)

    return generatedCoords
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for i, zone in pairs(Config.plantZones) do
            for j, v in pairs(spawnedProps[i]) do
                DeleteObject(v)
            end
        end
    end
end)