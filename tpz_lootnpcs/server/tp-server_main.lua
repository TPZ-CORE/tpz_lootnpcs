local TPZ = exports.tpz_core:getCoreAPI()

local ListedEntities = {}

-------------------------------------------------------------
--[[ Local Functions  ]]--
-------------------------------------------------------------

-- @GetTableLength returns the length of a table.
local function GetTableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local function GetPlayerData(source)
	local _source = source
    local xPlayer = TPZ.GetPlayer(_source)

	return {
        steamName      = GetPlayerName(_source),
        username       = xPlayer.getFirstName() .. ' ' .. xPlayer.getLastName(),
		identifier     = xPlayer.getIdentifier(),
        charIdentifier = xPlayer.getCharacterIdentifier(),
	}

end

local function HasPedTargetClose(closestEntityPeds, targetEntityId)

    if targetEntityId == nil or closestEntityPeds == nil or closestEntityPeds and GetTableLength(closestEntityPeds) <= 0 then
        return false
    end

    for index, nearPed in pairs (closestEntityPeds) do

        -- We check if closest peds contains the target entity and if target entity is dead.
        -- We also check if pedtype is index 4 which is what we need.
        if tonumber(nearPed.entity) == tonumber(targetEntityId) and nearPed.isDead and nearPed.pedType == 4 then
            return true
        end
        
    end

    return false

end

-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------
 
AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
      
    ListedEntities = nil -- clearing all data
end)

-------------------------------------------------------------
--[[ Events  ]]--
-------------------------------------------------------------

-- @closestEntityPeds : is required to find devtools / injection cheats.
RegisterServerEvent("tpz_lootnpcs:server:reward")
AddEventHandler("tpz_lootnpcs:server:reward", function(closestEntityPeds, entityId)
    local _source          = source 
    local PlayerData       = GetPlayerData(_source)
    local xPlayer          = TPZ.GetPlayer(_source)

    math.randomseed(os.time())
    Wait(math.random(150, 350))

    -- It doesnt count as devtools, for some reason the loot prompt might be visible again, so we check only if the ped has been looted
    -- by the player source.
    if ListedEntities[entityId] then
        SendNotification(nil, Locales['ENTITY_HAS_BEEN_ALREADY_LOOTED'], 'error')
        return
    end

    local hasEntityTargetClose = HasPedTargetClose(closestEntityPeds, entityId)

    if not hasEntityTargetClose then 

        if Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Enabled then
            local _w, _c      = Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Url, Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Color
            local description = 'The specified user attempted to use devtools / injection cheat on npc loot reward.'
            TPZ.SendToDiscordWithPlayerParameters(_w, Locales['DEVTOOLS_INJECTION_DETECTED_TITLE_LOG'], _source, PlayerData.steamName, PlayerData.username, PlayerData.identifier, PlayerData.charIdentifier, description, _c)
        end
    
        xPlayer.disconnect(Locales['DEVTOOLS_INJECTION_DETECTED'])
        return
    end

    print('entity exists, we give rewards')

    local WebhookData = Config.Webhooks['LOOTED']

    if WebhookData.Enabled then
        local description = string.format('The specified user has looted an npc and received %s %s' )
        TPZ.SendToDiscordWithPlayerParameters(WebhookData.Url, WebhookData.Title, _source, PlayerData.steamName, PlayerData.username, PlayerData.identifier, PlayerData.charIdentifier, description, WebhookData.Color)
    end
    
end)
