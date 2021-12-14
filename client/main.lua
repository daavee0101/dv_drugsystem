ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
  
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(11)
	end
	PlayerData = ESX.GetPlayerData()
end)

local watered = false
local waterinprog = false
local vasarlas = false
local menuben = false
local eladas = false
local TimerStart = false

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    while ESX == nil do Wait(0) end
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

RegisterNetEvent('dv_extradrugs:notenough')
AddEventHandler('dv_extradrugs:notenough', function()
	Notification(_U('not_enough_money'))
end)

RegisterNetEvent('dv_extradrugs:notenoughItem')
AddEventHandler('dv_extradrugs:notenoughItem', function()
	Notification(_U('not_enough_item'))
end)

RegisterNetEvent('dv_extradrugs:notAllowed')
AddEventHandler('dv_extradrugs:notAllowed', function()
	Notification(_U('not_allowed'))
end)

RegisterNetEvent('dv_extradrugs:wait')
AddEventHandler('dv_extradrugs:wait', function()
	vasarlas = true
	eladas = true
	local ped = PlayerPedId()
	FreezeEntityPosition(ped, true)
	exports['progressBars']:startUI(7500, _U('progbar_msg_trading'))
	Wait(7500)
	vasarlas = false
	eladas = false
	FreezeEntityPosition(ped, false)
end)

RegisterNetEvent('dv_extradrugs:noItem')
AddEventHandler('dv_extradrugs:noItem', function()
	Notification(_U('no_item'))
end)

RegisterNetEvent('dv_extradrugs:menuOn')
AddEventHandler('dv_extradrugs:menuOn', function()
	menuben = true
end)

RegisterNetEvent('dv_extradrugs:menuOf')
AddEventHandler('dv_extradrugs:menuOf', function()
	menuben = false
end)

RegisterNetEvent('dv_extradrugs:progbar')
AddEventHandler('dv_extradrugs:progbar', function()
	local ped = PlayerPedId()
	SetEntityHeading(ped, 44.36)
	loadAnimDict('anim@gangops@facility@servers@bodysearch@')
	FreezeEntityPosition(ped, true)
	TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
	exports['progressBars']:startUI(7500, _U('no_item'))
	Wait(7500)
	FreezeEntityPosition(ped, false)
	ClearPedTasksImmediately(ped)
end)

RegisterNetEvent('dv_extradrugs:progbar1')
AddEventHandler('dv_extradrugs:progbar1', function()
	local ped = PlayerPedId()
	SetEntityHeading(ped, 44.36)
	loadAnimDict('anim@gangops@facility@servers@bodysearch@')
	FreezeEntityPosition(ped, true)
	TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
	exports['progressBars']:startUI(17500, _U('progbar_msg_process'))
	Wait(17500)
	FreezeEntityPosition(ped, false)
	ClearPedTasksImmediately(ped)
	TriggerEvent('dv_extradrugs:menuOf')
end)

RegisterNetEvent('dv_extradrugs:progbar2')
AddEventHandler('dv_extradrugs:progbar2', function()
	local ped = PlayerPedId()
	SetEntityHeading(ped, 44.36)
	loadAnimDict('anim@gangops@facility@servers@bodysearch@')
	FreezeEntityPosition(ped, true)
	TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
	exports['progressBars']:startUI(3000, _U('progbar_msg_process'))
	Wait(3000)
	FreezeEntityPosition(ped, false)
	ClearPedTasksImmediately(ped)
end)

RegisterNetEvent('dv_extradrugs:AlertPolice')
AddEventHandler('dv_extradrugs:AlertPolice', function(source)
	Alert()
end)

function Alert()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)

	Notification(_U('phone_warning'))

	if Config.EnableBlips then 
		local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	
		SetBlipSprite (blip, 280)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.2)
		SetBlipColour (blip, 18)
		SetBlipAsShortRange(blip, false)
	
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString(_U('agent'))
		EndTextCommandSetBlipName(blip)
	end

	TriggerServerEvent('esx_phone:send', Config.PoliceJob, _U('phone_warning_msg'), false, {
		x = coords.x,
		y = coords.y,
		z = coords.z
	})

	if Config.EnableBlips then
		Citizen.Wait(5000)
		RemoveBlip(blip)
	end
end


RegisterNetEvent('dv_extradrugs:notenoughdirty')
AddEventHandler('dv_extradrugs:notenoughdirty', function()
	Notification(_U('not_enough_dirty'))
end)

