ARPCore = nil
TriggerEvent('ARPCore:GetObject', function(obj) ARPCore = obj end)

-- Code

RegisterServerEvent('arp-planeshop:server:SetBerthVehicle')
AddEventHandler('arp-planeshop:server:SetBerthVehicle', function(BerthId, vehicleModel)
    TriggerClientEvent('arp-planeshop:client:SetBerthVehicle', -1, BerthId, vehicleModel)
    
    ARPAeroshop.Locations["berths"][BerthId]["aeroModel"] = aeroModel
end)

RegisterServerEvent('arp-planeshop:server:SetHangarInUse')
AddEventHandler('arp-planeshop:server:SetHangarInUse', function(BerthId, InUse)
    ARPAeroshop.Locations["berths"][BerthId]["inUse"] = InUse
    TriggerClientEvent('arp-planeshop:client:SetHangarInUse', -1, BerthId, InUse)
end)

ARPCore.Functions.CreateCallback('arp-planeshop:server:GetBusyHangars', function(source, cb)
    cb(ARPAeroshop.Locations["berths"])
end)

RegisterServerEvent('arp-planeshop:server:BuyAero')
AddEventHandler('arp-planeshop:server:BuyAero', function(aeroModel, BerthId)
    local AeroPrice = ARPAeroshop.ShopPlanes[aeroModel]["price"]
    local src = source
    local Player = ARPCore.Functions.GetPlayer(src)
    local PlayerMoney = {
        cash = Player.PlayerData.money.cash,
        bank = Player.PlayerData.money.bank,
    }
    local missingMoney = 0
    local plate = "ARP"..math.random(1111, 9999)

    if PlayerMoney.cash >= AeroPrice then
        Player.Functions.RemoveMoney('cash', AeroPrice, "bought-aero")
        TriggerClientEvent('arp-planeshop:client:BuyAero', src, aeroModel, plate)
        InsertPlane(aeroModel, Player, plate)
    elseif PlayerMoney.bank >= AeroPrice then
        Player.Functions.RemoveMoney('bank', AeroPrice, "bought-aero")
        TriggerClientEvent('arp-planeshop:client:BuyAero', src, aeroModel, plate)
        InsertPlane(aeroModel, Player, plate)
    else
        if PlayerMoney.bank > PlayerMoney.cash then
            missingMoney = (AeroPrice - PlayerMoney.bank)
        else
            missingMoney = (AeroPrice - PlayerMoney.cash)
        end
        TriggerClientEvent('ARPCore:Notify', src, 'You dont have enough money, you miss $'..missingMoney, 'error', 4000)
    end
end)

function InsertPlane(aeroModel, Player, plate)
    ARPCore.Functions.ExecuteSql(false, "INSERT INTO `player_planes` (`citizenid`, `model`, `plate`) VALUES ('"..Player.PlayerData.citizenid.."', '"..aeroModel.."', '"..plate.."')")
end

RegisterServerEvent('arp-planeshop:server:RemoveItem')
AddEventHandler('arp-planeshop:server:RemoveItem', function(item, amount)
    local src = source
    local Player = ARPCore.Functions.GetPlayer(src)

    Player.Functions.RemoveItem(item, amount)
end)

ARPCore.Functions.CreateCallback('arp-planeshop:server:GetMyPlanes', function(source, cb, dock)
    local src = source
    local Player = ARPCore.Functions.GetPlayer(src)

    ARPCore.Functions.ExecuteSql(false, "SELECT * FROM `player_planes` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `planehouse` = '"..dock.."'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

ARPCore.Functions.CreateCallback('arp-planeshop:server:GetDepotPlanes', function(source, cb, dock)
    local src = source
    local Player = ARPCore.Functions.GetPlayer(src)

    ARPCore.Functions.ExecuteSql(false, "SELECT * FROM `player_planes` WHERE `citizenid` = '"..Player.PlayerData.citizenid.."' AND `state` = '0'", function(result)
        if result[1] ~= nil then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('arp-planeshop:server:SetPlanestate')
AddEventHandler('arp-planeshop:server:SetPlanestate', function(plate, state, planehouse)
    local src = source
    local Player = ARPCore.Functions.GetPlayer(src)
    ARPCore.Functions.ExecuteSql(false, "SELECT * FROM `player_planes` WHERE `plate` = '"..plate.."'", function(result)
        if result[1] ~= nil then
            ARPCore.Functions.ExecuteSql(false, "UPDATE `player_planes` SET `state` = '"..state.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
    
            if state == 1 then
                ARPCore.Functions.ExecuteSql(false, "UPDATE `player_planes` SET `planehouse` = '"..planehouse.."' WHERE `plate` = '"..plate.."' AND `citizenid` = '"..Player.PlayerData.citizenid.."'")
            end
        end
    end)
end)