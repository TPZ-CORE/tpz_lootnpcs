local TPZ = exports.tpz_core:getCoreAPI()

local ListedEntities = {}

-----------------------------------------------------------
--[[ Local Functions  ]]--
-------------------------------------------------------------

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

RegisterServerEvent("tpz_lootnpcs:server:reward")
AddEventHandler("tpz_lootnpcs:server:reward", function(entityId)
    local _source          = source 
    local PlayerData       = GetPlayerData(_source)
    local xPlayer          = TPZ.GetPlayer(_source)

    math.randomseed(os.time())
    Wait(math.random(250, 500))

    if not DoesEntityExist(entityId) then

        return
    end 

    if ListedEntities[entityId] then -- Devtools / Injection (Entity has already been looted).
        
        if Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Enabled then
            local _w, _c      = Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Url, Config.Webhooks['DEVTOOLS_INJECTION_CHEAT'].Color
            local description = 'The specified user attempted to use devtools / injection cheat on npc loot reward.'
            TPZ.SendToDiscordWithPlayerParameters(_w, Locales['DEVTOOLS_INJECTION_DETECTED_TITLE_LOG'], _source, PlayerData.steamName, PlayerData.username, PlayerData.identifier, PlayerData.charIdentifier, description, _c)
        end

        xPlayer.disconnect(Locales['DEVTOOLS_INJECTION_DETECTED'])
        return
    end

    
end)