ESX = exports['es_extended']:getSharedObject()

function runCheck(obj, targetPropId, nearbyId, i)
    local canCarryIt = lib.callback.await('esx_illegal:canCarryItem', false, obj.giveItem, obj.giveAmount)
    local hasAllItems = lib.callback.await('esx_illegal:hasAllItems', false, obj.itemsRequired)
    local jobCount = lib.callback.await('esx_illegal:countJob', false, obj.jobCheck)

    if not jobCount then
        lib.notify({
            description = TranslateCap("jobCheck"),
            type = 'error',
            position = 'top',
            icon = 'ban'
        })
        return
    end
    
    if not hasAllItems then
        local itemLabelsAndCounts = {}

        for itemName, itemData in pairs(exports.ox_inventory:Items()) do
            for requiredItemName, requiredCount in pairs(obj.itemsRequired) do
                if itemData.name == requiredItemName then
                    itemLabelsAndCounts[requiredItemName] = {
                        label = itemData.label,
                        count = requiredCount
                    }
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
        return
    end

    if not canCarryIt then
        lib.notify({
            description = TranslateCap('full'),
            type = 'error',
            position = 'top',
            icon = 'ban'
        })
        return
    end

    if obj.takeItem then
        local canSwapIt = lib.callback.await('esx_illegal:canCarryItem', false, obj.takeItem, obj.takeAmount, obj.giveItem, obj.giveAmount)

        if canSwapIt then
            if obj.skillCheck then
                skillCheck(obj)
            else
                progBar(obj)
            end
        end
    else
        if obj.skillCheck then
            skillCheck(obj, targetPropId, nearbyId, i)
        else
            progBar(obj, targetPropId, nearbyId, i)
        end
    end
end

function progBar(obj, targetPropId, nearbyId, i)
    if lib.progressCircle({
        duration = obj.duration * 1000,
        label = obj.durationLabel,
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
            dict = obj.animDictionary,
            clip = obj.animClip
        },
    }) then
        if obj.takeItem then
            local itemTaken = lib.callback.await('esx_illegal:takeItem', false, obj)

            if itemTaken then
                TriggerServerEvent('esx_illegal:giveItem', obj)
            end
        else
            ESX.Game.DeleteObject(targetPropId)
            table.remove(spawnedProps[i], nearbyId)
            spawnedPropsCount[i] = 1
            TriggerServerEvent('esx_illegal:giveItem', obj)
        end
    else
        lib.notify({
            description = TranslateCap('canceled'),
            type = 'error',
            position = 'top',
            icon = 'ban'
        })
    end
end

function skillCheck(obj, targetPropId, nearbyId, i)
    local success = lib.skillCheck(obj.skillCheck)

    if success then
        progBar(obj, targetPropId, nearbyId, i)
    else
        lib.notify({
            description = TranslateCap('skillFail'),
            type = 'error',
            position = 'top',
            icon = 'ban'
        })
    end
end

function createBlip(coords, blipName, radius, color, sprite, radiusColor)
    if radiusColor then
	    local blip = AddBlipForRadius(coords.x, coords.y, coords.z, radius)
	    SetBlipHighDetail(blip, true)
	    SetBlipColour(blip, radiusColor)
	    SetBlipAlpha(blip, 128)
    end
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