RegisterNetEvent('dv_extradrugs:checkDistance')
AddEventHandler('dv_extradrugs:checkDistance', function()
	local playerPed = PlayerPedId()
	for _, item in pairs(Config.FarmLocations) do
	if GetDistanceBetweenCoords(GetEntityCoords(playerPed), item.x, item.y, item.z) > 300 then
		Notification(_U('no_farm_range'))
	else 
		TriggerEvent('dv_extradrugs:startPlanting')
	end
end
end)

local ultetes
local pozi = 1.0, 1.0, 1.0
local tablePozi = 1.0, 1.0, 1.0
local ultetett = false

function loadModel(model)
    while not HasModelLoaded(model) do Wait(0) RequestModel(model) end
    return model
end

RegisterNetEvent('dv_extradrugs:startPlanting')
AddEventHandler('dv_extradrugs:startPlanting', function()
	if Config.EnableLog then  
		TriggerServerEvent('dv_extradrugs:LogPlanting')
	end
	if not ultetett then 
	local playerPed = PlayerPedId()
	waterinprog = false
	loadAnimDict('anim@gangops@facility@servers@bodysearch@')
	TriggerServerEvent('dv_extradrugs:removeItem')
	FreezeEntityPosition(playerPed, true)
	TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, false)
	DisableAllControlActions(0)
	DisableControlAction(2, 37, true)
    DisableControlAction(0, 140, true)
	DisableControlAction(0, 141, true)
	DisableControlAction(0, 142, true)
	DisableControlAction(0, 73, true)
	exports['progressBars']:startUI(5000, _U('progbar_msg_planting'))
	Wait(5000)
	ClearPedTasksImmediately(playerPed)
	FreezeEntityPosition(playerPed, false)
	ultetes = true
	pozi = GetEntityCoords(playerPed)
	if Config.UseProp then
		local model = loadModel(GetHashKey("prop_weed_02"))
        local prop1 = CreateObject(model, pozi, true, false, false)
		PlaceObjectOnGroundProperly(prop1)
		FreezeEntityPosition(prop1, true)
	end
	EnableAllControlActions(0)
	ultetett = true
	else
		Notification(_U('only_one_plant')) 
	end
end)

RegisterNetEvent('dv_extradrugs:addTable')
AddEventHandler('dv_extradrugs:addTable', function()
	local playerPed = PlayerPedId()
	tablePozi = GetEntityCoords(playerPed)
	if Config.EnableTable then
	if not placed then
		if Config.EnableLog then  
			TriggerServerEvent('dv_extradrugs:LogTable')
		end
			local model2 = loadModel(GetHashKey("prop_tool_bench02"))
			local tableProp = CreateObject(model2, tablePozi, true, false, false)
			PlaceObjectOnGroundProperly(tableProp)
			SetEntityHeading(model2, GetEntityHeading(PlayerPedId()))
			FreezeEntityPosition(tableProp, true)
			placed = true
		else
			Notification(_U('workbench_already')) 
		end
	end
end)

local propactive = Config.UseProp

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if not Config.UseProp then
			DrawMarker(2, pozi, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 65, 255, 65, 100, false, true, 2, false, nil, nil, false)
		end
		if (GetDistanceBetweenCoords(pos, pozi, true) < 1.5) then
			drawOn(1.235, 1.542, 1.0,1.0,0.35, "~w~[E] " .. _U('water') .." | [H] ".. _U('pickup') .." | [X] ".. _U('destroy'), 255, 255, 255, 255)
			if IsControlJustReleased(1, 38) then        
				if not waterinprog then 
				TriggerEvent('dv_extradrugs:watering')
				else 
				Notification(_U('watered'))
				end
			end
			if IsControlJustReleased(1, 74) then        
				TriggerEvent('dv_extradrugs:pickup')
			end
			if IsControlJustReleased(1, 105) then        
				pozi = 1.0, 1.0, 1.0
				FreezeEntityPosition(prop1, false)
				FreezeEntityPosition(prop2, false)
				DeleteObject(prop1)
				DeleteObject(prop2)
				ultetett = false
				ESX.UI.Menu.CloseAll()
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local playerPed = PlayerPedId()
			if IsEntityInWater(PlayerPedId()) then 
				drawOn(1.265, 1.562, 1.0,1.0,0.35, "~w~[G] ".. _U('fill_can'), 255, 255, 255, 255)
			end
			if IsControlJustReleased(1, 113) and IsEntityInWater(PlayerPedId()) then        
				ESX.TriggerServerCallback('dv_extradrugs:getItemAmount', function(amount)
					if amount > 0 then
						if watered then
							Notification(_U('can_already_filled'))
						else
							watered = true
							Notification(_U('can_filled'))
						end
					else
						Notification(_U('no_watercan'))
					end
				end, 'watercan')
		end
	end
