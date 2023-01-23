for i, process in pairs(Config.process) do
    exports.ox_target:addBoxZone({
        coords = vec3(process.target.x, process.target.y, process.target.z),
        size = process.targetSize,
        rotation = process.target.h,
        debug = true,
        options = {
            {
                icon = process.targetIcon,
                label = process.targetLabel,
                canInteract = function() return not IsPedInAnyVehicle(PlayerPedId(), false) end,
                onSelect = function()
                    runCheck(process)
                end
            }
        }
    })
end