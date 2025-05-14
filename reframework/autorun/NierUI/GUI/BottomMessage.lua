local Manager   = require("NierUI.Helpers.Manager")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Config    = require("NierUI.Config")

-- app.EnemyCharacter:get_field("_MiniComponentHolder"):get_field("_DamageCounter") => app.mcEnemyDamageCounter

local _S = Config.UI_Scale

d2d.register(
    function() end,
    function()
        local  HunterCharacter = Manager.Player:call("getMasterPlayerInfo"):get_field("<Character>k__BackingField")
        if not HunterCharacter then return end
        if Manager.GUI:isMouseCursorAvailable() then return end

        local ScreenWidth, ScreenHeight = d2d.surface_size()

        local DebugMessage = "[WORK IN PROGRESS]"
        local MessageWidth, MessageHeight = Font.Default:measure(DebugMessage)

        local Margin = _S * 10

        local Box = {
            W = MessageWidth + 2 * Margin,
            H = MessageHeight + 2 * Margin
        }
        local BoxPos = {
            X = .5 * ScreenWidth - .5 * Box.W,
            Y = ScreenHeight - Box.H - Margin
        }

        d2d.fill_rect(
            BoxPos.X, -- X
            BoxPos.Y, -- Y 
            Box.W, -- W
            Box.H, -- H
            Color.dGrey
        )
        d2d.text(
            Font.Default, 
            DebugMessage,
            BoxPos.X + Margin,
            BoxPos.Y + Margin,
            Color.Default
        )
    end
)