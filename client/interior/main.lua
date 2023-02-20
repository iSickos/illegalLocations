lib.locale()

for i, interior in pairs(Config.interiors) do
    if interior.blipOptions.blip then
        CreateThread(function()
            createBlip(interior.entranceCoords, interior.blipOptions.blipName, false, interior.blipOptions.spriteColor, interior.blipOptions.sprite, false)
        end)
    end
    
    --Entrance
    exports.ox_target:addBoxZone({
        coords = vec3(interior.entranceCoords.x, interior.entranceCoords.y, interior.entranceCoords.z),
        size = interior.entranceSize,
        rotation = interior.entranceCoords.h,
        debug = interior.entranceDebug,
        options = {
            {
                icon = 'fa-solid fa-door-open',
                label = locale('openNeNiuor') ,
                canInteract = function() return not IsPedInAnyVehicle(PlayerPedId(), false) end,
                onSelect = function()
                    SetEntityCoords(PlayerPedId(), interior.teleportTo.x, interior.teleportTo.y, interior.teleportTo.z, false, false, false, false)
                end
            }
        }
    })

    --Exit
    exports.ox_target:addBoxZone({
        coords = vec3(interior.exitCoords.x, interior.exitCoords.y, interior.exitCoords.z),
        size = interior.exitSize,
        rotation = interior.exitCoords.h,
        debug = interior.exitDebug,
        options = {
            {
                icon = 'fa-solid fa-door-open',
                label = locale('openNeNiuor') ,
                canInteract = function() return not IsPedInAnyVehicle(PlayerPedId(), false) end,
                onSelect = function()
                    SetEntityCoords(PlayerPedId(), interior.teleportBack.x, interior.teleportBack.y, interior.teleportBack.z, false, false, false, false)
                end
            }
        }
    })
end