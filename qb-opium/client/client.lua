local QBCore = exports['qb-core']:GetCoreObject()

isLoggedIn = true

local menuOpen = false
local wasOpen = false
local spawnedOpium = 0
local opiumPlants = {}

local isPickingUp, isProcessing, isProcessing2 = false, false, false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
	CheckCoords()
	Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.CircleZones.OpiumField.coords, true) < 1000 then
		SpawnOpiumPlants()
	end
end)

function CheckCoords()
	CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.CircleZones.OpiumField.coords, true) < 1000 then
				SpawnOpiumPlants()
			end
			Wait(1 * 60000)
		end
	end)
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CheckCoords()
	end
end)

CreateThread(function()--Opium
	while true do
		Wait(10)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID


		for i=1, #opiumPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(opiumPlants[i]), false) < 1 then
				nearbyObject, nearbyID = opiumPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				QBCore.Functions.Draw2DText(0.5, 0.88, 'Press ~g~[E]~w~ to pickup Opium', 0.4)
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
				QBCore.Functions.Progressbar("search_register", "Picking up Opium..", 3000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					disableInventory = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					QBCore.Functions.DeleteObject(nearbyObject)

					table.remove(opiumPlants, nearbyID)
					spawnedOpium = spawnedOpium - 1

					TriggerServerEvent('qb-opiumpicking:pickedUpOpium')
				end, function()
					ClearPedTasks(PlayerPedId())
				end)

				isPickingUp = false
			end
		else
			Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(opiumPlants) do
			QBCore.Functions.DeleteObject(nearbyObject)
		end
	end
end)
function SpawnOpiumPlants()
	while spawnedOpium < 20 do
		Wait(1)
		local opiumCoords = GenerateOpiumCoords()

		QBCore.Functions.SpawnLocalObject('prop_plant_fern_02a', opiumCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)


			table.insert(opiumPlants, obj)
			spawnedOpium = spawnedOpium + 1
		end)
	end
	Wait(45 * 60000)
end

function ValidateOpiumCoord(plantCoord)
	if spawnedOpium > 0 then
		local validate = true

		for k, v in pairs(opiumPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.OpiumField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateOpiumCoords()
	while true do
		Wait(1)

		local opiumCoordX, opiumCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-10, 10)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-10, 10)

		opiumCoordX = Config.CircleZones.OpiumField.coords.x + modX
		opiumCoordY = Config.CircleZones.OpiumField.coords.y + modY

		local coordZ = GetCoordZOpium(opiumCoordX, opiumCoordY)
		local coord = vector3(opiumCoordX, opiumCoordY, coordZ)

		if ValidateOpiumCoord(coord) then
			return coord
		end
	end
end

function GetCoordZOpium(x, y)
	local groundCheckHeights = { 31.0, 32.0, 33.0, 34.0, 35.0, 36.0, 37.0, 38.0, 39.0, 40.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 31.85
end

CreateThread(function()
	while QBCore == nil do
		Wait(200)
	end
	while true do
		Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.OpiumProcessing.coords, true) < 5 then
			DrawMarker(2, Config.CircleZones.OpiumProcessing.coords.x, Config.CircleZones.OpiumProcessing.coords.y, Config.CircleZones.OpiumProcessing.coords.z - 0.2 , 0, 0, 0, 0, 0, 0, 0.3, 0.2, 0.15, 255, 0, 0, 100, 0, 0, 0, true, 0, 0, 0)


			if not isProcessing and GetDistanceBetweenCoords(coords, Config.CircleZones.OpiumProcessing.coords, true) <1 then
				QBCore.Functions.DrawText3D(Config.CircleZones.OpiumProcessing.coords.x, Config.CircleZones.OpiumProcessing.coords.y, Config.CircleZones.OpiumProcessing.coords.z, 'Press ~g~[E]~w~ to Process')
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				local hasBag = false
				local s1 = false
				local hasOpium = false
				local s2 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasOpium = result
					s1 = true
				end, 'opium')

				while(not s1) do
					Wait(100)
				end
				Wait(100)
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag = result
					s2 = true
				end, 'plastic_baggie')

				while(not s2) do
					Wait(100)
				end

				if (hasOpium and hasBag) then
					Processopium()
				elseif (hasOpium) then
					QBCore.Functions.Notify('You dont have enough plastic bags.', 'error')
				elseif (hasBag) then
					QBCore.Functions.Notify('You dont have enough opium.', 'error')
				else
					QBCore.Functions.Notify('You dont have enough opium and plastic bags.', 'error')
				end
			end
		else
			Wait(500)
		end
	end
end)

function Processopium()
	isProcessing = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	SetEntityHeading(PlayerPedId(), 108.06254)

	QBCore.Functions.Progressbar("search_register", "Trying to Process..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = true,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-opiumpicking:processopium')

		local timeLeft = Config.Delays.OpiumProcessing / 1000

		while timeLeft > 0 do
			Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.OpiumProcessing.coords, false) > 4 then
				TriggerServerEvent('qb-opiumpicking:cancelProcessing')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel

	isProcessing = false
end

CreateThread(function()
	while QBCore == nil do
		Wait(200)
	end
	while true do
		Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.DrugDealer.coords, true) < 5 then
			DrawMarker(2, Config.CircleZones.DrugDealer.coords.x, Config.CircleZones.DrugDealer.coords.y, Config.CircleZones.DrugDealer.coords.z - 0.2 , 0, 0, 0, 0, 0, 0, 0.3, 0.2, 0.15, 255, 0, 0, 100, 0, 0, 0, true, 0, 0, 0)


			if not isProcessing2 and GetDistanceBetweenCoords(coords, Config.CircleZones.DrugDealer.coords, true) <1 then
				QBCore.Functions.DrawText3D(Config.CircleZones.DrugDealer.coords.x, Config.CircleZones.DrugDealer.coords.y, Config.CircleZones.DrugDealer.coords.z, 'Press ~g~[E]~w~ to Sell')
			end

			if IsControlJustReleased(0, 38) and not isProcessing2 then
				local hasOpium2 = false
				local hasBag2 = false
				local s3 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasOpium2 = result
					hasBag2 = result
					s3 = true

				end, 'heroin')

				while(not s3) do
					Wait(100)
				end


				if (hasOpium2) then
					SellDrug()
				elseif (hasOpium2) then
					QBCore.Functions.Notify('You dont have enough plastic bags.', 'error')
				elseif (hasBag2) then
					QBCore.Functions.Notify('You dont have enough opium.', 'error')
				else
					QBCore.Functions.Notify('You dont have enough heroin bags to sell.', 'error')
				end
			end
		else
			Wait(500)
		end
	end
end)

function SellDrug()
	isProcessing2 = true
	local playerPed = PlayerPedId()

	--
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	SetEntityHeading(PlayerPedId(), 108.06254)

	QBCore.Functions.Progressbar("search_register", "Trying to Sell..", 1500, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = true,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-opiumpicking:selld')

		local timeLeft = Config.Delays.OpiumProcessing / 1000

		while timeLeft > 0 do
			Wait(500)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.OpiumProcessing.coords, false) > 4 then
				break
			end
		end
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel

	isProcessing2 = false
end
