ESX = exports["es_extended"]:getSharedObject()

local wayPointActive = false
local onScreen, screenX, screenY = nil
local pos = vector3(0,0,0)
local pauseMenuActive = false

function lerp(a, b, t)
    local data = a + (b - a) * t
    if data > 0.95 then 
        data = 0.95
    end
    
    if data < 0.04 then 
        data = 0.03
    end

    return data
end

function DrawSprite3d(data)
    if not onScreen then
        local onScreen2, scaleX, scaleY = GetHudScreenPositionFromWorldPosition(pos.x, pos.y, pos.z)
        scaleX = lerp(-0.1, 1.1, scaleX)
        scaleY = lerp(-0.1, 1.1, scaleY)
        SendNUIMessage({
            state = 'waypointActive',
            distance = data.distance,
            pos = {x = scaleX, y = scaleY},
            scale = 1,
            onScreen = false,
        })
    else 
        SendNUIMessage({
            state = 'waypointActive',
            distance = data.distance, 
            pos = {x = screenX, y = screenY},
            scale = 1,
            onScreen = true,
        })
    end
end

CreateThread(function()
    while true do
        if Config.OnlyInVehicle then
            if wayPointActive and IsPedInAnyVehicle(PlayerPedId(), true) then
                onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
            end
        else
            if wayPointActive then
                onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
            end
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do 
        if Config.OnlyInVehicle then
            if wayPointActive and not pauseMenuActive and IsPedInAnyVehicle(PlayerPedId(), true) then
                DrawSprite3d({
                    pos = vector3(432.3429, -981.6395, 30.6995),
                    distance = #(pos - GetEntityCoords(GetPlayerPed(-1)))
                })
            end
        else
            if wayPointActive and not pauseMenuActive then
                DrawSprite3d({
                    pos = vector3(432.3429, -981.6395, 30.6995),
                    distance = #(pos - GetEntityCoords(GetPlayerPed(-1)))
                })
            end
        end
        Wait(0)
    end
end)

CreateThread(function()
    while true do 
        if Config.OnlyInVehicle then
            if IsWaypointActive() and IsPedInAnyVehicle(PlayerPedId(), true) then 
                if not wayPointActive then 
                    local blip = GetFirstBlipInfoId(8)
                    local blipX = 0.0
                    local blipY = 0.0
                    
                    if (blip ~= 0) then
                        local blipPos = GetBlipCoords(blip)
                        RequestAdditionalCollisionAtCoord(blipPos)
                        local _, z = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, 1000.0, false)
                        pos = blipPos + vector3(0,0,z)
                        wayPointActive = true
                    end
                else
                    if IsPauseMenuActive() then 
                        pauseMenuActive = true
                        SendNUIMessage({state = 'waypointDeactive'})
                    else
                        pauseMenuActive = false
                    end
                end
            else
                if wayPointActive then 
                    SendNUIMessage({state = 'waypointDeactive'})
                    wayPointActive = false
                end
            end
        else
            if IsWaypointActive() then 
                if not wayPointActive then 
                    local blip = GetFirstBlipInfoId(8)
                    local blipX = 0.0
                    local blipY = 0.0
                    
                    if (blip ~= 0) then
                        local blipPos = GetBlipCoords(blip)
                        RequestAdditionalCollisionAtCoord(blipPos)
                        local _, z = GetGroundZFor_3dCoord(blipPos.x, blipPos.y, 1000.0, false)
                        pos = blipPos + vector3(0,0,z)
                        wayPointActive = true
                    end
                else
                    if IsPauseMenuActive() then 
                        pauseMenuActive = true
                        SendNUIMessage({state = 'waypointDeactive'})
                    else
                        pauseMenuActive = false
                    end
                end
            else
                if wayPointActive then 
                    SendNUIMessage({state = 'waypointDeactive'})
                    wayPointActive = false
                end
            end
        end
        Wait(1000)
    end
end)