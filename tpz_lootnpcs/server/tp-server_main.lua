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

        return
    end

    
end)