local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-slots:server:checkForMoney', function(bet)
    local src = source
	local player = QBCore.Functions.GetPlayer(src)

    if player ~= nil then
        if bet % 10 == 0 and bet >= 10 then
            if player.PlayerData.money['cash'] >= bet then
                player.Functions.RemoveMoney('cash', tonumber(bet), 'Slots-Money')
                TriggerClientEvent('qb-slots:client:updateSlots', src, bet)
            else
                TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough money!', 'error', 10000)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'You must enter a multiple of 10. Ex: 10, 60, 100', 'error', 10000)
        end
    end
end)

QBCore.Functions.CreateCallback('qb-slots:server:close', function(source, cb, amount)
    local src = source	
    local player = QBCore.Functions.GetPlayer(src)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local allowed = false

    for i, v in pairs(Config.Slots) do
        local slotCoords = vector3(v.x, v.y, v.z)
        if #(slotCoords - coords) <= (Config.Radius * 5.0) then
            allowed = true
            break
        end
    end

    if not allowed then 
        print('Not in area..')
    end

    if player ~= nil then
        amount = tonumber(amount)

        if amount > 0 then
            player.Functions.AddMoney('cash', amount, 'Slots-Money-Won')
            TriggerClientEvent('QBCore:Notify', src, 'You took $' .. tostring(amount) .. ' out of the machine!', 'success', 10000)

            cb(true)
        else
            TriggerClientEvent('QBCore:Notify', src, 'You lost all your money, be careful next time..', 'error', 10000)
        end
    else
        cb(false)
    end
end)
