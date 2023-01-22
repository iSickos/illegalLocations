ESX = exports['es_extended']:getSharedObject()

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
                    processItem(process)
                end
            }
        }
    })

end

function processItem(process)

    local canCarryIt    = lib.callback.await('esx_illegal:canCarryItem', false, process.giveItem, process.giveAmount)
    local canSwapIt     = lib.callback.await('esx_illegal:canCarryItem', false, process.takeItem, process.takeAmount, process.giveItem, process.giveAmount)
    local hasAllItems   = lib.callback.await('esx_illegal:hasAllItems', false, process.itemsRequired)
    
    if (hasAllItems == 1 and canCarryIt == 1 and canSwapIt == 1) then

        if process.skillCheck then

            local success = lib.skillCheck(process.skillCheck)

            if success then
                processCircle(process)
            else
                lib.notify({
                    description = TranslateCap('skillFail'),
                    type = 'error',
                    position = 'top',
                    icon = 'ban'
                })
            end

        else
            processCircle(process)
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
                for requiredItemName, requiredCount in pairs(process.itemsRequired) do
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

function processCircle(process)

    if lib.progressCircle({
        duration = process.processDuration * 1000,
        label = process.processingText,
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
            dict = process.animDictionary,
            clip = process.animClip
        },
    }) then

        local itemTaken = lib.callback.await('esx_illegal:takeItem', false, process)

        if itemTaken then
            TriggerServerEvent('esx_illegal:giveItem', process)
        end

    else
        lib.notify({
            description = TranslateCap('harvestCanceled'),
            type = 'error',
            position = 'top',
            icon = 'ban'
        })
    end

end
