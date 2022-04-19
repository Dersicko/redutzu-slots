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

RegisterNetEvent('qb-slots:client:enter', function(coords)
	SetOpened(true)
	SendNUIMessage({ action = 'openAmount' })
end)

RegisterNUICallback('close', function(data, cb)
	QBCore.Functions.TriggerCallback('qb-slots:server:close', function()
		cb('ok')
		SetOpened(false)
	end, data.amount)
end)

CreateThread(function()
	local sleep = 500

	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped, false)

        sleep = 500

		for i, v in ipairs(Config.Slots) do 
			local slot = vector3(v.x, v.y, v.z)

			if #(coords - slot) <= Config.Radius and not open then
			    sleep = 5

				DrawMarker(29, slot.x, slot.y, slot.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 247, 77, 77, 110, false, false, false, true, false, false, false)

				if IsControlJustReleased(0, 38) then
					TriggerEvent('qb-slots:client:enter', slot)
				end
			end
		end
		
		Wait(sleep)
	end
end)

CreateThread(function()
	local sleep = 500

	while true do
		if open then
			sleep = 1

			DisableControlAction(0, 1, true) 
			DisableControlAction(0, 2, true)
			DisableControlAction(0, 24, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 106, true)
			DisablePlayerFiring(PlayerPedId(), true)
		else
			sleep = 500
		end

		Wait(sleep)
	end
end)
