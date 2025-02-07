local playerDevStates = {}
local playerStaffStates = {}

-- Function to check if a license is in a list
local function isLicenseAuthorized(license, licenseList)
    for _, authorizedLicense in ipairs(licenseList) do
        if authorizedLicense == license then
            return true
        end
    end
    return false
end

RegisterCommand('dev', function(source, args, rawCommand)
    local player = source
    local license = GetPlayerIdentifierByType(player, 'license')
    
    -- Check if player is authorized
    if not isLicenseAuthorized(license, Config.AuthorizedLicenses) then
        TriggerClientEvent('chat:addMessage', player, {
            color = {255, 0, 0},
            args = {'System', 'You are not authorized to use this command.'}
        })
        return
    end
    
    -- Toggle dev state
    playerDevStates[player] = not playerDevStates[player]
    
    -- If enabling dev mode, disable staff mode
    if playerDevStates[player] then
        playerStaffStates[player] = false
    end
    
    -- Sync states with all clients
    TriggerClientEvent('devtag:updateState', -1, player, playerDevStates[player], 'dev')
    TriggerClientEvent('devtag:updateState', -1, player, false, 'staff')
    
    -- Notify player
    local state = playerDevStates[player] and 'enabled' or 'disabled'
    TriggerClientEvent('chat:addMessage', player, {
        color = {0, 255, 0},
        args = {'System', 'Developer tag ' .. state}
    })
end)

RegisterCommand('staff', function(source, args, rawCommand)
    local player = source
    local license = GetPlayerIdentifierByType(player, 'license')
    
    -- Check if player is authorized
    if not isLicenseAuthorized(license, Config.StaffLicenses) then
        TriggerClientEvent('chat:addMessage', player, {
            color = {255, 0, 0},
            args = {'System', 'You are not authorized to use this command.'}
        })
        return
    end
    
    -- Toggle staff state
    playerStaffStates[player] = not playerStaffStates[player]
    
    -- If enabling staff mode, disable dev mode
    if playerStaffStates[player] then
        playerDevStates[player] = false
    end
    
    -- Sync states with all clients
    TriggerClientEvent('devtag:updateState', -1, player, playerStaffStates[player], 'staff')
    TriggerClientEvent('devtag:updateState', -1, player, false, 'dev')
    
    -- Notify player
    local state = playerStaffStates[player] and 'enabled' or 'disabled'
    TriggerClientEvent('chat:addMessage', player, {
        color = {0, 255, 0},
        args = {'System', 'Staff tag ' .. state}
    })
end)

-- When player disconnects, remove their states
AddEventHandler('playerDropped', function()
    playerDevStates[source] = nil
    playerStaffStates[source] = nil
    TriggerClientEvent('devtag:updateState', -1, source, false, 'dev')
    TriggerClientEvent('devtag:updateState', -1, source, false, 'staff')
end)

-- When player joins, sync all current states
RegisterNetEvent('devtag:requestSync')
AddEventHandler('devtag:requestSync', function()
    local source = source
    for player, state in pairs(playerDevStates) do
        TriggerClientEvent('devtag:updateState', source, player, state, 'dev')
    end
    for player, state in pairs(playerStaffStates) do
        TriggerClientEvent('devtag:updateState', source, player, state, 'staff')
    end
end)
