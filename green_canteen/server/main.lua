VORP = exports.vorp_inventory:vorp_inventoryApi()



Citizen.CreateThread(function()
	Citizen.Wait(2000)
	VORP.RegisterUsableItem("canteenempty", function(data)
		TriggerClientEvent('green:StartFilling', data.source)
	end)
end)


Citizen.CreateThread(function()
    local item2 = "canteenempty"
	Citizen.Wait(2000)
	VORP.RegisterUsableItem("canteen", function(data)
		VORP.subItem(data.source, "canteen", 1)
        VORP.addItem(data.source, item2, 1)
		TriggerClientEvent('green:drink', data.source)
	end)
end)



RegisterNetEvent("fillup")
AddEventHandler("fillup", function()
    local item = "canteen"
    local r = 1
    local _source = source 
    if r then
		VORP.subItem(_source, "canteenempty", 1)
        VORP.addItem(_source, item, 1)
        TriggerClientEvent("vorp:TipBottom", _source, Config.fullup, 6000)
    end
end)

