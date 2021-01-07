ARPCore = nil

Keys = {
    ['ESC'] = 322, ['F1'] = 288, ['F2'] = 289, ['F3'] = 170, ['F5'] = 166, ['F6'] = 167, ['F7'] = 168, ['F8'] = 169, ['F9'] = 56, ['F10'] = 57,
    ['~'] = 243, ['1'] = 157, ['2'] = 158, ['3'] = 160, ['4'] = 164, ['5'] = 165, ['6'] = 159, ['7'] = 161, ['8'] = 162, ['9'] = 163, ['-'] = 84, ['='] = 83, ['BACKSPACE'] = 177,
    ['TAB'] = 37, ['Q'] = 44, ['W'] = 32, ['E'] = 38, ['R'] = 45, ['T'] = 245, ['Y'] = 246, ['U'] = 303, ['P'] = 199, ['['] = 39, [']'] = 40, ['ENTER'] = 18,
    ['CAPS'] = 137, ['A'] = 34, ['S'] = 8, ['D'] = 9, ['F'] = 23, ['G'] = 47, ['H'] = 74, ['K'] = 311, ['L'] = 182,
    ['LEFTSHIFT'] = 21, ['Z'] = 20, ['X'] = 73, ['C'] = 26, ['V'] = 0, ['B'] = 29, ['N'] = 249, ['M'] = 244, [','] = 82, ['.'] = 81,
    ['LEFTCTRL'] = 36, ['LEFTALT'] = 19, ['SPACE'] = 22, ['RIGHTCTRL'] = 70,
    ['HOME'] = 213, ['PAGEUP'] = 10, ['PAGEDOWN'] = 11, ['DELETE'] = 178,
    ['LEFT'] = 174, ['RIGHT'] = 175, ['TOP'] = 27, ['DOWN'] = 173,
}

