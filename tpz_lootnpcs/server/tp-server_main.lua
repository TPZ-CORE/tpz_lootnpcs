local TPZ = exports.tpz_core:getCoreAPI()

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

-------------------------------------------------------------
--[[ Events  ]]--
-------------------------------------------------------------

RegisterServerEvent("tpz_lootnpcs:server:reward")
AddEventHandler("tpz_lootnpcs:server:reward", function(entityId)
    local _source          = source 
    local PlayerData       = GetPlayerData(_source)
    local xPlayer          = TPZ.GetPlayer(_source)

end)