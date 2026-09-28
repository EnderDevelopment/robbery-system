local ESX = nil
local activeRobberies = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('robberysystem:checkCooldown', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.identifier

    MySQL.Async.fetchScalar('SELECT cooldown_end FROM robbery_cooldowns WHERE player_id = @player_id', {
        ['@player_id'] = playerId
    }, function(cooldownEnd)
        if cooldownEnd then
            local currentTime = os.time()
            local cooldownTime = os.time(cooldownEnd)

            if currentTime < cooldownTime then
                cb(false, 'You are on cooldown. Time remaining: ' .. (cooldownTime - currentTime) .. ' seconds')
            else
                cb(true)
            end
        else
            cb(true)
        end
    end)
end)

RegisterServerEvent('robberysystem:startRobbery')
AddEventHandler('robberysystem:startRobbery', function(location)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.identifier

    ESX.TriggerServerCallback('robberysystem:checkCooldown', source, function(canRob)
        if canRob then
            activeRobberies[playerId] = {
                location = location,
                startTime = os.time()
            }

            TriggerClientEvent('robberysystem:startRobberyClient', source, location)

            -- Police alert logic
            local xPlayers = ESX.GetPlayers()
            local policeCount = 0

            for _, playerId in ipairs(xPlayers) do
                local xPlayer = ESX.GetPlayerFromId(playerId)
                if xPlayer.job.name == 'police' then
                    policeCount = policeCount + 1
                end
            end

            if policeCount >= Config.RobberyPoliceAlert then
                TriggerClientEvent('robberysystem:cancelRobbery', source)
                activeRobberies[playerId] = nil

                local cooldownEnd = os.time() + Config.RobberyCooldown
                MySQL.Async.execute('INSERT INTO robbery_cooldowns (player_id, cooldown_end) VALUES (@player_id, FROM_UNIXTIME(@cooldown_end))', {
                    ['@player_id'] = playerId,
                    ['@cooldown_end'] = cooldownEnd
                })

                MySQL.Async.execute('INSERT INTO robberies (player_id, location, start_time, end_time, success, reward) VALUES (@player_id, @location, FROM_UNIXTIME(@start_time), FROM_UNIXTIME(@end_time), @success, @reward)', {
                    ['@player_id'] = playerId,
                    ['@location'] = location,
                    ['@start_time'] = os.time(),
                    ['@end_time'] = os.time(),
                    ['@success'] = false,
                    ['@reward'] = 0
                })
            end
        else
            TriggerClientEvent('esx:showNotification', source, 'You are on cooldown')
        end
    end)
end)

RegisterServerEvent('robberysystem:endRobbery')
AddEventHandler('robberysystem:endRobbery', function(location, success)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerId = xPlayer.identifier

    if activeRobberies[playerId] and activeRobberies[playerId].location == location then
        if success then
            xPlayer.addMoney(Config.RobberyReward)
            TriggerClientEvent('esx:showNotification', source, 'Robbery successful! You received $' .. Config.RobberyReward)

            local cooldownEnd = os.time() + Config.RobberyCooldown
            MySQL.Async.execute('INSERT INTO robbery_cooldowns (player_id, cooldown_end) VALUES (@player_id, FROM_UNIXTIME(@cooldown_end))', {
                ['@player_id'] = playerId,
                ['@cooldown_end'] = cooldownEnd
            })

            MySQL.Async.execute('INSERT INTO robberies (player_id, location, start_time, end_time, success, reward) VALUES (@player_id, @location, FROM_UNIXTIME(@start_time), FROM_UNIXTIME(@end_time), @success, @reward)', {
                ['@player_id'] = playerId,
                ['@location'] = location,
                ['@start_time'] = activeRobberies[playerId].startTime,
                ['@end_time'] = os.time(),
                ['@success'] = true,
                ['@reward'] = Config.RobberyReward
            })
        else
            TriggerClientEvent('esx:showNotification', source, 'Robbery failed')

            MySQL.Async.execute('INSERT INTO robberies (player_id, location, start_time, end_time, success, reward) VALUES (@player_id, @location, FROM_UNIXTIME(@start_time), FROM_UNIXTIME(@end_time), @success, @reward)', {
                ['@player_id'] = playerId,
                ['@location'] = location,
                ['@start_time'] = activeRobberies[playerId].startTime,
                ['@end_time'] = os.time(),
                ['@success'] = false,
                ['@reward'] = 0
            })
        end

        activeRobberies[playerId] = nil
    end
end)