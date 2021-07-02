HT = nil

Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)


-- Cop System 
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(3000)
        TriggerServerEvent('TOB_fh:CheckCop')
    end
end)


RegisterNetEvent('TOB_fh:IsCop')
AddEventHandler('TOB_fh:IsCop', function()
    IsPolice = true
end)
RegisterNetEvent('TOB_fh:IsNOTCop')
AddEventHandler('TOB_fh:IsNOTCop', function()
    IsPolice = false
end)

Freeze = {B1 = 0}
PlayerData = nil
IsPolice = false
Check = {B1 = false}
SearchChecks = {B1 = false}
LootCheck = {
    B1 = {Stop = false, Loot1 = false, Loot2 = false, Loot3 = false}
}
Doors = {}
local disableinput = false
local initiator = false
local startdstcheck = false
local currentname = nil
local currentcoords = nil
local done = true
local dooruse = false
local robbing = false

Citizen.CreateThread(function() while true do local enabled = false Citizen.Wait(1) if disableinput then enabled = true DisableControl() end if not enabled then Citizen.Wait(500) end end end)
function DrawText3D(x, y, z, text, scale) local onScreen, _x, _y = World3dToScreen2d(x, y, z) local pX, pY, pZ = table.unpack(GetGameplayCamCoords()) SetTextScale(scale, scale) SetTextFont(4) SetTextProportional(1) SetTextEntry("STRING") SetTextCentre(true) SetTextColour(255, 255, 255, 215) AddTextComponentString(text) DrawText(_x, _y) local factor = (string.len(text)) / 700 DrawRect(_x, _y + 0.0150, 0.095 + factor, 0.03, 41, 11, 41, 100) end
function DisableControl() DisableControlAction(0, 73, false) DisableControlAction(0, 24, true) DisableControlAction(0, 257, true) DisableControlAction(0, 25, true) DisableControlAction(0, 263, true) DisableControlAction(0, 32, true) DisableControlAction(0, 34, true) DisableControlAction(0, 31, true) DisableControlAction(0, 30, true) DisableControlAction(0, 45, true) DisableControlAction(0, 22, true) DisableControlAction(0, 44, true) DisableControlAction(0, 37, true) DisableControlAction(0, 23, true) DisableControlAction(0, 288, true) DisableControlAction(0, 289, true) DisableControlAction(0, 170, true) DisableControlAction(0, 167, true) DisableControlAction(0, 73, true) DisableControlAction(2, 199, true) DisableControlAction(0, 47, true) DisableControlAction(0, 264, true) DisableControlAction(0, 257, true) DisableControlAction(0, 140, true) DisableControlAction(0, 141, true) DisableControlAction(0, 142, true) DisableControlAction(0, 143, true) end
function ShowTimer() SetTextFont(0) SetTextProportional(0) SetTextScale(0.42, 0.42) SetTextDropShadow(0, 0, 0, 0,255) SetTextEdge(1, 0, 0, 0, 255) SetTextEntry("STRING") AddTextComponentString("~r~"..TOB.timer.."~w~") DrawText(0.682, 0.96) end
local a={__gc=function(b)if b.destructor and b.handle then b.destructor(b.handle)end;b.destructor=nil;b.handle=nil end}local function c(d,e,f)return coroutine.wrap(function()local g,h=d()if not h or h==0 then f(g)return end;local b={handle=g,destructor=f}setmetatable(b,a)local i=true;repeat coroutine.yield(h)i,h=e(g)until not i;b.destructor,b.handle=nil,nil;f(g)end)end;function EnumerateObjects()return c(FindFirstObject,FindNextObject,EndFindObject)end;function GetObjects()local j={}for k in EnumerateObjects()do table.insert(j,k)end;return j end;function GetClosestObject(l,m)local j=GetObjects()local n=-1;local o=-1;local l=l;local m=m;if type(l)=='string'then if l~=''then l={l}end end;if m==nil then local p=PlayerPedId()m=GetEntityCoords(p)end;for q=1,#j,1 do local r=false;if l==nil or type(l)=='table'and#l==0 then r=true else local s=GetEntityModel(j[q])for t=1,#l,1 do if s==GetHashKey(l[t])then r=true end end end;if r then local u=GetEntityCoords(j[q])local v=GetDistanceBetweenCoords(u,m.x,m.y,m.z,true)if n==-1 or n>v then o=j[q]n=v end end end;return o,n end

