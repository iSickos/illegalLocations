lib.callback.register('esx_illegal:canCarryItem', function(source, item)
    
    if exports.ox_inventory:CanCarryItem(source, item, 1) then
        return 1
    else
        return 0
    end

end)

lib.callback.register('esx_illegal:hasAllItems', function(source, item)

    local allExist = true

    for i, v in ipairs(item) do
        local count = exports.ox_inventory:GetItem(source, v, nil, true)
        if count == 0 then
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
AddEventHandler("esx_illegal:giveItem", function(zone)

    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local targetCoords = zone.coords
    local maxDistance = zone.density * 2 + 5
    local distance = #(playerCoords - targetCoords)

    if (distance <= maxDistance) then
        local success, response = exports.ox_inventory:AddItem(source, zone.item, zone.harvestAmount)
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