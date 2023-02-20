lib.versionCheck('iSickos/esx_illegal')
if not lib.checkDependency('ox_lib', '0.0.1') then error("You need ox_lib for this resource to work") end
if not lib.checkDependency('ox_target', '0.0.1') then error("You need ox_target for this resource to work") end
if not lib.checkDependency('ox_inventory', '0.0.1') then error("You need ox_inventory for this resource to work") end

if Config.Framework == 'esx' then
    ESX = exports['es_extended']:getSharedObject()
end

lib.callback.register('illegalLocations:removeItem', function(source, obj)
    return exports.ox_inventory:RemoveItem(source, obj.takeItem, obj.takeAmount)
end)

lib.callback.register('illegalLocations:canCarryItem', function(source, item, amount)
    return exports.ox_inventory:CanCarryItem(source, item, amount)
end)

lib.callback.register('illegalLocations:canSwapItem', function(source, itemOne, itemOneAmount, itemTwo, itemTwoAmount)
    return exports.ox_inventory:CanSwapItem(source, itemOne, itemOneAmount, itemTwo, itemTwoAmount)
end)

lib.callback.register('illegalLocations:hasAllItems', function(source, itemList)
    local allExist = true

    for itemName, requiredCount in pairs(itemList) do
        local count = exports.ox_inventory:GetItem(source, itemName, nil, true)
        if count < requiredCount then
            allExist = false
            break
        end
    end

    return allExist
end)

lib.callback.register('illegalLocations:giveItem', function(source, obj)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
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
    return success
end)

lib.callback.register('illegalLocations:countJob', function(source, jobsObj)
    if Config.Framework == 'esx' then
        for jobName, reqCount in pairs(jobsObj) do
            if #ESX.GetExtendedPlayers("job", jobName) < reqCount then return false end
        end
    elseif Config.Framework == 'ox' then
        for jobName, reqCount in pairs(jobsObj) do
            if #Ox.GetPlayerByFilter({ group = jobName }) < reqCount then return false end
        end
    end
    
    return true
end)