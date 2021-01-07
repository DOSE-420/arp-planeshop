ARPCore = nil

local CurrentHangar = nil
local ClosestHangar = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if ARPCore == nil then
            TriggerEvent('ARPCore:GetObject', function(obj) ARPCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

Citizen.CreateThread(function()
    while true do

        local inRange = false
        local ped = GetPlayerPed(-1)
        local Pos = GetEntityCoords(ped)

        for k, v in pairs(ARPAeroshop.Hangars) do
            local TakeDistance = GetDistanceBetweenCoords(Pos, v.coords.take.x, v.coords.take.y, v.coords.take.z)

            if TakeDistance < 50 then
                ClosestHangar = k
                inRange = true
                PutDistance = GetDistanceBetweenCoords(Pos, v.coords.put.x, v.coords.put.y, v.coords.put.z)

                local inPlane = IsPedInAnyPlane(ped)

                if inPlane then
                    DrawMarker(35, v.coords.put.x, v.coords.put.y, v.coords.put.z + 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.7, 1.7, 1.7, 255, 55, 15, 255, false, false, false, true, false, false, false)
                    if PutDistance < 2 then
                        if inPlane then
                            DrawText3D(v.coords.put.x, v.coords.put.y, v.coords.put.z, '[E] - Put Aircraft')
                            if IsControlJustPressed(0, Keys["E"]) then
                                RemoveVehicle()
                            end
                        end
                    end
                end

                if not inPlane then
                    DrawMarker(2, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
                    if TakeDistance < 2 then
                        DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, '[E] - Take Plane')
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            CloseMenu()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            CurrentHangar = nil
                        elseif IsControlJustPressed(0, Keys["E"]) and Menu.hidden then
                            MenuGarage()
                            Menu.hidden = not Menu.hidden
                            CurrentHangar = k
                        end
                        Menu.renderGUI()
                    end
                end
            elseif TakeDistance > 51 then
                if ClosestHangar ~= nil then
                    ClosestHangar = nil
                end
            end
        end

        for k, v in pairs(ARPAeroshop.Depots) do
            local TakeDistance = GetDistanceBetweenCoords(Pos, v.coords.take.x, v.coords.take.y, v.coords.take.z)

            if TakeDistance < 50 then
                ClosestHangar = k
                inRange = true
                PutDistance = GetDistanceBetweenCoords(Pos, v.coords.put.x, v.coords.put.y, v.coords.put.z)

                local inPlane = IsPedInAnyPlane(Ped)

                if not inPlane then
                    DrawMarker(2, v.coords.take.x, v.coords.take.y, v.coords.take.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.5, -0.30, 15, 255, 55, 255, false, false, false, true, false, false, false)
                    if TakeDistance < 2 then
                        DrawText3D(v.coords.take.x, v.coords.take.y, v.coords.take.z, '[E] - Aircraft Depot')
                        if IsControlJustPressed(1, 177) and not Menu.hidden then
                            CloseMenu()
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            CurrentHangar = nil
                        elseif IsControlJustPressed(0, Keys["E"]) and Menu.hidden then
                            MenuPlaneDepot()
                            Menu.hidden = not Menu.hidden
                            CurrentHangar = k
                        end
                        Menu.renderGUI()
                    end
                end
            elseif TakeDistance > 51 then
                if ClosestHangar ~= nil then
                    ClosestHangar = nil
                end
            end
        end

        if not inRange then
            Citizen.Wait(1000)
        end

        Citizen.Wait(4)
    end
end)

function RemoveVehicle()
    local ped = GetPlayerPed(-1)
    local Plane = IsPedInAnyPlane(ped)

    if Plane then
        local CurVeh = GetVehiclePedIsIn(ped)

        TriggerServerEvent('arp-planeshop:server:SetPlaneState', GetVehicleNumberPlateText(CurVeh), 1, ClosestHangar)

        ARPCore.Functions.DeleteVehicle(CurVeh)
        SetEntityCoords(ped, ARPAeroshop.Hangars[ClosestHangar].coords.take.x, ARPAeroshop.Hangars[ClosestHangar].coords.take.y, ARPAeroshop.Hangars[ClosestHangar].coords.take.z)
    end
end

Citizen.CreateThread(function()
    for k, v in pairs(ARPAeroshop.Hangars) do
        HangarGarage = AddBlipForCoord(v.coords.put.x, v.coords.put.y, v.coords.put.z)

        SetBlipSprite (HangarGarage, 455)
        SetBlipDisplay(HangarGarage, 4)
        SetBlipScale  (HangarGarage, 0.7)
        SetBlipAsShortRange(HangarGarage, true)
        SetBlipColour(HangarGarage, 53)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(HangarGarage)
    end

    for k, v in pairs(ARPAeroshop.Depots) do
        PlaneDepot = AddBlipForCoord(v.coords.take.x, v.coords.take.y, v.coords.take.z)

        SetBlipSprite (PlaneDepot, 427)
        SetBlipDisplay(PlaneDepot, 4)
        SetBlipScale  (PlaneDepot, 0.7)
        SetBlipAsShortRange(PlaneDepot, true)
        SetBlipColour(PlaneDepot, 3)
    
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(v.label)
        EndTextCommandSetBlipName(PlaneDepot)
    end
end)

-- MENU JAAAAAAAAAAAAAA

function MenuPlaneDepot()
    ClearMenu()
    ARPCore.Functions.TriggerCallback("arp-planeshop:server:GetDepotPlanes", function(result)
        ped = GetPlayerPed(-1);
        MenuTitle = "My Vehicles :"

        if result == nil then
            ARPCore.Functions.Notify("You have no aircraft in this Depot.", "error", 5000)
            CloseMenu()
        else
            --Menu.addButton(ARPAeroshop.Depots[CurrentHangar].label, "yeet", ARPAeroshop.Depots[CurrentHangar].label)

            for k, v in pairs(result) do
                currentFuel = v.fuel
                state = "Planehouse"
                if v.state == 0 then
                    state = "Storage"
                end

                Menu.addButton(ARPAeroshop.ShopPlanes[v.model]["label"], "TakeOutDepotPlane", v, state, "Fuel: "..currentFuel.. "%")
            end
        end
            
        Menu.addButton("Back", "MenuGarage", nil)
    end)
end

function VoertuigLijst()
    ClearMenu()
    ARPCore.Functions.TriggerCallback("arp-planeshop:server:GetMyPlanes", function(result)
        ped = GetPlayerPed(-1);
        MenuTitle = "My Vehicles :"

        if result == nil then
            ARPCore.Functions.Notify("You have no vehicles in this Aircraft Hangar.", "error", 5000)
            CloseMenu()
        else
            Menu.addButton(ARPAeroshop.Hangars[CurrentHangar].label, "yeet", ARPAeroshop.Hangars[CurrentHangar].label)

            for k, v in pairs(result) do
                currentFuel = v.fuel
                state = "Planehouse"
                if v.state == 0 then
                    state = "from"
                end

                Menu.addButton(ARPAeroshop.ShopPlanes[v.model]["label"], "TakeOutVehicle", v, state, "Fuel: "..currentFuel.. "%")
            end
        end
            
        Menu.addButton("Back", "MenuGarage", nil)
    end, CurrentHangar)
end

function TakeOutVehicle(vehicle)
    if vehicle.state == 1 then
        ARPCore.Functions.SpawnVehicle(vehicle.model, function(veh)
            SetVehicleNumberPlateText(veh, vehicle.plate)
            SetEntityHeading(veh, ARPAeroshop.Hangars[CurrentHangar].coords.put.h)
            exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
            ARPCore.Functions.Notify("Vehicle Off: Fuel: "..currentFuel.. "%", "primary", 4500)
            CloseMenu()
            TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
            TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
            SetVehicleEngineOn(veh, true, true)
            TriggerServerEvent('arp-planeshop:server:SetPlaneState', GetVehicleNumberPlateText(veh), 0, CurrentHangar)
        end, ARPAeroshop.Hangars[CurrentHangar].coords.put, true)
    else
        ARPCore.Functions.Notify("The Plane is not in the Planehouse", "error", 4500)
    end
end

function TakeOutDepotPlane(vehicle)
    ARPCore.Functions.SpawnVehicle(vehicle.model, function(veh)
        SetVehicleNumberPlateText(veh, vehicle.plate)
        SetEntityHeading(veh, ARPAeroshop.Depots[CurrentHangar].coords.put.h)
        exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
        ARPCore.Functions.Notify("Vehicle Off: Fuel: "..currentFuel.. "%", "primary", 4500)
        CloseMenu()
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, ARPAeroshop.Depots[CurrentHangar].coords.put, true)
end

function MenuGarage()
    ClearMenu()
    ped = GetPlayerPed(-1);
    MenuTitle = "Garage"
    Menu.addButton("My Vehicles", "VoertuigLijst", nil)
    Menu.addButton("Close Menu", "CloseMenu", nil) 
end

function CloseMenu()
    Menu.hidden = true
    ClearMenu()
end

function ClearMenu()
	Menu.GUI = {}
	Menu.buttonCount = 0
	Menu.selection = 0
end

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