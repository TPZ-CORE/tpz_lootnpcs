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

Config.RandomRewards = {

    Accounts = { 
        Enabled = true, 

        Chance = 100, -- the chance to get money reward / not. 

        Types = {

            [0] = { -- 0 returns dollars.
                Quantity = { min = 5, max = 10 },
                Chance = 100, -- the chance to receive between 5-10 dollars. 
            },

        },

    },

}
