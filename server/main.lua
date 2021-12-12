ESX = nil

TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)

local Webhook = Config.Webhook
local Profile = Config.WebhookImg

RegisterServerEvent('dv_extradrugs:sellItem')
AddEventHandler('dv_extradrugs:sellItem', function(value, price)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem(value).count > 0 then
		if Config.AlertCops then 
			TriggerClientEvent('dv_extradrugs:AlertPolice1', source)
		end
		if Config.EnableLog then 
			PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Drug System', avatar_url = Profile, content = '```css\n[dv_drugsystem]\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Bought seeds!\n```'}), { ['Content-Type'] = 'application/json' })
		end
		TriggerClientEvent('dv_extradrugs:wait', source)
		Wait(7500)
		if value == "meth_packed" then 
			xPlayer.removeInventoryItem(value, 1)
			xPlayer.addAccountMoney('black_money', price)
		elseif value == "speed_packed" then 
			xPlayer.removeInventoryItem(value, 1)
			xPlayer.addAccountMoney('black_money', price)
		elseif value == "marihuana_packed" then 
			xPlayer.removeInventoryItem(value, 1)
			xPlayer.addAccountMoney('black_money', price)
		elseif value == "weed_packed" then 
			xPlayer.removeInventoryItem(value, 1)
			xPlayer.addAccountMoney('black_money', price)
		elseif value == "lsd_packed" then 
			xPlayer.removeInventoryItem(value, 1)
			xPlayer.addAccountMoney('black_money', price)
		elseif value == "kokain_packed" then 
			xPlayer.removeInventoryItem(value, 1)
			xPlayer.addAccountMoney('black_money', price)
		end
	else	
		TriggerClientEvent('dv_extradrugs:noItem', source)
	end
end)

ESX.RegisterServerCallback('dv_extradrugs:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
    local items = xPlayer.getInventoryItem(item)

    if items == nil then
        cb(0)
    else
        cb(items.count)
    end
end)

RegisterServerEvent('dv_extradrugs:buySeed')
AddEventHandler('dv_extradrugs:buySeed', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if not Config.UseDirtyMoney then 
		if(xPlayer.getMoney() >= Config.SeedPrice) then
			xPlayer.removeMoney(Config.SeedPrice)
			if not Config.AlertCops then
				TriggerClientEvent('dv_extradrugs:wait', source)
				Wait(7500)
        		xPlayer.addInventoryItem('seed', 5)
			end	
			if Config.EnableLog then
				PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Drug System', avatar_url = Profile, content = '```css\n[dv_drugsystem]\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Bought seeds!\n```'}), { ['Content-Type'] = 'application/json' })
			end
			if Config.AlertCops then
				TriggerClientEvent('dv_extradrugs:AlertPolice', source)
				TriggerClientEvent('dv_extradrugs:wait', source)
				Wait(7500)
				xPlayer.addInventoryItem('seed', 5)
			end
		else
        	TriggerClientEvent("dv_extradrugs:notenough", source)
		end	
	else 
		if xPlayer.getAccount(Config.DirtyCash).money >= Config.SeedPrice then
			xPlayer.removeAccountMoney(Config.DirtyCash, Config.SeedPrice)
			if not Config.AlertCops then
				TriggerClientEvent('dv_extradrugs:wait', source)
				Wait(7500)
        		xPlayer.addInventoryItem('seed', 5)
			end	
			if Config.EnableLog then 
				PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Drug System', avatar_url = Profile, content = '```css\n[dv_drugsystem]\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Bought seeds!\n```'}), { ['Content-Type'] = 'application/json' })
			end
			if Config.AlertCops then
				TriggerClientEvent('dv_extradrugs:AlertPolice', source)
				TriggerClientEvent('dv_extradrugs:wait', source)
				Wait(7500)
				xPlayer.addInventoryItem('seed', 5)
			end
		else
        	TriggerClientEvent("dv_extradrugs:notenoughdirty", source)
		end	
	end
end)

RegisterServerEvent('dv_extradrugs:removeItem')
AddEventHandler('dv_extradrugs:removeItem', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('seed', 1)
end)

ESX.RegisterUsableItem('seed', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == Config.PoliceJob or xPlayer.job.name == "offpolice" or xPlayer.job.name == "ambulance" or xPlayer.job.name == "offambulance" or xPlayer.job.name == "sheriff" or xPlayer.job.name == "offsheriff" then
		TriggerClientEvent('dv_extradrugs:notAllowed', source)
	else
		TriggerClientEvent('dv_extradrugs:checkDistance', source)
	end
end)