end)

RegisterNetEvent('dv_extradrugs:watering')
AddEventHandler('dv_extradrugs:watering', function()
	local playerPed = PlayerPedId()
	local ped = PlayerPedId()
	if not TimerStart then
		if not megerett then
		ESX.TriggerServerCallback('dv_extradrugs:getItemAmount', function(amount)
		if amount > 0 then
			if watered then
				waterinprog = true
				loadAnimDict('anim@gangops@facility@servers@bodysearch@')
				FreezeEntityPosition(ped, true)
				TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
				exports['progressBars']:startUI(5000, _U('progbar_msg_watering'))
				Wait(5000)
				ClearPedTasksImmediately(playerPed)
				FreezeEntityPosition(ped, false)
				Notification(_U('watered_success'))
				Wait(1500)
				TriggerEvent('dv_extradrugs:plantwatered')
				watered = false
			else
				Notification(_U('can_empty'))
			end
		else
			Notification(_U('no_watercan'))
		end
	end, 'watercan')
else 
	Notification(_U('not_allowed_during_grow'))
end
else
	Notification(_U('watered'))
end
end)

local megerett = false
local romlott = false
local TimerStart = false

RegisterNetEvent('dv_extradrugs:plantwatered')
AddEventHandler('dv_extradrugs:plantwatered', function()
	procent(Config.GrowingDuration)
	local ertek = math.random(1,100)
	if ertek > 10 then
		Notification(_U('plant_success'))
		if Config.UseProp then
			local model = loadModel(GetHashKey("prop_weed_01"))
			local prop2 = CreateObject(model, pozi, true, false, false)
			PlaceObjectOnGroundProperly(prop2)
			FreezeEntityPosition(prop1, false)
			FreezeEntityPosition(prop2, true)
		end
		megerett = true
	else 
		Notification(_U('plant_failed'))
		romlott = true
		megerett = false
	end
end)

function procent(time)
	showPro = true
	TimeLeft = 0
	repeat
	TimeLeft = TimeLeft + 1 
	Citizen.Wait(time)
	until(TimeLeft == 100)
	showPro = false
end

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		if showPro then
			drawOn(1.265, 1.562, 1.0,1.0,0.35, "~w~" .. _U('growing') .. TimeLeft .. "%", 255, 255, 255, 255)
		end
    end
end) 

RegisterNetEvent('dv_extradrugs:pickup')
AddEventHandler('dv_extradrugs:pickup', function()
	local playerPed = PlayerPedId()
	local ped = PlayerPedId()

	if megerett then 
		loadAnimDict('anim@gangops@facility@servers@bodysearch@')
		FreezeEntityPosition(ped, true)
		TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
		exports['progressBars']:startUI(5000, _U('progbar_msg_pickup'))
		Wait(5000)
		ClearPedTasksImmediately(playerPed)
		FreezeEntityPosition(ped, false)
		TriggerEvent('dv_extradrugs:giveItem')
		for _, item in pairs(Config.FarmLocations) do
			pozi = 1.0, 1.0, 1.0
			FreezeEntityPosition(prop1, false)
			FreezeEntityPosition(prop2, false)
			DeleteObject(prop1)
			DeleteObject(prop2)
		end
		ultetett = false
	elseif not megerett and not romlott then
		Notification(_U('plant_in_progress')) 
		for _, item in pairs(Config.FarmLocations) do
			pozi = 1.0, 1.0, 1.0
			FreezeEntityPosition(prop1, false)
			FreezeEntityPosition(prop2, false)
			DeleteObject(prop1)
			DeleteObject(prop2)
		end
		ultetett = false
	elseif romlott and not megerett then 
		Notification(_U('plant_failed')) 
		for _, item in pairs(Config.FarmLocations) do
			pozi = 1.0, 1.0, 1.0
			FreezeEntityPosition(prop1, false)
			FreezeEntityPosition(prop2, false)
			DeleteObject(prop1)
			DeleteObject(prop2)
		end
		ultetett = false
else 
	Notification(_U('not_allowed_during_grow'))
end
end)

