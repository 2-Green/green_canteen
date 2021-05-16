--credits to vorp_goldpanning

local entity
local Filling = false

local WaterTypes = {
    [1] =  {["name"] = "Sea of Coronado",       ["waterhash"] = -247856387, ["watertype"] = "lake"},
    [2] =  {["name"] = "San Luis River",        ["waterhash"] = -1504425495, ["watertype"] = "river"},
    [3] =  {["name"] = "Lake Don Julio",        ["waterhash"] = -1369817450, ["watertype"] = "lake"},
    [4] =  {["name"] = "Flat Iron Lake",        ["waterhash"] = -1356490953, ["watertype"] = "lake"},
    [5] =  {["name"] = "Upper Montana River",   ["waterhash"] = -1781130443, ["watertype"] = "river"},
    [6] =  {["name"] = "Owanjila",              ["waterhash"] = -1300497193, ["watertype"] = "river"},
    [7] =  {["name"] = "HawkEye Creek",         ["waterhash"] = -1276586360, ["watertype"] = "river"},
    [8] =  {["name"] = "Little Creek River",    ["waterhash"] = -1410384421, ["watertype"] = "river"},
    [9] =  {["name"] = "Dakota River",          ["waterhash"] = 370072007, ["watertype"] = "river"},
    [10] =  {["name"] = "Beartooth Beck",       ["waterhash"] = 650214731, ["watertype"] = "river"},
    [11] =  {["name"] = "Lake Isabella",        ["waterhash"] = 592454541, ["watertype"] = "lake"},
    [12] =  {["name"] = "Cattail Pond",         ["waterhash"] = -804804953, ["watertype"] = "lake"},
    [13] =  {["name"] = "Deadboot Creek",       ["waterhash"] = 1245451421, ["watertype"] = "river"},
    [14] =  {["name"] = "Spider Gorge",         ["waterhash"] = -218679770, ["watertype"] = "river"},
    [15] =  {["name"] = "O'Creagh's Run",       ["waterhash"] = -1817904483, ["watertype"] = "lake"},
    [16] =  {["name"] = "Moonstone Pond",       ["waterhash"] = -811730579, ["watertype"] = "lake"},
    [17] =  {["name"] = "Roanoke Valley",       ["waterhash"] = -1229593481, ["watertype"] = "river"},
    [18] =  {["name"] = "Elysian Pool",         ["waterhash"] = -105598602, ["watertype"] = "lake"},
	[19] =  {["name"] = "Heartland Overflow",   ["waterhash"] = 1755369577, ["watertype"] = "swamp"},
    [20] =  {["name"] = "Lagras",               ["waterhash"] = -557290573, ["watertype"] = "swamp"},
    [21] =  {["name"] = "Lannahechee River",    ["waterhash"] = -2040708515, ["watertype"] = "river"},
    [22] =  {["name"] = "Dakota River",         ["waterhash"] = 370072007, ["watertype"] = "river"},
    [23] =  {["name"] = "Random1",              ["waterhash"] = 231313522, ["watertype"] = "river"},
    [24] =  {["name"] = "Random2",              ["waterhash"] = 2005774838, ["watertype"] = "river"},
    [25] =  {["name"] = "Random3",              ["waterhash"] = -1287619521, ["watertype"] = "river"},
    [26] =  {["name"] = "Random4",              ["waterhash"] = -1308233316, ["watertype"] = "river"},
    [27] =  {["name"] = "Random5",              ["waterhash"] = -196675805, ["watertype"] = "river"},
}


RegisterNetEvent('green:StartFilling')
AddEventHandler('green:StartFilling', function()
    if not Filling then 
        Filling = true
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local Water = Citizen.InvokeNative(0x5BA7A68A346A5A91,coords.x, coords.y, coords.z)
        local foundwater = false
        for k,v in pairs(WaterTypes) do
            if Water == WaterTypes[k]["waterhash"]  then
                foundwater = true
                CrouchAnimAndAttach()
				TriggerEvent("vorp:TipRight", Config.fill_1, 500)
                Wait(6000)
                ClearPedTasks(ped)
                w = 1
                local seconds = w/1
                for i=1,seconds,1 do
                    Wait(335)
                end
                -- Wait(w)
                ClearPedTasks(ped)
                DeleteObject(entity)
                DeleteEntity(entity)
                TriggerServerEvent("fillup")
                break
            end
        end
        Filling = false
        if foundwater == false then
            TriggerEvent("vorp:TipRight", Config.cantfill, 10000)
        end
    end
end)

function CrouchAnimAndAttach()
    local dict = "script_rc@cldn@ig@rsc2_ig1_questionshopkeeper"
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end

    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local boneIndex = GetEntityBoneIndexByName(ped, "SKEL_R_HAND")
    local modelHash = GetHashKey("p_cs_canteen_hercule")
    LoadModel(modelHash)
    entity = CreateObject(modelHash, coords.x+0.3, coords.y,coords.z, true, false, false)
    SetEntityVisible(entity, true)
    SetEntityAlpha(entity, 255, false)
    Citizen.InvokeNative(0x283978A15512B2FE, entity, true)
    SetModelAsNoLongerNeeded(modelHash)
    AttachEntityToEntity(entity,ped, boneIndex, 0.1, 0.0, -0.2, -100.0, -50.0, 0.0, false, false, false, true, 2, true)

    TaskPlayAnim(ped, dict, "inspectfloor_player", 1.0, 8.0, -1, 1, 0, false, false, false)
end



function LoadModel(model)
    local attempts = 0
    while attempts < 100 and not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(10)
        attempts = attempts + 1
    end
    return IsModelValid(model)
end

RegisterNetEvent('green:drink')
AddEventHandler('green:drink', function()
TriggerEvent("vorpmetabolism:changeValue", "Thirst", 500)
drinkinganim()
end)

function drinkinganim()
    local ped = PlayerPedId()
    if IsPedMale(ped) then
        TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_DRINK_FLASK'), 10000, true, false, false, false)
        Wait(10000)
		TriggerEvent("vorp:TipRight", Config.drink_1, 500)
        ClearPedTasksImmediately(PlayerPedId())
    else
      -- FEMALE SCENARIO
	    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_DRINKING'), 10000, true, false, false, false)
        Wait(10000)
		TriggerEvent("vorp:TipRight", Config.drink_1, 500)
        ClearPedTasksImmediately(PlayerPedId())
    end
end