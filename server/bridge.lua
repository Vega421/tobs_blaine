-- vRP bridge (server). Everything framework-specific lives here; the heist itself is in server/main.lua.

local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

Bridge = {Repo = "Vega421/tobs_blaine"}

function Bridge.IsPolice(src)
    local user_id = vRP.getUserId({src})
    return user_id ~= nil and vRP.hasGroup({user_id, TOB.PoliceGroup})
end

function Bridge.CountPolice()
    local count = 0
    for user_id, _ in pairs(vRP.getUsers({})) do
        if vRP.hasGroup({user_id, TOB.PoliceGroup}) then count = count + 1 end
    end
    return count
end

function Bridge.HasItem(src, item, count)
    local user_id = vRP.getUserId({src})
    return user_id ~= nil and vRP.getInventoryItemAmount({user_id, item}) >= count
end

function Bridge.RemoveItem(src, item, count)
    local user_id = vRP.getUserId({src})
    if user_id ~= nil then vRP.tryGetInventoryItem({user_id, item, count}) end
end

function Bridge.AddItem(src, item, count)
    local user_id = vRP.getUserId({src})
    if user_id ~= nil then vRP.giveInventoryItem({user_id, item, count}) end
end

function Bridge.AddMoney(src, amount, dirty)
    local user_id = vRP.getUserId({src})
    if user_id == nil then return end
    if dirty then
        vRP.giveInventoryItem({user_id, TOB.blackmoney, amount})
    else
        vRP.giveMoney({user_id, amount})
    end
end

function Bridge.RegisterCallback(name, fn)
    TOBBlaine.RegisterServerCallback(name, fn)
end

-- Tells each player whether they're police (vRP has no client-side job data)
RegisterServerEvent('TOB_fh:CheckCop')
AddEventHandler('TOB_fh:CheckCop', function()
    local _source = source

    if Bridge.IsPolice(_source) then
        TriggerClientEvent('TOB_fh:IsCop', _source)
    else
        TriggerClientEvent('TOB_fh:IsNOTCop', _source)
    end
end)
