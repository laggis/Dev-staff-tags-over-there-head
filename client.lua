local playerDevStates = {}
local playerStaffStates = {}
local devText = "~r~[~w~DEVELOPER~r~]"
local staffText = "~b~[~w~STAFF~b~]"
local localDevMode = false
local localStaffMode = false

-- Request sync when joining
AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    TriggerServerEvent('devtag:requestSync')
end)

-- Function to toggle god mode
local function setGodMode(state, isStaff)
    if isStaff and not Config.EnableStaffGodMode then return end
    if not isStaff and not Config.EnableGodMode then return end
    
    local ped = PlayerPedId()
    if state then
        -- Enable god mode
        SetEntityInvincible(ped, true)
        SetPlayerInvincible(PlayerId(), true)
        SetEntityProofs(ped, true, true, true, true, true, true, true, true)
        SetEntityCanBeDamaged(ped, false)
    else
        -- Disable god mode
        SetEntityInvincible(ped, false)
        SetPlayerInvincible(PlayerId(), false)
        SetEntityProofs(ped, false, false, false, false, false, false, false, false)
        SetEntityCanBeDamaged(ped, true)
    end
end

-- Function to get distance between coordinates
local function getDistance(x1, y1, z1, x2, y2, z2)
    return #(vector3(x1, y1, z1) - vector3(x2, y2, z2))
end

-- Update local states when received from server
RegisterNetEvent('devtag:updateState')
AddEventHandler('devtag:updateState', function(playerId, state, tagType)
    if tagType == 'dev' then
        playerDevStates[playerId] = state
    else
        playerStaffStates[playerId] = state
    end
    
    -- If this is for the local player, handle god mode
    if playerId == GetPlayerServerId(PlayerId()) then
        if tagType == 'dev' then
            localDevMode = state
            setGodMode(state, false)
        else
            localStaffMode = state
            setGodMode(state, true)
        end
    end
end)

-- Animation variables
local animationOffset = 0.0
local animationSpeed = 1.0

-- Draw text above player heads
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Update animation
        local timeNow = GetGameTimer() / 1000
        animationOffset = math.sin(timeNow * animationSpeed) * 0.05
        
        local players = GetActivePlayers()
        local localPed = PlayerPedId()
        local localCoords = GetEntityCoords(localPed)
        
        for _, player in ipairs(players) do
            local serverId = GetPlayerServerId(player)
            local ped = GetPlayerPed(player)
            if DoesEntityExist(ped) then
                local targetCoords = GetEntityCoords(ped)
                local distance = getDistance(
                    localCoords.x, localCoords.y, localCoords.z,
                    targetCoords.x, targetCoords.y, targetCoords.z
                )
                
                -- Only draw tag if within view distance
                if distance <= Config.ViewDistance then
                    if playerDevStates[serverId] then
                        DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.0 + animationOffset, devText)
                    elseif playerStaffStates[serverId] then
                        DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.0 + animationOffset, staffText)
                    end
                end
            end
        end
        
        -- Ensure god mode stays active if enabled in config
        if localDevMode and Config.EnableGodMode then
            setGodMode(true, false)
        elseif localStaffMode and Config.EnableStaffGodMode then
            setGodMode(true, true)
        end
    end
end)

-- Function to draw 3D text with modern style
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    
    if onScreen then
        -- Text Settings
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextDropshadow(5, 0, 0, 0, 255)
        SetTextEdge(1, 0, 0, 0, 255)
        
        -- Draw background rectangle
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 150)
        
        -- Add text component and draw
        AddTextComponentString(text)
        DrawText(_x, _y)
        
        -- Draw outline
        local width = 0.015 + factor
        local height = 0.03
        local x = _x
        local y = _y + 0.0125
        
        -- Top line
        DrawRect(x, y - height/2, width, 0.001, 255, 0, 0, 255)
        -- Bottom line
        DrawRect(x, y + height/2, width, 0.001, 255, 0, 0, 255)
        -- Left line
        DrawRect(x - width/2, y, 0.001, height, 255, 0, 0, 255)
        -- Right line
        DrawRect(x + width/2, y, 0.001, height, 255, 0, 0, 255)
    end
end