RegisterNetEvent("TOB_fh:resetDoorState")
AddEventHandler("TOB_fh:resetDoorState", function(name)
    Freeze[name] = 0
end)

RegisterNetEvent("TOB_fh:lootup_c")
AddEventHandler("TOB_fh:lootup_c", function(var, var2)
    LootCheck[var][var2] = true
end)

RegisterNetEvent("TOB_fh:outcome")
AddEventHandler("TOB_fh:outcome", function(oc, arg)
    for i = 1, #Check, 1 do
        Check[i] = false
    end
    for i = 1, #LootCheck, 1 do
        for j = 1, #LootCheck[i] do
            LootCheck[i][j] = false
        end
    end
    if oc then
        Check[arg] = true
        TriggerEvent("TOB_fh:startheist", TOB.Banks[arg], arg)
    elseif not oc then
        exports["mythic_notify"]:SendAlert("error", arg)
    end
end)

RegisterNetEvent("TOB_fh:startLoot_c")
AddEventHandler("TOB_fh:startLoot_c", function(data, name)
    currentname = name
    currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
    if not LootCheck[name].Stop then
        Citizen.CreateThread(function()
            while true do
                local pedcoords = GetEntityCoords(PlayerPedId())
                local dst = GetDistanceBetweenCoords(pedcoords, data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z, true)

                if dst < 40 then
                    if not LootCheck[name].Loot1 then
                        local dst1 = GetDistanceBetweenCoords(pedcoords, data.trolley1.x, data.trolley1.y, data.trolley1.z + 1, true)

                        if dst1 < 5 and not IsPolice then
                            DrawText3D(data.trolley1.x, data.trolley1.y, data.trolley1.z+1, "[~r~E~w~] Tag pengene", 0.40)
                            if dst1 < 0.75 and IsControlJustReleased(0, 38) then
                                TriggerServerEvent("TOB_fh:lootup", name, "Loot1")
                                StartGrab(name)
                            end
                        end
                    end

                    if not LootCheck[name].Loot2 then
                        local dst1 = GetDistanceBetweenCoords(pedcoords, data.trolley2.x, data.trolley2.y, data.trolley2.z+1, true)

                        if dst1 < 5 and not IsPolice then
                            DrawText3D(data.trolley2.x, data.trolley2.y, data.trolley2.z+1, "[~r~E~w~] Tag pengene", 0.40)
                            if dst1 < 1 and IsControlJustReleased(0, 38) then
                                TriggerServerEvent("TOB_fh:lootup", name, "Loot2")
                                StartGrab(name)
                            end
                        end
                    end

                    if not LootCheck[name].Loot3 then
                        local dst1 = GetDistanceBetweenCoords(pedcoords, data.trolley3.x, data.trolley3.y, data.trolley3.z+1, true)

                        if dst1 < 5 and not IsPolice then
                            DrawText3D(data.trolley3.x, data.trolley3.y, data.trolley3.z+1, "[~r~E~w~] Tag pengene", 0.40)
                            if dst1 < 1 and IsControlJustReleased(0, 38) then
                                TriggerServerEvent("TOB_fh:lootup", name, "Loot3")
                                StartGrab(name)
                            end
                        end
                    end

                    if LootCheck[name].Stop or (LootCheck[name].Loot1 and LootCheck[name].Loot2 and LootCheck[name].Loot3) then
                        LootCheck[name].Stop = false
                        if initiator then
                            TriggerEvent("TOB_fh:reset", name, data)
                            return
                        end
                        return
                    end
                    Citizen.Wait(1)
                else
                    Citizen.Wait(1000)
                end
            end
        end)
    end
end)

RegisterNetEvent("TOB_fh:stopHeist_c")
AddEventHandler("TOB_fh:stopHeist_c", function(name)
    LootCheck[name].Stop = true
end)