RegisterNetEvent('dv_extradrugs:giveItem')
AddEventHandler('dv_extradrugs:giveItem', function(item)
	local chance = math.random(1,250)
	local amount = math.random(1,4)
	if chance > 0 and chance < 50 then 
		TriggerServerEvent('dv_extradrugs:giveItemToPlayer', 'cannabis', amount)
	elseif chance > 50 and chance < 100 then
		TriggerServerEvent('dv_extradrugs:giveItemToPlayer', 'speed', amount)
	elseif chance > 100 and chance < 150 then
		TriggerServerEvent('dv_extradrugs:giveItemToPlayer', 'marihuana', amount)
	elseif chance > 150 and chance < 200 then
		TriggerServerEvent('dv_extradrugs:giveItemToPlayer', 'weed', amount)
	elseif chance > 200 and chance < 250 then
		TriggerServerEvent('dv_extradrugs:giveItemToPlayer', 'kokain', amount)
	end
end)

function drawOn(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(Config.DrawTxtFont)
    SetTextProportional(0)
    SetTextScale(scale, scale)
	SetTextColour( 0,0,0, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(0, 0, 0, 0, 255)
    SetTextDropShadow()
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/1.255, y - height/1 + 0.374)
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local pos = GetEntityCoords(GetPlayerPed(-1))
				for _, item in pairs(Config.PedLocations) do
        			if (GetDistanceBetweenCoords(pos, item.x, item.y, item.z, true) < 3) then
						if PlayerData.job.name ~= Config.PoliceJob then
						drawOn(1.265, 1.562, 1.0,1.0,0.35, "~w~[E] " .. _U('trader_npc'), 255, 255, 255, 255)
            			DrawMarker(6, item.x, item.y, item.z - 1.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, false, 2, false, false, false, false)
            			if IsControlJustReleased(1, 38) then
							if item.type == "buy" then
							if not vasarlas then        
                				OpenShopMenu()
							else
								Notification(_U('buy_in_progress')) 
							end
						else
							if not eladas then 
								OpenSellMenu()
							else
								Notification(_U('sell_in_progress')) 
							end
						end
					end
				end
            end
		end
	end
end)

