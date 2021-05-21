local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

HT = nil

TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)


ServerPlayers = true  
Doors = { 
    ["B1"] = {{loc = vector3(-105.15334320068,6472.7075195312,31.626728057861), h = 42.639282226562, txtloc = vector3(-105.34651184082,6472.708984375,31.626726150513), obj = nil, locked = false}, {loc = vector3(-105.84294891357,6475.4428710938,31.62670135498), txtloc = vector3(-105.84294891357,6475.4428710938,31.62670135498), obj = nil, locked = false}},
}



RegisterServerEvent("TOB_fh:startcheck")
AddEventHandler("TOB_fh:startcheck", function(bank)
    local _source = source
    local copcount = 0
    local Players = vRP.getUsers()

    for i = 1, #Players, 1 do
        local xPlayer = vRP.getUserId({Players[i]})
        if vRP.hasGroup({xPlayer, "Politi-Job"}) then
      --  if vRP.hasPermission({xPlayer, TOB.PolicePermission}) then
            copcount = copcount + 1
        end
    end
    local xPlayer = vRP.getUserId({_source})
    local item = vRP.getInventoryItemAmount({xPlayer,"id_card_f"})

    if copcount >= TOB.mincops then
        if item >= 1 then
            if not TOB.Banks[bank].onaction == true then
                if (os.time() - TOB.cooldown) > TOB.Banks[bank].lastrobbed then
                    TOB.Banks[bank].onaction = true
                    vRP.tryGetInventoryItem({xPlayer,"id_card_f",1})
                    TriggerClientEvent("TOB_fh:outcome", _source, true, bank)
                    TriggerClientEvent("TOB_fh:policenotify", -1, bank)
                else
                    TriggerClientEvent("TOB_fh:outcome", _source, false, "Denne bank er fornyligt været røveret du skal vente "..math.floor((TOB.cooldown - (os.time() - TOB.Banks[bank].lastrobbed)) / 60)..":"..math.fmod((TOB.cooldown - (os.time() - TOB.Banks[bank].lastrobbed)), 60))
                end
            else
                TriggerClientEvent("TOB_fh:outcome", _source, false, "Der er et røveri igang i banken.")
            end
        else
            TriggerClientEvent("TOB_fh:outcome", _source, false, "Du har ikke et idkort.")
        end
    else
        TriggerClientEvent("TOB_fh:outcome", _source, false, "Der er ikke nok Politi i byen.")
    end
end)

RegisterServerEvent("TOB_fh:lootup")
AddEventHandler("TOB_fh:lootup", function(var, var2)
    TriggerClientEvent("TOB_fh:lootup_c", -1, var, var2)
end)

RegisterServerEvent("TOB_fh:openDoor")
AddEventHandler("TOB_fh:openDoor", function(coords, method)
    TriggerClientEvent("TOB_fh:openDoor_c", -1, coords, method)
end)

RegisterServerEvent("TOB_fh:toggleDoor")
AddEventHandler("TOB_fh:toggleDoor", function(key, state)
    Doors[key][1].locked = state
    TriggerClientEvent("TOB_fh:toggleDoor", -1, key, state)
end)

RegisterServerEvent("TOB_fh:toggleVault")
AddEventHandler("TOB_fh:toggleVault", function(key, state)
    Doors[key][2].locked = state
    TriggerClientEvent("TOB_fh:toggleVault", -1, key, state)
end)

RegisterServerEvent("TOB_fh:updateVaultState")
AddEventHandler("TOB_fh:updateVaultState", function(key, state)
    Doors[key][2].state = state
end)

RegisterServerEvent("TOB_fh:startLoot")
AddEventHandler("TOB_fh:startLoot", function(data, name, players)
    local _source = source

    if ServerPlayers then
        TriggerClientEvent("TOB_fh:startLoot_c", data, name)
    end
    TriggerClientEvent("TOB_fh:startLoot_c", _source, data, name)
end)

RegisterServerEvent("TOB_fh:stopHeist")
AddEventHandler("TOB_fh:stopHeist", function(name)
    TriggerClientEvent("TOB_fh:stopHeist_c", -1, name)
end)

RegisterServerEvent("TOB_fh:rewardCash")
AddEventHandler("TOB_fh:rewardCash", function()
    local xPlayer = vRP.getUserId({source})
    local reward = math.random(TOB.mincash, TOB.maxcash)

    if TOB.black then
        vRP.giveInventoryItem({xPlayer,TOB.blackmoney, reward})
    else
        vRP.giveMoney({xPlayer,reward})
    end
end)

RegisterServerEvent("TOB_fh:setCooldown")
AddEventHandler("TOB_fh:setCooldown", function(name)
    TOB.Banks[name].lastrobbed = os.time()
    TOB.Banks[name].onaction = false
    TriggerClientEvent("TOB_fh:resetDoorState", -1, name)
end)

TOBBlaine.RegisterServerCallback("TOB_fh:getBanks", function(source, cb)
    cb(TOB.Banks, Doors)
end)

TOBBlaine.RegisterServerCallback("TOB_fh:checkSecond", function(source, cb)
    local xPlayer = vRP.getUserId({source})
    local item = vRP.getInventoryItemAmount({xPlayer,"secure_card",1})

    if item >= 1 then
        vRP.tryGetInventoryItem({xPlayer,"secure_card",1})
        cb(true)
    else
        cb(false)
    end
end)

-- Cop System
RegisterServerEvent('TOB_fh:CheckCop')
AddEventHandler('TOB_fh:CheckCop', function()
    local xPlayer = vRP.getUserId({source})
    
    if vRP.hasGroup({xPlayer, "Politi-Job"}) then
	--if vRP.hasPermission({xPlayer,TOB.PolicePermission}) then
		TriggerClientEvent('TOB_fh:IsCop', xPlayer)
	else
		TriggerClientEvent('TOB_fh:IsNOTCop', xPlayer)
	end
end)