RegisterServerEvent('dv_extradrugs:giveItemToPlayer')
AddEventHandler('dv_extradrugs:giveItemToPlayer', function(item, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem(item, amount)
	if Config.EnableLog then
		PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Drug System', avatar_url = Profile, content = '```css\n[dv_drugsystem]\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Harvested a ' .. item .. '\n```'}), { ['Content-Type'] = 'application/json' })
	end
end)

RegisterServerEvent('dv_extradrugs:LogPlanting')
AddEventHandler('dv_extradrugs:LogPlanting', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
		PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Drug System', avatar_url = Profile, content = '```css\n[dv_drugsystem]\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Planted a seed!\n```'}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('dv_extradrugs:LogTable')
AddEventHandler('dv_extradrugs:LogTable', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
		PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Drug System', avatar_url = Profile, content = '```css\n[dv_drugsystem]\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Placed a table!\n```'}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('dv_extradrugs:die')
AddEventHandler('dv_extradrugs:die', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
		PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Drug System', avatar_url = Profile, content = '```css\n[dv_drugsystem]\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Died in drugs!\n```'}), { ['Content-Type'] = 'application/json' })
end)

RegisterServerEvent('dv_extradrugs:craftBox')
AddEventHandler('dv_extradrugs:craftBox', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem("paper").count > 3 then
		TriggerClientEvent('dv_extradrugs:progbar2', source)
		Wait(3000)
		xPlayer.removeInventoryItem("paper", 4)
		xPlayer.addInventoryItem("box", 1)
	else 
		TriggerClientEvent('dv_extradrugs:noItem', source)
	end
end)

RegisterServerEvent('dv_extradrugs:pack')
AddEventHandler('dv_extradrugs:pack', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem(item).count > 9 then
		if xPlayer.getInventoryItem("box").count > 0 then
			TriggerClientEvent('dv_extradrugs:progbar', source)
			Wait(7500)
			xPlayer.removeInventoryItem("box", 1)
			xPlayer.removeInventoryItem(item, 10)
			if item == "use_meth" then
				xPlayer.addInventoryItem('meth_packed', 1)
			elseif item == "use_speed" then
				xPlayer.addInventoryItem('speed_packed', 1)
			elseif item == "use_marihuana" then
				xPlayer.addInventoryItem('marihuana_packed', 1)
			elseif item == "use_weed" then
				xPlayer.addInventoryItem('weed_packed', 1)
			elseif item == "use_lsd" then
				xPlayer.addInventoryItem('lsd_packed', 1)
			elseif item == "use_kokain" then
				xPlayer.addInventoryItem('kokain_packed', 1)
			end
		else 
			TriggerClientEvent('dv_extradrugs:noItem', source)
		end
	else 
		TriggerClientEvent('dv_extradrugs:noItem', source)
	end
end)

RegisterServerEvent('dv_extradrugs:process')
AddEventHandler('dv_extradrugs:process', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.getInventoryItem(item).name == "cannabis" then
		if xPlayer.getInventoryItem("cannabis").count > 2 and xPlayer.getInventoryItem("higito").count > 0 and xPlayer.getInventoryItem("ammonia").count > 1 and xPlayer.getInventoryItem("acetone").count > 1 then
			xPlayer.removeInventoryItem("higito", 1)
			xPlayer.removeInventoryItem("ammonia", 2)
			xPlayer.removeInventoryItem("cannabis", 3)
			xPlayer.removeInventoryItem("acetone", 2)
			TriggerClientEvent('dv_extradrugs:progbar1', source)
			TriggerClientEvent('dv_extradrugs:menuOn', source)
			Wait(17500)
			xPlayer.addInventoryItem("use_meth", 1)
			TriggerClientEvent('dv_extradrugs:menuOff', source)
		else 
			TriggerClientEvent('dv_extradrugs:notenoughItem', source)
		end
	elseif xPlayer.getInventoryItem(item).name == "speed" then
		if xPlayer.getInventoryItem("higito").count > 0 and xPlayer.getInventoryItem("cukor").count > 1 and xPlayer.getInventoryItem("speed").count > 1 and xPlayer.getInventoryItem("energy").count > 2 and xPlayer.getInventoryItem("acetone").count > 3 then
			xPlayer.removeInventoryItem("higito", 1)
			xPlayer.removeInventoryItem("cukor", 2)
			xPlayer.removeInventoryItem("speed", 2)
			xPlayer.removeInventoryItem("energy", 3)
			xPlayer.removeInventoryItem("acetone", 4)
			TriggerClientEvent('dv_extradrugs:progbar1', source)
			TriggerClientEvent('dv_extradrugs:menuOn', source)
			Wait(17500)
			xPlayer.addInventoryItem("use_speed", 1)
			TriggerClientEvent('dv_extradrugs:menuOff', source)
		else 
			TriggerClientEvent('dv_extradrugs:notenoughItem', source)
		end
	elseif xPlayer.getInventoryItem(item).name == "marihuana" then
		if xPlayer.getInventoryItem("marihuana").count > 4 and xPlayer.getInventoryItem("higito").count > 0 and xPlayer.getInventoryItem("alcohol").count > 2 then
			xPlayer.removeInventoryItem("higito", 1)
			xPlayer.removeInventoryItem("alcohol", 3)
			xPlayer.removeInventoryItem("marihuana", 5)
			TriggerClientEvent('dv_extradrugs:progbar1', source)
			TriggerClientEvent('dv_extradrugs:menuOn', source)
			Wait(17500)
			xPlayer.addInventoryItem("use_marihuana", 1)
			TriggerClientEvent('dv_extradrugs:menuOff', source)
		else 
			TriggerClientEvent('dv_extradrugs:notenoughItem', source)
		end
	elseif xPlayer.getInventoryItem(item).name == "weed" then
		if xPlayer.getInventoryItem("weed").count > 3 and xPlayer.getInventoryItem("ammonia").count > 2 then
			xPlayer.removeInventoryItem("weed", 4)
			xPlayer.removeInventoryItem("ammonia", 3)
			TriggerClientEvent('dv_extradrugs:progbar1', source)
			TriggerClientEvent('dv_extradrugs:menuOn', source)
			Wait(17500)
			xPlayer.addInventoryItem("use_weed", 1)
			TriggerClientEvent('dv_extradrugs:menuOff', source)
		else 
			TriggerClientEvent('dv_extradrugs:notenoughItem', source)
		end
	elseif xPlayer.getInventoryItem(item).name == "lsd" then
		if xPlayer.getInventoryItem("higito").count > 0 and xPlayer.getInventoryItem("energy").count > 3 and xPlayer.getInventoryItem("acetone").count > 2 then
			xPlayer.removeInventoryItem("higito", 1)
			xPlayer.removeInventoryItem("energy", 4)
			xPlayer.removeInventoryItem("acetone", 3)
			TriggerClientEvent('dv_extradrugs:progbar1', source)
			TriggerClientEvent('dv_extradrugs:menuOn', source)
			Wait(17500)
			xPlayer.addInventoryItem("use_lsd", 1)
			TriggerClientEvent('dv_extradrugs:menuOff', source)
		else 
			TriggerClientEvent('dv_extradrugs:notenoughItem', source)
		end
	elseif xPlayer.getInventoryItem(item).name == "kokain" then
		if xPlayer.getInventoryItem("energy").count > 6 and xPlayer.getInventoryItem("alcohol").count > 0 and xPlayer.getInventoryItem("kokain").count > 0 and xPlayer.getInventoryItem("acetone").count > 2 then
			xPlayer.removeInventoryItem("energy", 7)
			xPlayer.removeInventoryItem("alcohol", 1)
			xPlayer.removeInventoryItem("kokain", 5)
			xPlayer.removeInventoryItem("acetone", 3)
			TriggerClientEvent('dv_extradrugs:progbar1', source)
			TriggerClientEvent('dv_extradrugs:menuOn', source)
			Wait(17500)
			xPlayer.addInventoryItem("use_kokain", 1)
		else 
			TriggerClientEvent('dv_extradrugs:notenoughItem', source)
		end
	end
end)

----- # packages

ESX.RegisterUsableItem('cannabis_packed', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("cannabis_packed", 1)
	xPlayer.addInventoryItem("use_cannabis", 10)
end)

ESX.RegisterUsableItem('speed_packed', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("speed_packed", 1)
	xPlayer.addInventoryItem("use_speed", 10)
end)

ESX.RegisterUsableItem('marihuana_packed', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("marihuana_packed", 1)
	xPlayer.addInventoryItem("use_marihuana", 10)
end)

ESX.RegisterUsableItem('weed_packed', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("weed_packed", 1)
	xPlayer.addInventoryItem("use_weed", 10)
end)

ESX.RegisterUsableItem('lsd_packed', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("lsd_packed", 1)
	xPlayer.addInventoryItem("use_lsd", 10)
end)

ESX.RegisterUsableItem('kokain_packed', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("kokain_packed", 1)
	xPlayer.addInventoryItem("use_kokain", 10)
end)

----- # effects

ESX.RegisterUsableItem('use_meth', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("use_meth", 1)
	TriggerClientEvent('dv_extradrugs:effect', source, "meth")
end)

ESX.RegisterUsableItem('use_speed', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("use_speed", 1)
	TriggerClientEvent('dv_extradrugs:effect', source, "speed")
end)

ESX.RegisterUsableItem('use_marihuana', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("use_marihuana", 1)
	TriggerClientEvent('dv_extradrugs:effect', source, "marihuana")
end)

ESX.RegisterUsableItem('use_weed', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("use_weed", 1)
	TriggerClientEvent('dv_extradrugs:effect', source, "weed")
end)

ESX.RegisterUsableItem('use_lsd', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("use_lsd", 1)
	TriggerClientEvent('dv_extradrugs:effect', source, "lsd")
end)

ESX.RegisterUsableItem('use_kokain', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("use_kokain", 1)
	TriggerClientEvent('dv_extradrugs:effect', source, "kokain")
end)

ESX.RegisterUsableItem('menta', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem("menta", 1)
	TriggerClientEvent('dv_extradrugs:clear', source)
end)

ESX.RegisterUsableItem('table', function(source)
	xPlayer = ESX.GetPlayerFromId(source)
	if Config.EnableTable then 
		xPlayer.removeInventoryItem("table", 1)
		TriggerClientEvent('dv_extradrugs:addTable', source)
	end
end)