function OpenSellMenu()
    ESX.UI.Menu.CloseAll()
            
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'sell_menu',
        {
            title    = _U('trader_npc'),
            align    = 'center',
            elements = {
				{label = ("<span style='color: orange;'>%s</span>"):format(("1x Csomagolt Meth - ($"..Config.Prices.meth..")")), value = 'meth1'},
				{label = ("<span style='color: orange;'>%s</span>"):format(("1x Csomagolt Speed - ($"..Config.Prices.speed..")")), value = 'speed1'},
				{label = ("<span style='color: orange;'>%s</span>"):format(("1x Csomagolt Marihuana - ($"..Config.Prices.marihuana..")")), value = 'marihuana1'},
				{label = ("<span style='color: orange;'>%s</span>"):format(("1x Csomagolt Weed - ($"..Config.Prices.weed..")")), value = 'weed1'},
				{label = ("<span style='color: orange;'>%s</span>"):format(("1x Csomagolt LSD - ($"..Config.Prices.lsd..")")), value = 'lsd1'},
				{label = ("<span style='color: orange;'>%s</span>"):format(("1x Csomagolt Kokain - ($"..Config.Prices.kokain..")")), value = 'kokain1'},
				{label = ("<span style='color: red;'>%s</span>"):format(("Mégse")), value = 'cancel'}
            }
        },
        function(data, menu)
            if data.current.value == 'meth1' then
                TriggerServerEvent('dv_extradrugs:sellItem', "meth_packed", Config.Prices.meth)
				menu.close()
			elseif data.current.value == 'speed1' then
                TriggerServerEvent('dv_extradrugs:sellItem', "speed_packed", Config.Prices.speed)
				menu.close()
			elseif data.current.value == 'marihuana1' then
                TriggerServerEvent('dv_extradrugs:sellItem', "marihuana_packed", Config.Prices.marihuana)
				menu.close()
			elseif data.current.value == 'weed1' then
                TriggerServerEvent('dv_extradrugs:sellItem', "weed_packed", Config.Prices.weed)
				menu.close()
			elseif data.current.value == 'lsd1' then
				TriggerServerEvent('dv_extradrugs:sellItem', "lsd_packed", Config.Prices.lsd)
				menu.close()        
			elseif data.current.value == 'kokain1' then
                TriggerServerEvent('dv_extradrugs:sellItem', "kokain_packed", Config.Prices.kokain)
				menu.close()
			elseif data.current.value == 'cancel' then
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1))
		if PlayerData.job.name ~= Config.PoliceJob then
			for _, item2 in pairs(Config.BrewingLocations) do
			if (GetDistanceBetweenCoords(pos, item2.x, item2.y, item2.z, true) < 1.5) and not (GetDistanceBetweenCoords(pos, tablePozi, true) < 1.5) then
				drawOn(1.235, 1.542, 1.0,1.0,0.35, "~w~[E] " .. _U('brewing') .." | [H] ".. _U('packing') .." | [G] ".. _U('craft'), 255, 255, 255, 255)
				DrawMarker(6, item2.x, item2.y, item2.z - 1.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, false, 2, false, false, false, false)
				if IsControlJustReleased(1, 38) then    
					if not menuben then      
					OpenBrewingMenu()
					end
				end
				if IsControlJustReleased(1, 74) then       
					if not menuben then   
					OpenBoxingMenu()
					end
				end
				if IsControlJustReleased(1, 113) then      
					if not menuben then  
					OpenCraftingMenu()
				end
			end
			elseif (GetDistanceBetweenCoords(pos, tablePozi, true) < 1.5) then
				drawOn(1.205, 1.542, 1.0,1.0,0.35, "~w~[E] " .. _U('brewing') .." | [H] ".. _U('packing') .." | [G] ".. _U('craft').." | [X] " .. _U('destroy'), 255, 255, 255, 255)
				DrawMarker(6, item2.x, item2.y, item2.z - 1.0, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 0, 0, 100, false, false, 2, false, false, false, false)
				if IsControlJustReleased(1, 38) then    
					if not menuben then      
					OpenBrewingMenu()
					end
				end
				if IsControlJustReleased(1, 74) then       
					if not menuben then   
					OpenBoxingMenu()
					end
				end
				if IsControlJustReleased(1, 113) then      
					if not menuben then  
					OpenCraftingMenu()
					end
				end
				if IsControlJustReleased(1, 105) then      
					if not menuben then  
						FreezeEntityPosition(prop2, false)
						DeleteObject(prop2)
						tablePozi = 1.0, 1.0, 1.0
						placed = false
						TriggerServerEvent('dv_extradrugs:giveItemToPlayer', "table", 1)
						ESX.UI.Menu.CloseAll()
					end
				end
			end
		  end
		end
	  end
  end)

