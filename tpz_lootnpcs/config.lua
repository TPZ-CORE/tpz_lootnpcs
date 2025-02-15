Config = {}

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
--[[ General ]]--
-----------------------------------------------------------

-- weapons: Use UPPERCASE letters on the @Name for the system to read if the given reward is a weapon. 

-- accounts (money): Use "CASH", "GOLD" or "BLACK_MONEY" who are available as default on @Name parameter for the
-- system to read if the given reward is money. 

-- items: Use anything except as @weapons or @accounts mention. 

Config.RandomRewards = {

   MaximumRewards = { min = 1, max = 2 }, -- How many rewards should it give on pickup?

   Rewards = { -- Always use Index Numbers ( [1], [2].. ) so the system will loop again to find new reward result and not the same. 

        [1] = { Name = "CASH", Chance = 50, Quantity = { min = 5, max = 10 } },

    },
}
