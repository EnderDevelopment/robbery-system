local ESX = nil
local isRobbing = false
local robberyLocation = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, location in ipairs(Config.RobberyLocations) do
            local distance = #(playerCoords - location.coords)

            if distance < 2.0 then
                DrawText3D(location.coords.x, location.coords.y, location.coords.z + 1.0, 'Press E to rob')

                if IsControlJustReleased(0, 38) then
                    TriggerServerEvent('robberysystem:startRobbery', location.name)
                end
            end
        end
    end
end)

RegisterNetEvent('robberysystem:startRobberyClient')
AddEventHandler('robberysystem:startRobberyClient', function(location)
    isRobbing = true
    robberyLocation = location
    ESX.ShowNotification('Robbery started at ' .. location)

    Citizen.CreateThread(function()
        local robberyTime = Config.RobberyTime

        while robberyTime > 0 and isRobbing do
            Citizen.Wait(1000)
            robberyTime = robberyTime - 1
            ESX.ShowNotification('Time remaining: ' .. robberyTime .. ' seconds')
        end

        if isRobbing then
            TriggerServerEvent('robberysystem:endRobbery', robberyLocation, true)
            isRobbing = false
        end
    end)
end)

RegisterNetEvent('robberysystem:cancelRobbery')
AddEventHandler('robberysystem:cancelRobbery', function()
    isRobbing = false
    ESX.ShowNotification('Robbery cancelled')
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    local scale = (1 / dist) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end