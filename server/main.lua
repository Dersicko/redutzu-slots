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

RegisterServerEvent('qb-slots:server:payRewards', function(amount)
    local src = source
	local player = QBCore.Functions.GetPlayer(src)

    if player ~= nil then
        amount = tonumber(amount)

        if amount > 0 then
            player.Functions.AddMoney('cash', amount, 'Slots-Money-Won')
            TriggerClientEvent('QBCore:Notify', src, 'You took $' .. tostring(amount) .. ' out of the machine!', 'success', 10000)
        else
            TriggerClientEvent('QBCore:Notify', src, 'You lost all your money, be careful next time..', 'error', 10000)
        end
    end
end)