RegisterNetEvent("TOB_fh:policenotify")
AddEventHandler("TOB_fh:policenotify", function(name)
    local PlayerData = vRP.getUsers()
    local blip = nil

    if IsPolice then
        exports["mythic_notify"]:SendAlert("inform", "En alarm i banken er blevet uløst!", 10000, {["background-color"] = "#CD472A", ["color"] = "#ffffff"})
        if not DoesBlipExist(blip) then
            blip = AddBlipForCoord(TOB.Banks[name].doors.startloc.x, TOB.Banks[name].doors.startloc.y, TOB.Banks[name].doors.startloc.z)
            SetBlipSprite(blip, 161)
            SetBlipScale(blip, 2.0)
            SetBlipColour(blip, 1)

            PulseBlip(blip)
            Citizen.Wait(240000)
            RemoveBlip(blip)
        end
    end
end)

-- MAIN DOOR UPDATE --

AddEventHandler("TOB_fh:freezeDoors", function()
    Citizen.CreateThread(function()
        while true do
            for k, v in pairs(Doors) do
                if v[1].obj == nil or not DoesEntityExist(v[1].obj) then
                    v[1].obj = GetClosestObjectOfType(v[1].loc, 1.5, GetHashKey("v_ilev_cbankvaulgate01"), false, false, false)
                    FreezeEntityPosition(v[1].obj, v[1].locked)
                else
                    FreezeEntityPosition(v[1].obj, v[1].locked)
                    Citizen.Wait(100)
                end
                if v[1].locked then
                    SetEntityHeading(v[1].obj, v[1].h)
                end
                Citizen.Wait(100)
            end
            Citizen.Wait(1)
        end
    end)
    Citizen.CreateThread(function()
        while true do
            if IsPolice and not dooruse then
                local pcoords = GetEntityCoords(PlayerPedId())

                for k, v in pairs(Doors) do
                    for i = 1, 2, 1 do
                        local dst = GetDistanceBetweenCoords(pcoords, v[i].loc, true)

                        if dst <= 2.0 then
                            if v[i].locked then
                                DrawText3D(v[i].txtloc[1], v[i].txtloc[2], v[i].txtloc[3], "[~r~E~w~] Åben døren", 0.40)
                            elseif not v[i].locked then
                                DrawText3D(v[i].txtloc[1], v[i].txtloc[2], v[i].txtloc[3], "[~r~E~w~] låse døren", 0.40)
                            end
                            if dst <= 1.5 and IsControlJustReleased(0, 38) then
                                dooruse = true
                                if i == 2 then
                                    TriggerServerEvent("TOB_fh:toggleVault", k, not v[i].locked)
                                else
                                    TriggerServerEvent("TOB_fh:toggleDoor", k, not v[i].locked)
                                end
                            end
                        end
                    end
                end
            else
                Citizen.Wait(1000)
            end
            Citizen.Wait(1)
        end
    end)
end)

RegisterNetEvent("TOB_fh:toggleDoor")
AddEventHandler("TOB_fh:toggleDoor", function(key, state)
    Doors[key][1].locked = state
    dooruse = false
end)

RegisterNetEvent("TOB_fh:toggleVault")
AddEventHandler("TOB_fh:toggleVault", function(key, state)
    dooruse = true
    Doors[key][2].state = nil
    if TOB.Banks[key].hash == nil then
        if not state then
            local obj = GetClosestObjectOfType(TOB.Banks[key].doors.startloc.x, TOB.Banks[key].doors.startloc.y, TOB.Banks[key].doors.startloc.z, 2.0, GetHashKey(TOB.vaultdoor), false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) + 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][2].locked = state
            Doors[key][2].state = GetEntityHeading(obj)
            TriggerServerEvent("TOB_fh:updateVaultState", key, Doors[key][2].state)
        elseif state then
            local obj = GetClosestObjectOfType(TOB.Banks[key].doors.startloc.x, TOB.Banks[key].doors.startloc.y, TOB.Banks[key].doors.startloc.z, 2.0, GetHashKey(TOB.vaultdoor), false, false, false)
            local count = 0

            repeat
                local heading = GetEntityHeading(obj) - 0.10

                SetEntityHeading(obj, heading)
                count = count + 1
                Citizen.Wait(10)
            until count == 900
            Doors[key][2].locked = state
            Doors[key][2].state = GetEntityHeading(obj)
            TriggerServerEvent("TOB_fh:updateVaultState", key, Doors[key][2].state)
        end
    end
    dooruse = false
