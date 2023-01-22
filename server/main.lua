lib.callback.register('esx_illegal:canCarryItem', function(source, item, amount)
    
    if exports.ox_inventory:CanCarryItem(source, item, amount) then
        return 1
    else
        return 0
    end

end)

lib.callback.register('esx_illegal:canSwapItem', function(source, itemOne, itemOneAmount, itemTwo, itemTwoAmount)
    
    if exports.ox_inventory:CanSwapItem(source, itemOne, itemOneAmount, itemTwo, itemTwoAmount) then
        return 1
    else
        return 0
    end
    
end)

lib.callback.register('esx_illegal:hasAllItems', function(source, item)

    local allExist = true

    for itemName, requiredCount in pairs(item) do
        local count = exports.ox_inventory:GetItem(source, itemName, nil, true)
        if count < requiredCount then
            allExist = false
            break
        end
    end

    if allExist then
        return 1
    else
        return 0
    end

end)

RegisterServerEvent("esx_illegal:giveItem")
AddEventHandler("esx_illegal:giveItem", function(obj)

    local playerCoords  = GetEntityCoords(GetPlayerPed(source))
    local targetCoords
    local maxDistance

    if obj.coords then
        targetCoords = obj.coords
    else
        targetCoords = vec3(obj.target.x, obj.target.y, obj.target.z)
    end

    if obj.density then
        maxDistance = obj.density * 2 + 5
    else
        maxDistance = 2 * 2 + 5
    end

    local distance = #(playerCoords - targetCoords)
    
    if (distance <= maxDistance) then
        local success, response = exports.ox_inventory:AddItem(source, obj.giveItem, obj.giveAmount)
        if not success then
            print(response)
        end
    else
        print('ID: '.. source .. ' may have cheats.')
        print('Tried to get weed at Weed Field')
        print('His distance from Weed Field is: ' .. distance)

        --add your log system
    end

end)

lib.callback.register('esx_illegal:takeItem', function(source, obj)

    local success = exports.ox_inventory:RemoveItem(source, obj.takeItem, obj.takeAmount)

    return(success)

end)