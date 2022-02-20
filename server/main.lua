local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('qb-slots:server:checkForMoney', function(bet)
    local src = source
	local player = QBCore.Functions.GetPlayer(src)

    if player ~= nil then
        if bet % 10 == 0 and bet >= 10 then
            if player.PlayerData.money['cash'] >= bet then
                player.Functions.RemoveMoney('cash', tonumber(bet), 'Bani bagati in aparat!')
                TriggerClientEvent('qb-slots:client:updateSlots', src, bet)
            else
                TriggerClientEvent('QBCore:Notify', src, 'Nu ai destui bani..', 'error', 10000)
            end
        else
            TriggerClientEvent('QBCore:Notify', src, 'Trebuie sa introduci un multiplu al numarului 10. Ex: 10, 20, 60, 100', 'error', 10000)
        end
    end
end)

RegisterServerEvent('qb-slots:server:payRewards', function(amount)
    local src = source
	local player = QBCore.Functions.GetPlayer(src)

    if player ~= nil then
        amount = tonumber(amount)

        if amount > 0 then
            player.Functions.AddMoney('cash', amount, 'Bani castigati din pacanele!')
            TriggerClientEvent('QBCore:Notify', src, 'Ai scos ' .. amount .. '$ din aparat!', 'success', 10000)
        else
            TriggerClientEvent('QBCore:Notify', src, 'Ai pierdut toti banii, ai grija data viitoare..', 'error', 10000)
        end
    end
end)