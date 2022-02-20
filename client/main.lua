local QBCore = exports['qb-core']:GetCoreObject()
local open = false

function SetOpened(state) 
    SetNuiFocus(state, state)
    open = state
end

RegisterNetEvent('qb-slots:client:updateSlots', function(bet)
	SetOpened(true)
	SendNUIMessage({ action = 'open', amount = bet })
end)

RegisterNUICallback('setCoins', function(data, cb)
	cb('ok')
    SetOpened(false)
    TriggerServerEvent('qb-slots:server:checkForMoney', tonumber(data.amount) or 0)
end)

RegisterNetEvent('qb-slots:client:enter', function ()
    SetOpened(true)
	SendNUIMessage({ action = 'openAmount' })
end)

RegisterNUICallback('close', function(data, cb)
	cb('ok')
    SetOpened(false)
	TriggerServerEvent('qb-slots:server:payRewards', data.amount)
end)

CreateThread(function()
	while true do
		Wait(1)

		local playerCoords = GetEntityCoords(PlayerPedId(), false)

		for i, v in ipairs(Config.Slots) do 
			local slotsCoords = vector3(v.x, v.y, v.z)

			if #(playerCoords - slotsCoords) <= 2.5 then
			    QBCore.Functions.DrawText3D(slotsCoords.x, slotsCoords.y, slotsCoords.z, '~b~E~w~ - Open slots')

				if IsControlJustReleased(0, 38) then
					TriggerEvent('qb-slots:client:enter')
				end
			end
		end
	end
end)

CreateThread(function ()
	while true do
		Wait(1)

		if open then
			local ped = PlayerPedId()
			
			DisableControlAction(0, 1, true) 
			DisableControlAction(0, 2, true)
			DisableControlAction(0, 24, true)
			DisablePlayerFiring(ped, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 106, true)
		end
	end
end)