end)

AddEventHandler("TOB_fh:reset", function(name, data)
    for i = 1, #LootCheck[name], 1 do
        LootCheck[name][i] = false
    end
    Check[name] = false
    exports["mythic_notify"]:SendAlert("error", "Bank døren ville blive låst om 10 Sekunder!")
    Citizen.Wait(10000)
    exports["mythic_notify"]:SendAlert("error", "Bank døren lukker!")
    TriggerServerEvent("TOB_fh:toggleVault", name, true)
    TriggerEvent("TOB_fh:cleanUp", data, name)
end)

AddEventHandler("TOB_fh:startheist", function(data, name)
    TriggerServerEvent("TOB_fh:toggleDoor", name, true)
    disableinput = true
    robbing = true
    currentname = name
    currentcoords = vector3(data.doors.startloc.x, data.doors.startloc.y, data.doors.startloc.z)
    initiator = true
    RequestModel("p_ld_id_card_01")
    while not HasModelLoaded("p_ld_id_card_01") do
        Citizen.Wait(1)
    end
    local ped = PlayerPedId()

    SetEntityCoords(ped, data.doors.startloc.animcoords.x, data.doors.startloc.animcoords.y, data.doors.startloc.animcoords.z)
    SetEntityHeading(ped, data.doors.startloc.animcoords.h)
    local pedco = GetEntityCoords(PlayerPedId())
    IdProp = CreateObject(GetHashKey("p_ld_id_card_01"), pedco, 1, 1, 0)
    local boneIndex = GetPedBoneIndex(PlayerPedId(), 28422)

    AttachEntityToEntity(IdProp, ped, boneIndex, 0.20, 0.038, 0.001, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
    TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
    exports['progressBars']:startUI(2000, "Bruger i idkort")
    Citizen.Wait(1500)
    DetachEntity(IdProp, false, false)
    SetEntityCoords(IdProp, data.prop.first.coords, 0.0, 0.0, 0.0, false)
    SetEntityRotation(IdProp, data.prop.first.rot, 1, true)
    FreezeEntityPosition(IdProp, true)
    Citizen.Wait(500)
    ClearPedTasksImmediately(ped)
    disableinput = false
    Citizen.Wait(1000)
    Process(TOB.hacktime, "Hack in Progress")
    exports["mythic_notify"]:SendAlert("success", "Hacking udført!")
    PlaySoundFrontend(-1, "ATM_WINDOW", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    TriggerServerEvent("TOB_fh:toggleVault", name, false)
    startdstcheck = true
    currentname = name
    exports["mythic_notify"]:SendAlert("error", "Du har 2 minutter til at sikkerheds panlet genstarter.")
    SpawnTrolleys(data, name)
end)

AddEventHandler("TOB_fh:cleanUp", function(data, name)
    Citizen.Wait(10000)
    for i = 1, 3, 1 do -- full trolley clean
        local obj = GetClosestObjectOfType(data.objects[i].x, data.objects[i].y, data.objects[i].z, 0.75, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)

        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    for j = 1, 3, 1 do -- empty trolley clean
        local obj = GetClosestObjectOfType(data.objects[j].x, data.objects[j].y, data.objects[j].z, 0.75, GetHashKey("hei_prop_hei_cash_trolly_03"), false, false, false)

        if DoesEntityExist(obj) then
            DeleteEntity(obj)
        end
    end
    if DoesEntityExist(IdProp) then
        DeleteEntity(IdProp)
    end
    if DoesEntityExist(IdProp2) then
        DeleteEntity(IdProp2)
    end
    TriggerServerEvent("TOB_fh:setCooldown", name)
    initiator = false
    robbing = false
end)


function Process(ms, text)
    exports['progressBars']:startUI(ms, text)
    Citizen.Wait(ms)
end

function SpawnTrolleys(data, name)
    RequestModel("hei_prop_hei_cash_trolly_01")
    while not HasModelLoaded("hei_prop_hei_cash_trolly_01") do
        Citizen.Wait(1)
    end
    Trolley1 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley1.x, data.trolley1.y, data.trolley1.z, 1, 1, 0)
    Trolley2 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley2.x, data.trolley2.y, data.trolley2.z, 1, 1, 0)
    Trolley3 = CreateObject(GetHashKey("hei_prop_hei_cash_trolly_01"), data.trolley3.x, data.trolley3.y, data.trolley3.z, 1, 1, 0)
    local h1 = GetEntityHeading(Trolley1)
    local h2 = GetEntityHeading(Trolley2)
    local h3 = GetEntityHeading(Trolley3)

    SetEntityHeading(Trolley1, h1 + TOB.Banks[name].trolley1.h)
    SetEntityHeading(Trolley2, h2 + TOB.Banks[name].trolley2.h)
    SetEntityHeading(Trolley3, h3 + TOB.Banks[name].trolley3.h)
    TriggerServerEvent("TOB_fh:startLoot", data, name)
    done = false
