local Manager  = require("NierUI.Helpers.Manager")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Config    = require("NierUI.Config")

-- app.EnemyCharacter:get_field("_MiniComponentHolder"):get_field("_DamageCounter") => app.mcEnemyDamageCounter

d2d.register(
    function() end,
    function()
        local HunterCharacter = Manager.Player:call("getMasterPlayerInfo"):get_field("<Character>k__BackingField")
        if not HunterCharacter then return end
        if Manager.GUI:isMouseCursorAvailable() then return end

        -- local EnemyCharacter = Manager.Enemy:call("getMasterPlayerInfo"):get_field("<Character>k__BackingField")
        -- if not HunterCharacter then return end

        d2d.text(
            Font.Default, 
            "TEST", -- T
            20, -- X
            20, -- Y 
            Color.Default
        )
    end
)