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

local function StartsWith(String,Start)
    return string.sub(String,1,string.len(Start))==Start
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

local function GenerateRandomRewards()

    local maxRewards = math.random(Config.RandomRewards.MaximumRewards.min, Config.RandomRewards.MaximumRewards.max)

    if maxRewards <= 0 then -- In case somehow maxRewards are 0, we return as null.
        return nil
    end

    local rewardsList = {}

    for i = 1, maxRewards do

        local randomItem = Config.RandomRewards.Rewards[math.random(#Config.RandomRewards.Rewards)]

        if rewardsList[randomItem.name] == nil then

            local chance = math.random(1, 99)

            if chance <= randomItem.chance then
                rewardsList[randomItem.name] = {}
                rewardsList[randomItem.name] = randomItem

            end

        end

    end

    return rewardsList

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

    -- It doesnt count as devtools, for some reason the loot prompt might be visible again, so we check only if the ped has been looted
    -- by the player source.
    if ListedEntities[entityId] then
        SendNotification(_source, Locales['ENTITY_HAS_BEEN_ALREADY_LOOTED'], 'error')
        return
    end

    local hasEntityTargetClose = HasPedTargetClose(closestEntityPeds, entityId)

    if not hasEntityTargetClose then 

        if Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Enabled then
            local _w, _c      = Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Url, Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Color
            local description = 'The specified user attempted to use devtools / injection cheat on npc loot reward.'
            TPZ.SendToDiscordWithPlayerParameters(_w, Locales['DEVTOOLS_INJECTION_DETECTED_TITLE_LOG'], _source, PlayerData.steamName, PlayerData.username, PlayerData.identifier, PlayerData.charIdentifier, description, _c)
        end
    
        --xPlayer.disconnect(Locales['DEVTOOLS_INJECTION_DETECTED'])
        xPlayer.ban(Locales['DEVTOOLS_INJECTION_DETECTED'], -1)
        return
    end

    local getRandomRewards = GenerateRandomRewards() -- table.

    local received = nil

    for index, reward in pairs (getRandomRewards) do

        if reward.name == '0' or reward.name == '1' or reward.name == '2' then -- reward is account
            local quantity = math.random(reward.quantity.min, reward.quantity.max)

            xPlayer.addAccount(tonumber(reward.name), quantity)
            local notify = not received and quantity .. ' ' .. reward.label or received .. ', ' .. quantity .. ' ' .. reward.label
            received = notify

        elseif StartsWith(reward.name, 'WEAPON_') then -- reward is weapon

            local canCarryWeapon = xPlayer.canCarryWeapon(string.upper(reward.name) )

            if canCarryWeapon then
                xPlayer.addWeapon(string.upper(reward.name) )

                local notify = not received and 'X1' .. reward.label or received .. ', X1 ' .. reward.label
                received = notify
            end

        else -- reward is item

            local quantity     = math.random(reward.quantity.min, reward.quantity.max)
            local canCarryItem = xPlayer.canCarryItem(reward.name, quantity)

            if canCarryItem then
                xPlayer.addItem(reward.name, quantity)

                local notify = not received and quantity .. ' ' .. reward.label or received .. ', ' .. quantity .. ' ' .. reward.label
                received = notify
            end

        end

    end

    if received then
        SendNotification(_source, string.format(Locales['RECEIVED_LOOT'], received), 'success')
    end

    local WebhookData = Config.Webhooks['LOOTED']

    if WebhookData.Enabled then
        local description = string.format('The specified user has looted an npc and received %s', received )
        TPZ.SendToDiscordWithPlayerParameters(WebhookData.Url, WebhookData.Title, _source, PlayerData.steamName, PlayerData.username, PlayerData.identifier, PlayerData.charIdentifier, description, WebhookData.Color)
    end
    
end)