end

function StartGrab(name)
    disableinput = true
    local ped = PlayerPedId()
    local model = "hei_prop_heist_cash_pile"

    Trolley = GetClosestObjectOfType(GetEntityCoords(ped), 1.0, GetHashKey("hei_prop_hei_cash_trolly_01"), false, false, false)
    local CashAppear = function()
	    local pedCoords = GetEntityCoords(ped)
        local grabmodel = GetHashKey(model)

        RequestModel(grabmodel)
        while not HasModelLoaded(grabmodel) do
            Citizen.Wait(100)
        end
	    local grabobj = CreateObject(grabmodel, pedCoords, true)

	    FreezeEntityPosition(grabobj, true)
	    SetEntityInvincible(grabobj, true)
	    SetEntityNoCollisionEntity(grabobj, ped)
	    SetEntityVisible(grabobj, false, false)
	    AttachEntityToEntity(grabobj, ped, GetPedBoneIndex(ped, 60309), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
	    local startedGrabbing = GetGameTimer()

	    Citizen.CreateThread(function()
		    while GetGameTimer() - startedGrabbing < 37000 do
			    Citizen.Wait(1)
			    DisableControlAction(0, 73, true)
			    if HasAnimEventFired(ped, GetHashKey("CASH_APPEAR")) then
				    if not IsEntityVisible(grabobj) then
					    SetEntityVisible(grabobj, true, false)
				    end
			    end
			    if HasAnimEventFired(ped, GetHashKey("RELEASE_CASH_DESTROY")) then
				    if IsEntityVisible(grabobj) then
                        SetEntityVisible(grabobj, false, false)
                        TriggerServerEvent("TOB_fh:rewardCash")
				    end
			    end
		    end
		    DeleteObject(grabobj)
	    end)
    end
	local trollyobj = Trolley
    local emptyobj = GetHashKey("hei_prop_hei_cash_trolly_03")

	if IsEntityPlayingAnim(trollyobj, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 3) then
		return
    end
    local baghash = GetHashKey("hei_p_m_bag_var22_arm_s")

    RequestAnimDict("anim@heists@ornate_bank@grab_cash")
    RequestModel(baghash)
    RequestModel(emptyobj)
    while not HasAnimDictLoaded("anim@heists@ornate_bank@grab_cash") and not HasModelLoaded(emptyobj) and not HasModelLoaded(baghash) do
        Citizen.Wait(100)
    end
	while not NetworkHasControlOfEntity(trollyobj) do
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	local bag = CreateObject(GetHashKey("hei_p_m_bag_var22_arm_s"), GetEntityCoords(PlayerPedId()), true, false, false)
    local scene1 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene1, "anim@heists@ornate_bank@grab_cash", "intro", 1.5, -4.0, 1, 16, 1148846080, 0)
    NetworkAddEntityToSynchronisedScene(bag, scene1, "anim@heists@ornate_bank@grab_cash", "bag_intro", 4.0, -8.0, 1)
    SetPedComponentVariation(ped, 5, 0, 0, 0)
	NetworkStartSynchronisedScene(scene1)
	Citizen.Wait(1500)
	CashAppear()
	local scene2 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene2, "anim@heists@ornate_bank@grab_cash", "grab", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene2, "anim@heists@ornate_bank@grab_cash", "bag_grab", 4.0, -8.0, 1)
	NetworkAddEntityToSynchronisedScene(trollyobj, scene2, "anim@heists@ornate_bank@grab_cash", "cart_cash_dissapear", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene2)
	Citizen.Wait(37000)
	local scene3 = NetworkCreateSynchronisedScene(GetEntityCoords(trollyobj), GetEntityRotation(trollyobj), 2, false, false, 1065353216, 0, 1.3)

	NetworkAddPedToSynchronisedScene(ped, scene3, "anim@heists@ornate_bank@grab_cash", "exit", 1.5, -4.0, 1, 16, 1148846080, 0)
	NetworkAddEntityToSynchronisedScene(bag, scene3, "anim@heists@ornate_bank@grab_cash", "bag_exit", 4.0, -8.0, 1)
	NetworkStartSynchronisedScene(scene3)
    NewTrolley = CreateObject(emptyobj, GetEntityCoords(trollyobj) + vector3(0.0, 0.0, - 0.985), true)
    SetEntityRotation(NewTrolley, GetEntityRotation(trollyobj))
	while not NetworkHasControlOfEntity(trollyobj) do
		Citizen.Wait(1)
		NetworkRequestControlOfEntity(trollyobj)
	end
	DeleteObject(trollyobj)
    PlaceObjectOnGroundProperly(NewTrolley)
	Citizen.Wait(1800)
	DeleteObject(bag)
    SetPedComponentVariation(ped, 5, 45, 0, 0)
	RemoveAnimDict("anim@heists@ornate_bank@grab_cash")
	SetModelAsNoLongerNeeded(emptyobj)
    SetModelAsNoLongerNeeded(GetHashKey("hei_p_m_bag_var22_arm_s"))
    disableinput = false
