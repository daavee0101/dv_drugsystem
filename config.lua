Config = {}

Config.SharedObject = 'esx:getSharedObject'

Config.EnableLog = true
Config.WebhookImg = "https://i.imgur.com/CyFGInF.png"
Config.Webhook = "webhook"

Config.Locale = "en"

Config.EnableBlips = true
Config.EnableInfoBlips = true

Config.PoliceJob = "police"
Config.AlertCops = true
Config.DirtyCash = "black_money"
Config.UseDirtyMoney = true

Config.UseProp = true -- true = Prop | false = DrawMarker
Config.EnableTable = true -- true = players can place workbench for crafting | false = they can't do this 

Config.SeedPrice = 75
Config.GrowingDuration = 500 -- time in ms (1000 = (1 sec = 1%))
Config.EffectDuration = 50000 -- time in ms
Config.DieRate = 5 -- when you use drugs character can die, you can change the dieRate (1-100) or if you want use just set to 0

Config.PedModel = "s_m_y_blackops_02"

Config.DrawTxtFont = 4

Config.FarmLocations = {
    { x = 5343.31, y = -5227.26, z = 31.63 }
}

Config.BrewingLocations = {
    { x = 2434.06, y = 4968.75, z = 42.35 }
}

Config.PedLocations = {
	{ x = -1933.62, y = 2039.38, z = 140.83, heading = 209.22, type = "buy", name = "~g~NPC SELLER"},
    { x = -1169.01, y = -1573.48, z = 4.66, heading = 127.3, type = "sell", name = "~r~NPC BUYER" }
}

Config.Prices = {
    meth = 72,
    speed = 81,
    marihuana = 55,
    weed = 69,
    lsd = 85,
    kokain = 109 
}

Config.Blipek = {
    {title = "Illegal Trader | Buy", color = 43, id = 480, x = -1933.62, y = 2039.38, z = 140.83},
    {title = "Illegál Trader | Sell", color = 51, id = 480, x = -1169.01, y = -1573.48, z = 4.66},
    {title = "Brewing Location", color = 43, id = 499, x = 2434.06, y = 4968.75, z = 42.35},
    {title = "Farm", color = 46, id = 478, x = 5343.31, y = -5227.26, z = 31.63}
}

function Notification(msg)
    --- YOUR CODE FOR NOTIFY ---
	ESX.ShowNotification(msg)

    --- FOR EXAMPLE ---
    -- mythic_notify ()
    --exports['mythic_notify']:SendAlert('inform', msg)
end
