Config = {}

-----------------------------------------------------------
--[[ General ]]--
-----------------------------------------------------------

-- [accounts (money)]: Use "0", "1" or "2" for the system to read the specified inputs as money.
-- "0" : dollars
-- "1" : gold
-- "2" : black money.

-- [weapons]: Use UPPERCASE letters on the @Name for the system to read if the given reward is a weapon. 
-- [items]: Use anything except as @weapons or @accounts mention. 

-- @quantity : QUANTITY ON WEAPONS IS ALWAYS (1), quantity parameter will never work!
Config.RandomRewards = {

   MaximumRewards = { min = 1, max = 2 }, -- How many rewards should it give on pickup?

   Rewards = { 
        { name = "0", label = 'Dollars', chance = 100, quantity = { min = 5, max = 10 } },
        { name = "ammoriflenormal", label = 'Ammo Rifle', chance = 100, quantity = { min = 2, max = 5 } },
    },
}

-----------------------------------------------------------
--[[ Discord Webhooking ]]--
-----------------------------------------------------------

Config.Webhooks = {
    
    ['DEVTOOLS_INJECTION_CHEAT'] = { -- Warnings and Logs about players who used or atleast tried to use devtools injection.
        Enabled = false, 
        Url = "", 
        Color = 10038562,
    },

    ['LOOTED'] = {
        Enabled = false, 
        Url = "", 
        Color = 10038562,
    },

}

-----------------------------------------------------------
--[[ Notification Functions  ]]--
-----------------------------------------------------------

-- @param source is always null when called from client.
-- @type returns "success" or "error" based on actions.
function SendNotification(source, message, type)
    local duration = 3000

    if not source then
        TriggerEvent('tpz_core:sendBottomTipNotification', message, duration)
    else
        TriggerClientEvent('tpz_core:sendBottomTipNotification', source, message, duration)
    end

end