function OpenCraftingMenu()
	ESX.UI.Menu.CloseAll()
            
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'crafting_menu',
        {
            title    = _U('menu_crafting'),
            align    = 'center',
            elements = {
				{label = ("<span style='color: yellow;'>%s</span>"):format(("Zsacskó - (4x Papír)")), value = 'box'},
				{label = ("<span style='color: red;'>%s</span>"):format(("Mégse")), value = 'cancel'}
            }
        },
        function(data, menu)
            if data.current.value == 'box' then
                TriggerServerEvent('dv_extradrugs:craftBox')
				menu.close()
			elseif data.current.value == 'cancel' then
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenBoxingMenu()
	ESX.UI.Menu.CloseAll()
            
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'boxing_menu',
        {
            title    = _U('menu_packing'),
            align    = 'center',
            elements = {
				{label = ("<span style='color: yellow;'>%s</span>"):format(("Csomagolt Meth - (10x Meth, 1x Zsacskó)")), value = 'meth2'},
				{label = ("<span style='color: yellow;'>%s</span>"):format(("Csomagolt Speed - (10x Speed, 1x Zsacskó)")), value = 'speed2'},
				{label = ("<span style='color: yellow;'>%s</span>"):format(("Csomagolt Marihuana - (10x Marihuana, 1x Zsacskó)")), value = 'marihuana2'},
				{label = ("<span style='color: yellow;'>%s</span>"):format(("Csomagolt Weed - (10x Weed, 1x Zsacskó)")), value = 'weed2'},
				{label = ("<span style='color: yellow;'>%s</span>"):format(("Csomagolt LSD - (10x LSD, 1x Zsacskó)")), value = 'lsd2'},
				{label = ("<span style='color: yellow;'>%s</span>"):format(("Csomagolt Kokain - (10x Kokain, 1x Zsacskó)")), value = 'kokain2'},
				{label = ("<span style='color: red;'>%s</span>"):format(("Mégse")), value = 'cancel'}
            }
        },
        function(data, menu)
            if data.current.value == 'meth2' then
                TriggerServerEvent('dv_extradrugs:pack', "use_meth")
				menu.close()
			elseif data.current.value == 'speed2' then
				TriggerServerEvent('dv_extradrugs:pack', "use_speed")
				menu.close()
			elseif data.current.value == 'marihuana2' then
				TriggerServerEvent('dv_extradrugs:pack', "use_marihuana")
				menu.close()
			elseif data.current.value == 'weed2' then
				TriggerServerEvent('dv_extradrugs:pack', "use_weed")
				menu.close()
			elseif data.current.value == 'lsd2' then
				TriggerServerEvent('dv_extradrugs:pack', "use_lsd")
				menu.close()
			elseif data.current.value == 'kokain2' then
				TriggerServerEvent('dv_extradrugs:pack', "use_kokain")
				menu.close()
			elseif data.current.value == 'cancel' then
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenBrewingMenu()
	ESX.UI.Menu.CloseAll()
            
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'brewing_menu',
        {
            title    = _U('menu_brewing'),
            align    = 'center',
            elements = {
				{label = ("<span style='color: #34d9eb;'>%s</span>"):format(("Meth - (3x Cannabis Cserje, 1x Higitó, 2x Acetone, 2x Ammonia)")), value = 'cannabis'},
				{label = ("<span style='color: #34d9eb;'>%s</span>"):format(("Speed - (2x Speed Cserje, 1x Higitó, 2x Cukor, 3x Energia Ital, 4x Acetone)")), value = 'speed'},
				{label = ("<span style='color: #34d9eb;'>%s</span>"):format(("Marihuana - (1x Higitó, 5x Marihuana Cserje, 3x Alkohol)")), value = 'marihuana'},
				{label = ("<span style='color: #34d9eb;'>%s</span>"):format(("Weed - (4x Fű, 3x Ammonia)")), value = 'weed'},
				{label = ("<span style='color: #34d9eb;'>%s</span>"):format(("LSD - (1x Higitó, 4x Energia Ital, 3x Acetone)")), value = 'lsd'},
				{label = ("<span style='color: #34d9eb;'>%s</span>"):format(("Kokain - (5x Kokain Cserje, 7x Energia Ital, 1x Alkohol, 7x Acetone)")), value = 'kokain'},
				{label = ("<span style='color: red;'>%s</span>"):format(("Mégse")), value = 'cancel'}
            }
        },
        function(data, menu)
            if data.current.value == 'cannabis' then
                TriggerServerEvent('dv_extradrugs:process', "cannabis")
				menu.close()
			elseif data.current.value == 'speed' then
				TriggerServerEvent('dv_extradrugs:process', "speed")
				menu.close()
			elseif data.current.value == 'marihuana' then
				TriggerServerEvent('dv_extradrugs:process', "marihuana")
				menu.close()
			elseif data.current.value == 'weed' then
				TriggerServerEvent('dv_extradrugs:process', "weed")
				menu.close()
			elseif data.current.value == 'lsd' then
				TriggerServerEvent('dv_extradrugs:process', "lsd")
				menu.close()
			elseif data.current.value == 'kokain' then
				TriggerServerEvent('dv_extradrugs:process', "kokain")
				menu.close()
			elseif data.current.value == 'cancel' then
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenShopMenu()
    ESX.UI.Menu.CloseAll()
            
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'shop_menu',
        {
            title    = _U('trader_npc'),
            align    = 'center',
            elements = {
                {label = 'Csoda mag ($'.. Config.SeedPrice.. ')', value = 'seed'},
				{label = ("<span style='color: red;'>%s</span>"):format(("Mégse")), value = 'cancel'}
            }
        },
        function(data, menu)
            if data.current.value == 'seed' then
                TriggerServerEvent('dv_extradrugs:buySeed')
				menu.close()
			elseif data.current.value == 'cancel' then
                menu.close()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.40, 0.40)
    SetTextFont(Config.DrawTxtFont)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 0
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
	if Config.EnableInfoBlips then 
    	for _, info in pairs(Config.Blipek) do
        	info.blip = AddBlipForCoord(info.x, info.y, info.z)
        	SetBlipSprite(info.blip, info.id)
        	SetBlipDisplay(info.blip, 4)
        	SetBlipScale(info.blip, 0.8)
        	SetBlipColour(info.blip, info.color)
        	SetBlipAsShortRange(info.blip, true)
	    	BeginTextCommandSetBlipName("STRING")
        	AddTextComponentString(info.title)
        	EndTextCommandSetBlipName(info.blip)
    	end
	end
