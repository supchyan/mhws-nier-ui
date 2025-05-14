local Managers  = require("NierUI.Helpers.Managers")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Config    = require("NierUI.Config")

-- app.EnemyCharacter:get_field("_MiniComponentHolder"):get_field("_DamageCounter") => app.mcEnemyDamageCounter

d2d.register(
    function() end,
    function()
        local HunterCharacter = Managers.Player:call("getMasterPlayerInfo"):get_field("<Character>k__BackingField")
        if not HunterCharacter then return end
        if Managers.GUI:isMouseCursorAvailable() then return end

        -- local EnemyCharacter = Managers.Enemy:call("getMasterPlayerInfo"):get_field("<Character>k__BackingField")
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