local ClosestBerth = 1
local AeroSpawned = false
local ModelLoaded = true
local SpawnedAeros = {}
local Buying = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if ARPCore == nil then
            TriggerEvent('ARPCore:GetObject', function(obj) ARPCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

RegisterNetEvent("ARPCore:Client:OnPlayerLoaded")
AddEventHandler("ARPCore:Client:OnPlayerLoaded", function()
    ARPCore.Functions.TriggerCallback('arp-planeshop:server:GetBusyHangars', function(Hangars)
        ARPAeroshop.Locations["berths"] = Hangars
        end)
end)

Citizen.CreateThread(function()
    while true do
        local pos = GetEntityCoords(GetPlayerPed(-1), true)
        local BerthDist = GetDistanceBetweenCoords(pos, ARPAeroshop.Locations["berths"][1]["coords"]["aero"]["x"], ARPAeroshop.Locations["berths"][1]["coords"]["aero"]["y"], ARPAeroshop.Locations["berths"][1]["coords"]["aero"]["z"], false)

        if BerthDist < 100 then
            SetClosestBethAero()
            if not AeroSpawned then
                SpawnBethAeros()
            end
        elseif BerthDist > 110 then
            if AeroSpawned then
                AeroSpawned = false
            end
        end

        Citizen.Wait(1000)
    end
end)

function SpawnBethAeros()
    for loc,_ in pairs(ARPAeroshop.Locations["berths"]) do
        if SpawnedAeros[loc] ~= nil then
            ARPCore.Functions.DeleteVehicle(SpawnedAeros[loc])
        end
		local model = GetHashKey(ARPAeroshop.Locations["berths"][loc]["aeroModel"])
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(0)
		end

		local veh = CreateVehicle(model, ARPAeroshop.Locations["berths"][loc]["coords"]["aero"]["x"], ARPAeroshop.Locations["berths"][loc]["coords"]["aero"]["y"], ARPAeroshop.Locations["berths"][loc]["coords"]["aero"]["z"], false, false)

        SetModelAsNoLongerNeeded(model)
		SetVehicleOnGroundProperly(veh)
		SetEntityInvincible(veh,true)
        SetEntityHeading(veh, ARPAeroshop.Locations["berths"][loc]["coords"]["aero"]["h"])
        SetVehicleDoorsLocked(veh, 3)

		FreezeEntityPosition(veh,true)     
        SpawnedAeros[loc] = veh
    end
    AeroSpawned = true
end

function SetClosestBethAero()
    local pos = GetEntityCoords(GetPlayerPed(-1), true)
    local current = nil
    local dist = nil

    for id, veh in pairs(ARPAeroshop.Locations["berths"]) do
        if current ~= nil then
            if(GetDistanceBetweenCoords(pos, ARPAeroshop.Locations["berths"][id]["coords"]["buy"]["x"], ARPAeroshop.Locations["berths"][id]["coords"]["buy"]["y"], ARPAeroshop.Locations["berths"][id]["coords"]["buy"]["z"], true) < dist)then
                current = id
                dist = GetDistanceBetweenCoords(pos, ARPAeroshop.Locations["berths"][id]["coords"]["buy"]["x"], ARPAeroshop.Locations["berths"][id]["coords"]["buy"]["y"], ARPAeroshop.Locations["berths"][id]["coords"]["buy"]["z"], true)
            end
        else
            dist = GetDistanceBetweenCoords(pos, ARPAeroshop.Locations["berths"][id]["coords"]["buy"]["x"], ARPAeroshop.Locations["berths"][id]["coords"]["buy"]["y"], ARPAeroshop.Locations["berths"][id]["coords"]["buy"]["z"], true)
            current = id
        end
    end
    if current ~= ClosestBerth then
        ClosestBerth = current
    end
end

Citizen.CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)

        local inRange = false

        local distance = GetDistanceBetweenCoords(pos, ARPAeroshop.Locations["berths"][ClosestBerth]["coords"]["aero"]["x"], ARPAeroshop.Locations["berths"][ClosestBerth]["coords"]["aero"]["y"], ARPAeroshop.Locations["berths"][ClosestBerth]["coords"]["aero"]["z"], true)

        if distance < 15 then
            local BuyLocation = {
                x = ARPAeroshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["x"],
                y = ARPAeroshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["y"],
                z = ARPAeroshop.Locations["berths"][ClosestBerth]["coords"]["buy"]["z"]
            }

            DrawMarker(2, BuyLocation.x, BuyLocation.y, BuyLocation.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.5, 0.15, 255, 55, 15, 255, false, false, false, true, false, false, false)
            local BuyDistance = GetDistanceBetweenCoords(pos, BuyLocation.x, BuyLocation.y, BuyLocation.z, true)

            if BuyDistance < 2 then                
                local currentAero = ARPAeroshop.Locations["berths"][ClosestBerth]["aeroModel"]

                DrawMarker(2, ARPAeroshop.Locations["berths"][ClosestBerth]["coords"]["aero"]["x"], ARPAeroshop.Locations["berths"][ClosestBerth]["coords"]["aero"]["y"], ARPAeroshop.Locations["berths"][ClosestBerth]["coords"]["aero"]["z"] + 1.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)

                if not Buying then
                    DrawText3D(BuyLocation.x, BuyLocation.y, BuyLocation.z + 0.3, '[E] - Buy '..ARPAeroshop.ShopPlanes[currentAero]["label"]..' for ~b~$'..ARPAeroshop.ShopPlanes[currentAero]["price"])
                    if IsControlJustPressed(0, Keys["E"]) then
                        Buying = true
                    end
                else
                    DrawText3D(BuyLocation.x, BuyLocation.y, BuyLocation.z + 0.3, 'Are you sure? ~g~7~w~ Yes / ~r~8~w~ No ~b~($'..ARPAeroshop.ShopPlanes[currentAero]["price"]..')')
                    if IsControlJustPressed(0, Keys["7"]) or IsDisabledControlJustReleased(0, Keys["7"]) then
                        TriggerServerEvent('arp-planeshop:server:BuyAero', ARPAeroshop.Locations["berths"][ClosestBerth]["aeroModel"], ClosestBerth)
                        Buying = false
                    elseif IsControlJustPressed(0, Keys["8"]) or IsDisabledControlJustReleased(0, Keys["8"]) then
                        Buying = false
                    end
                end
            elseif BuyDistance > 2.5 then
                if Buying then
                    Buying = false
                end
            end
        end

        Citizen.Wait(3)
    end
end)

RegisterNetEvent('arp-planeshop:client:BuyAero')
AddEventHandler('arp-planeshop:client:BuyAero', function(aeroModel, plate)
    DoScreenFadeOut(250)
    Citizen.Wait(250)
    ARPCore.Functions.SpawnVehicle(aeroModel, function(veh)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, ARPAeroshop.SpawnVehicle.h)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
    end, ARPAeroshop.SpawnVehicle, false)
    SetTimeout(1000, function()
        DoScreenFadeIn(250)
    end)
end)

Citizen.CreateThread(function()
    AeroShop = AddBlipForCoord(ARPAeroshop.Locations["berths"][1]["coords"]["aero"]["x"], ARPAeroshop.Locations["berths"][1]["coords"]["aero"]["y"], ARPAeroshop.Locations["berths"][1]["coords"]["aero"]["z"])

    SetBlipSprite (AeroShop, 356)
    SetBlipDisplay(AeroShop, 4)
    SetBlipScale  (AeroShop, 0.8)
    SetBlipAsShortRange(AeroShop, true)
    SetBlipColour(AeroShop, 6)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Plane Shop")
    EndTextCommandSetBlipName(AeroShop)
end)

DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

