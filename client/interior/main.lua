for i, interior in pairs(Config.interiors) do

    Citizen.CreateThread(function()
        if interior.blip then
            createBlip(interior.entranceCoords, interior.blipName, interior.spriteColor, interior.sprite)
        end
    end)

    --Entrance
    exports.ox_target:addBoxZone({
        coords = vec3(interior.entranceCoords.x, interior.entranceCoords.y, interior.entranceCoords.z),
        size = interior.entranceSize,
        rotation = interior.entranceCoords.h,
        debug = interior.entranceDebug,
        options = {
            {
                icon = 'fa-solid fa-door-open',
                label = TranslateCap('openNeNiuor') ,
                canInteract = function() return not IsPedInAnyVehicle(PlayerPedId(), false) end,
                onSelect = function()
                    SetEntityCoords(PlayerPedId(), interior.teleportTo.x, interior.teleportTo.y, interior.teleportTo.z, false, false, false, false)
                end
            }
        }
    })

    --Entrance
    exports.ox_target:addBoxZone({
        coords = vec3(interior.exitCoords.x, interior.exitCoords.y, interior.exitCoords.z),
        size = interior.exitSize,
        rotation = interior.exitCoords.h,
        debug = interior.exitDebug,
        options = {
            {
                icon = 'fa-solid fa-door-open',
                label = TranslateCap('openNeNiuor') ,
                canInteract = function() return not IsPedInAnyVehicle(PlayerPedId(), false) end,
                onSelect = function()
                    SetEntityCoords(PlayerPedId(), interior.teleportBack.x, interior.teleportBack.y, interior.teleportBack.z, false, false, false, false)
                end
            }
        }
    })


    
end

function createBlip(coords, blipName, color, sprite)
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