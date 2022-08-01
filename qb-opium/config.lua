Config = {}

Config.Locale = 'en'

Config.Delays = {
	ProcessOpium = 1000 * 1
}

Config.Pricesell = 1150

Config.MinPiecesWed = 1



Config.DrugDealerItems = {
	plastic_baggie = 91
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. 



Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	OpiumField = {coords = vector3(3265.01, -153.27, 18.6), name = 'blip_PickupOpium', color = 25, sprite = 496, radius = 30.0},
	OpiumProcessing = {coords = vector3(1208.68, -3115.82, 5.54), name = 'blip_ProcessOpium', color = 25, sprite = 496, radius = 100.0},
	DrugDealer = {coords = vector3(2461.11, 1589.51, 33.04), name = 'blip_DrugDealer', color = 6, sprite = 378, radius = 25.0},
}
