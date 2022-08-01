local QBCore = exports['qb-core']:GetCoreObject()

local itemcraft = 'markedbills'

RegisterServerEvent('qb-opiumpicking:pickedUpOpium', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	    if 	TriggerClientEvent("QBCore:Notify", src, "Picked up some Opium!!", "Success", 1000) then
		  Player.Functions.AddItem('opium', 1) ---- change this shit 
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['opium'], "add")
	    end
end)

RegisterServerEvent('qb-opiumpicking:processopium', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local opium = Player.Functions.GetItemByName("opium")
      local plastic_baggie = Player.Functions.GetItemByName("plastic_baggie")

    if opium ~= nil and plastic_baggie ~= nil then
        if Player.Functions.RemoveItem('opium', 3) and Player.Functions.RemoveItem('plastic_baggie', 1) then
            Player.Functions.AddItem('heroin', 1)-----change this
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['opium'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['plastic_baggie'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['heroin'], "add")
            TriggerClientEvent('QBCore:Notify', src, 'Opium Processed successfully', "success")  
        else
            TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
    end
end)

--selldrug ok

RegisterServerEvent('qb-opiumpicking:selld', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Item = Player.Functions.GetItemByName('heroin')
   
	if Item ~= nil and Item.amount >= 1 then
		local chance2 = math.random(1, 12)
		if chance2 == 1 or chance2 == 2 or chance2 == 9 or chance2 == 4 or chance2 == 10 or chance2 == 6 or chance2 == 7 or chance2 == 8 then
			Player.Functions.RemoveItem('heroin', 1)----change this
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['heroin'], "remove")
			Player.Functions.AddMoney("cash", Config.Pricesell, "sold-pawn-items")
			TriggerClientEvent('QBCore:Notify', src, 'you sold to the pusher', "success")  
		else
			Player.Functions.RemoveItem('heroin', 1)----change this
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['heroin'], "remove")
			Player.Functions.AddMoney("cash", Config.Pricesell-100, "sold-pawn-items")
			TriggerClientEvent('QBCore:Notify', src, 'you sold to the pusher', "success")
		end
else
	TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
	
end
end)

function CancelProcessing(playerId)
	if playersProcessingOpium[playerId] then
		ClearTimeout(playersProcessingOpium[playerId])
		playersProcessingOpium[playerId] = nil
	end
end

RegisterServerEvent('qb-opiumpicking:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('QBCore_:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('qb-opiumpicking:onPlayerDeath', function(data)
	local src = source
	CancelProcessing(src)
end)

QBCore.Functions.CreateCallback('poppy:process', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	 
	if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
		for k, v in pairs(Player.PlayerData.items) do
		    if Player.Playerdata.items[k] ~= nil then
				if Player.Playerdata.items[k].name == "opium" then
					cb(true)
			    else
					TriggerClientEvent("QBCore:Notify", src, "You do not have any Opium", "error", 10000)
					cb(false)
				end
	        end
		end	
	end
end)