end)

Citizen.CreateThread(function()
    RequestModel(GetHashKey(Config.PedModel))
	
    while not HasModelLoaded(GetHashKey(Config.PedModel)) do
        Wait(1)
    end
	
	for _, item in pairs(Config.PedLocations) do
		local npc = CreatePed(4, 0xdb134533, item.x, item.y, item.z-1.0, item.heading, false, true)
			
		FreezeEntityPosition(npc, true)	
		SetEntityHeading(npc, item.heading)
		SetEntityInvincible(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if jumping then 
	   		SetSuperJumpThisFrame(PlayerId())
	   		Wait(1)
		end
	end
end)

RegisterNetEvent('dv_extradrugs:effect')
AddEventHandler('dv_extradrugs:effect', function(type)
	local ped = PlayerPedId()
	local health = GetEntityMaxHealth(ped)
	local dieErtek = math.random(1,100)
	if dieErtek > Config.DieRate then
		if type == "speed" then 
			if Effects.Speed.speed ~= false then 
    			SetRunSprintMultiplierForPlayer(PlayerId(),Effects.Speed.speed)
			end
			if Effects.Speed.screenEffect ~= false then 
    			effect()
			end
			if Effects.Speed.changeGravity ~= false then 
    			SetGravityLevel(3)
			end
			if Effects.Speed.heal ~= false then 
    			SetEntityHealth(ped, health)
			end
			if Effects.Speed.armor ~= false then 
    			AddArmourToPed(ped, Effects.Speed.armor)
			end
			Citizen.Wait(Effects.Speed.duration)
			pauseEffect()
		elseif type == "lsd" then
			if Effects.Lsd.speed ~= false then 
    			SetRunSprintMultiplierForPlayer(PlayerId(),Effects.Lsd.speed)
			end
			if Effects.Lsd.screenEffect ~= false then 
    			effect()
			end
			if Effects.Lsd.changeGravity ~= false then 
    			SetGravityLevel(3)
			end
			if Effects.Lsd.heal ~= false then 
    			SetEntityHealth(ped, health)
			end
			if Effects.Lsd.armor ~= false then 
    			AddArmourToPed(ped, Effects.Lsd.armor)
			end
			Citizen.Wait(Effects.Lsd.duration)
			pauseEffect()
		elseif type == "marihuana" then
			if Effects.Marihuana.speed ~= false then 
    			SetRunSprintMultiplierForPlayer(PlayerId(),Effects.Marihuana.speed)
			end
			if Effects.Marihuana.screenEffect ~= false then 
    			effect()
			end
			if Effects.Marihuana.changeGravity ~= false then 
    			SetGravityLevel(3)
			end
			if Effects.Marihuana.heal ~= false then 
    			SetEntityHealth(ped, health)
			end
			if Effects.Marihuana.armor ~= false then 
    			AddArmourToPed(ped, Effects.Marihuana.armor)
			end
			Citizen.Wait(Effects.Marihuana.duration)
			pauseEffect()
		elseif type == "meth" then
			if Effects.Meth.speed ~= false then 
    			SetRunSprintMultiplierForPlayer(PlayerId(),Effects.Meth.speed)
			end
			if Effects.Meth.screenEffect ~= false then 
    			effect()
			end
			if Effects.Meth.changeGravity ~= false then 
    			SetGravityLevel(3)
			end
			if Effects.Meth.heal ~= false then 
    			SetEntityHealth(ped, health)
			end
			if Effects.Meth.armor ~= false then 
    			AddArmourToPed(ped, Effects.Meth.armor)
			end
			Citizen.Wait(Effects.Meth.duration)
			pauseEffect()
		elseif type == "weed" then
			if Effects.Weed.speed ~= false then 
    			SetRunSprintMultiplierForPlayer(PlayerId(),Effects.Weed.speed)
			end
			if Effects.Weed.screenEffect ~= false then 
    			effect()
			end
			if Effects.Weed.changeGravity ~= false then 
    			SetGravityLevel(3)
			end
			if Effects.Weed.heal ~= false then 
    			SetEntityHealth(ped, health)
			end
			if Effects.Weed.armor ~= false then 
    			AddArmourToPed(ped, Effects.Weed.armor)
			end
			Citizen.Wait(Effects.Weed.duration)
			pauseEffect()
		elseif type == "kokain" then
			if Effects.Kokain.speed ~= false then 
				SetRunSprintMultiplierForPlayer(PlayerId(),Effects.Kokain.speed)
		 	end
		 	if Effects.Kokain.screenEffect ~= false then 
				effect()
			end
		 	if Effects.Kokain.changeGravity ~= false then 
				SetGravityLevel(3)
		 	end
		 	if Effects.Kokain.heal ~= false then 
				SetEntityHealth(ped, health)
		 	end
		 	if Effects.Kokain.armor ~= false then 
				AddArmourToPed(ped, Effects.Kokain.armor)
		 	end
			Citizen.Wait(Effects.Kokain.duration)
			pauseEffect()
		end
	else 
		SetEntityHealth(PlayerPedId(), 0)
		TriggerServerEvent('dv_extradrugs:die')
		pauseEffect()
		Notification(_U('use_failed'))
	end
end)

function effect()
	local playerPed = GetPlayerPed(-1)
	local playerPed = PlayerPedId()
	RequestAnimSet("MOVE_M@QUICK") 
    while not HasAnimSetLoaded("MOVE_M@QUICK") do
      Citizen.Wait(0)
    end    
	Wait(0)
	ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "MOVE_M@QUICK", true)
    SetPedIsDrunk(playerPed, true)
    AnimpostfxPlay("DrugsMichaelAliensFight", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 3.0)