end

Citizen.CreateThread(function()
    while true do
        if startdstcheck then
            if initiator then
                local playercoord = GetEntityCoords(PlayerPedId())

                if (GetDistanceBetweenCoords(playercoord, currentcoords, true)) > 20 then
                    LootCheck[currentname].Stop = true
                    startdstcheck = false
                    TriggerServerEvent("TOB_fh:stopHeist", currentname)
                end
            end
            Citizen.Wait(1)
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)


Citizen.CreateThread(function()
    local resettimer = TOB.timer

    while true do
        if startdstcheck then
            if initiator then
                if TOB.timer > 0 then
                    Citizen.Wait(1000)
                    TOB.timer = TOB.timer - 1
                elseif TOB.timer == 0 then
                    startdstcheck = false
                    TriggerServerEvent("TOB_fh:stopHeist", currentname)
                    TOB.timer = resettimer
                end
            end
            Citizen.Wait(1)
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    while true do
        if startdstcheck then
            if initiator then
                ShowTimer()
            end
        end
        Citizen.Wait(1)
    end
end)

Citizen.CreateThread(function()
    TOBBlaine.TriggerServerCallback("TOB_fh:getBanks", function(bank, door)
        TOB.Banks = bank
        Doors = door
    end)
    TriggerEvent("TOB_fh:freezeDoors")
    while true do
        if not IsPolice then
            local coords = GetEntityCoords(PlayerPedId())

            for k, v in pairs(TOB.Banks) do
                if not v.onaction then
                    local dst = GetDistanceBetweenCoords(coords, v.doors.startloc.x, v.doors.startloc.y, v.doors.startloc.z, true)

                    if dst <= 2 and not Check[k] and not robbing then
                        DrawText3D(v.doors.startloc.x, v.doors.startloc.y, v.doors.startloc.z, "[~r~E~w~] Start bank røveri", 0.40)
                        if dst <= 1 and IsControlJustReleased(0, 38) then
                            TriggerServerEvent("TOB_fh:startcheck", k)
                        end
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
        Citizen.Wait(1)
    end
end)

-- SEARCH FOR ID CARD UPDATE --

function Lockpick(name)
    local player = PlayerPedId()

    RequestAnimDict("mp_arresting")
    while not HasAnimDictLoaded("mp_arresting") do
        RequestAnimDict("mp_arresting")
        Citizen.Wait(10)
    end
    SetEntityCoords(player, loc.x, loc.y, loc.z, 1, 0, 0, 1)
    SetEntityHeading(player, loc.h)
end