local Managers  = require("NierUI.Helpers.Managers")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Config    = require("NierUI.Config")

local DefaultPos    = Config.Minimap_Pos
local _S            = Config.UI_Scale

d2d.register(
    function() end,
    function()
        if Managers.GUI:isMouseCursorAvailable() then return end

        function PosX()
            return _S * DefaultPos.X
        end
        function PosY()
            return _S * DefaultPos.Y
        end

        local MinimapOutline        = _S * 3

        local MinimapBox            = { H = _S * 250, W = _S * 250 }
        local MinimapOutlineBox     = { 
            H = 4 * MinimapOutline + MinimapBox.W, 
            W = 4 * MinimapOutline + MinimapBox.H 
        }

        local NoMinimapMessagePos = { 
            X = PosX() + .5 * MinimapOutlineBox.W - _S * 44,
            Y = PosY() + .5 * MinimapOutlineBox.W - _S * 17 
        }
        local WipMessagePos = { 
            X = PosX() + .5 * MinimapOutlineBox.W - _S * 44, -- X
            Y = PosY() + .5 * MinimapOutlineBox.W + _S * 3, -- Y 
        }

        d2d.fill_rect(
            2 * MinimapOutline + PosX(), -- X
            2 * MinimapOutline + PosY(), -- Y
            MinimapBox.W, -- W
            MinimapBox.H, -- H
            Color.dDefault
        )

        d2d.outline_rect(
            PosX(), -- X
            PosY(), -- Y
            MinimapOutlineBox.W, -- W
            MinimapOutlineBox.H, -- H
            MinimapOutline,
            Color.dDefault
        )

        -- NO MINIMAP ALERT + SHADOW
        d2d.text(
            Font.Large,
            "NO MINIMAP", -- T
            NoMinimapMessagePos.X - 1, -- X
            NoMinimapMessagePos.Y + 1, -- Y
            Color.dGrey
        )
        d2d.text(
            Font.Large,
            "NO MINIMAP", -- T
            NoMinimapMessagePos.X, -- X
            NoMinimapMessagePos.Y, -- Y
            Color.Grey
        )

        -- WIP ALERT + SHADOW
        d2d.text(
            Font.Large,
            "[0x0 AREA]", -- T
            WipMessagePos.X - 1, -- X
            WipMessagePos.Y + 1, -- Y
            Color.fdGrey(0.8)
        )
        d2d.text(
            Font.Large,
            "[0x0 AREA]", -- T
            WipMessagePos.X, -- X
            WipMessagePos.Y, -- Y
            Color.fGrey(0.8)
        )
    end
)