local QBCore = exports['qb-core']:GetCoreObject()

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

RegisterServerEvent('qb-opium:pickedUpOpium') --hero
AddEventHandler('qb-opium:pickedUpOpium', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	    if 	TriggerClientEvent("QBCore:Notify", src, "You Got Some Opium.", "Success", 8000) then
		  Player.Functions.AddItem('opium', 1) ---- change this shit 
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['opium'], "add")
	    end
end)	

RegisterServerEvent('qb-opium:processopium')
AddEventHandler('qb-opium:processopium', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	if Player.Functions.GetItemByName('opium') and Player.Functions.GetItemByName('plastic_baggie') then
		local chance = math.random(1, 8)
		if chance == 1 or chance == 2 or chance == 3 or chance == 4 or chance == 5 or chance == 6 or chance == 7 or chance == 8 then
			Player.Functions.RemoveItem('plastic_baggie', 1)----change this
			Player.Functions.RemoveItem('opium', 2)---change this
			Player.Functions.AddItem('heroin', 1)----change this
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['opium'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['plastic_baggie'], "remove")
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['heroin'], "add")
			TriggerClientEvent('QBCore:Notify', src, 'Heroin Processed successfully', "success")  
		end 
	else
		TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
	end
end)

--selldrug ok

RegisterServerEvent('qb-opium:selld2')
AddEventHandler('qb-opium:selld2', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Item = Player.Functions.GetItemByName('heroin')
   
	
      
	for i = 1, Item.amount do
	if Item.amount >0 then
	if Player.Functions.GetItemByName('heroin') then
		local chance2 = math.random(1, 8)
		if chance2 == 1 or chance2 == 2 or chance2 == 9 or chance2 == 4 or chance2 == 10 or chance2 == 6 or chance2 == 7 or chance2 == 8 then
			Player.Functions.RemoveItem('heroin', 1)----change this
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['heroin'], "remove")
			Player.Functions.AddMoney("cash", Config.Pricesell, "sold-pawn-items")
			TriggerClientEvent('QBCore:Notify', src, 'You Sold Heroin', "success")   
		end 
	else
		TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
	end
else
	TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
	
end
end
end)



function CancelProcessing(playerId)
	if playersProcessingCannabis[playerId] then
		ClearTimeout(playersProcessingCannabis[playerId])
		playersProcessingCannabis[playerId] = nil
	end
end

RegisterServerEvent('qb-opium:cancelProcessing3')
AddEventHandler('qb-opium:cancelProcessing3', function()
	CancelProcessing(source)
end)

AddEventHandler('QBCore_:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('qb-opium:onPlayerDeath2')
AddEventHandler('qb-opium:onPlayerDeath2', function(data)
	local src = source
	CancelProcessing(src)
end)

QBCore.Functions.CreateCallback('poppy:process', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	 
	if Player.PlayerData.item ~= nil and next(Player.PlayerData.items) ~= nil then
		for k, v in pairs(Player.PlayerData.items) do
		    if Player.Playerdata.items[k] ~= nil then
				if Player.Playerdata.items[k].name == "heroin" then
					cb(true)
			    else
					TriggerClientEvent("QBCore:Notify", src, "You do not have any Heroin process", "error", 10000)
					cb(false)
				end
	        end
		end	
	end
end)