end

RegisterNetEvent('dv_extradrugs:clear')
AddEventHandler('dv_extradrugs:clear', function()
	pauseEffect()
end)

function pauseEffect()
	local player = PlayerId()
    local playerPed = GetPlayerPed(-1)
	SetPedMoveRateOverride(PlayerId(),1.0)
    SetRunSprintMultiplierForPlayer(PlayerId(),1.0)
    SetPedIsDrunk(GetPlayerPed(-1), false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(GetPlayerPed(-1))
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
	SetGravityLevel(0)
	ClearPedTasksImmediately(playerPed)
	SetPedArmour(playerPed, 0)
end

---- peds

Citizen.CreateThread(function()
	Citizen.Wait(10000)
	RequestModel(Config.PedModel)
	while not HasModelLoaded(Config.PedModel) do
		Wait(500)
	end
end)

Citizen.CreateThread(function()
	Citizen.Wait(25000)
		for _, item in pairs(Config.PedLocations) do
			local npc = CreatePed(4, GetHashKey(Config.PedModel), item.x, item.y, item.z-1.0, item.heading, false, true)
			FreezeEntityPosition(npc, true)	
			SetEntityHeading(npc, item.heading)
			SetEntityInvincible(npc, true)
			SetBlockingOfNonTemporaryEvents(npc, true)
			RequestAnimDict("anim@amb@nightclub@peds@")
			while not HasAnimDictLoaded("anim@amb@nightclub@peds@") do
			Citizen.Wait(1000)
			end				
	        Citizen.Wait(200)
			TaskPlayAnim(npc,"anim@amb@nightclub@peds@","amb_world_human_stand_guard_male_base",1.0, 1.0, -1, 9, 1.0, 0, 0, 0)
		end
end)

function CreateBlip(coords, text, sprite, color, scale)

	local blip = AddBlipForCoord(table.unpack(coords))

	SetBlipSprite(blip, sprite)
	SetBlipScale(blip, scale)
	SetBlipColour(blip, color)
	SetBlipAsShortRange(blip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandSetBlipName(blip)
	table.insert(JobBlips, blip)
end

Citizen.CreateThread(function()
	Citizen.Wait(25000)
	while true do
		Citizen.Wait(5)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local minDist = 1000
		local dist = 0

		for _, item in pairs(Config.PedLocations) do
			dist = GetDistanceBetweenCoords(coords, vector3(item.x, item.y, item.z), true)
			
			if dist < 5.2 then
				ESX.Game.Utils.DrawText3D({x = item.x, y = item.y, z = item.z+0.95}, item.name, 0.6, 0.7)
			end
			
			if dist < minDist then minDist = dist end
		end
		
		if minDist > 10 then
			Citizen.Wait(minDist*10)
		end
	end
end)
