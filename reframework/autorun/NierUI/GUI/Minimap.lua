local Manager   = require("NierUI.Helpers.Manager")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Config    = require("NierUI.Config")

local DefaultPos = { 
    X = 62 + Config.Minimap_PosOffset.X,
    Y = -315 + Config.Minimap_PosOffset.Y 
}
local _S            = Config.UI_Scale
local useAlphaTrick = true

local Clock = {
    Alpha = os.clock()
}

-- FLOATING ALPHA 0xF -> 0x0
function AlphaTrick()
    if not useAlphaTrick then return 0x00000000 end
    local _val = math.floor(math.abs(math.cos(4. * (os.clock() - Clock.Alpha))) * 255)
    useAlphaTrick = _val > 32
    return "0x"..string.format("%x", _val).."000000"
end
function ResetAlphaTrick()
    Clock.Alpha     = os.clock()
    useAlphaTrick   = true
end

d2d.register(
    function() end,
    function()
        local  HunterCharacter = Manager.Player:call("getMasterPlayerInfo"):get_field("<Character>k__BackingField")
        if not HunterCharacter then return end
        if Manager.GUI:isMouseCursorAvailable() then 
            ResetAlphaTrick()
            return 
        end

        local ScreenWidth, ScreenHeight = d2d.surface_size()

        function PosX()
            return _S * DefaultPos.X
        end
        function PosY()
            return ScreenHeight + _S * DefaultPos.Y
        end

        local MinimapOutline        = _S * 3

        local MinimapBox            = { H = _S * 250, W = _S * 250 }
        local MinimapOutlineBox     = { 
            H = 4 * MinimapOutline + MinimapBox.W, 
            W = 4 * MinimapOutline + MinimapBox.H 
        }

        local NoMinimapMessage  = "NO MINIMAP"
        local WipMessageMessage = "[0x0 AREA]"

        local NoMinimapMessageWidth, NoMinimapMessageHeight   = Font.Default:measure(NoMinimapMessage)
        local WipMessageMessageWidth, WipMessageMessageHeight = Font.Default:measure(WipMessageMessage)

        local NoMinimapMessagePos = { 
            X = PosX() + .5 * MinimapOutlineBox.W - .5 * NoMinimapMessageWidth,
            Y = PosY() + .5 * MinimapOutlineBox.H - NoMinimapMessageHeight
        }
        local WipMessagePos = { 
            X = PosX() + .5 * MinimapOutlineBox.W - .5 * WipMessageMessageWidth,
            Y = PosY() + .5 * MinimapOutlineBox.H,
        }

        d2d.fill_rect(
            2 * MinimapOutline + PosX(), -- X
            2 * MinimapOutline + PosY(), -- Y
            MinimapBox.W, -- W
            MinimapBox.H, -- H
            Color.dDefault - AlphaTrick()
        )

        d2d.outline_rect(
            PosX(), -- X
            PosY(), -- Y
            MinimapOutlineBox.W, -- W
            MinimapOutlineBox.H, -- H
            MinimapOutline,
            Color.dDefault - AlphaTrick()
        )

        -- NO MINIMAP ALERT + SHADOW
        d2d.text(
            Font.Large,
            NoMinimapMessage, -- T
            NoMinimapMessagePos.X - 1, -- X
            NoMinimapMessagePos.Y + 1, -- Y
            Color.dGrey - AlphaTrick()
        )
        d2d.text(
            Font.Large,
            NoMinimapMessage, -- T
            NoMinimapMessagePos.X, -- X
            NoMinimapMessagePos.Y, -- Y
            Color.Grey - AlphaTrick()
        )

        -- WIP ALERT + SHADOW
        d2d.text(
            Font.Large,
            WipMessageMessage, -- T
            WipMessagePos.X - 1, -- X
            WipMessagePos.Y + 1, -- Y
            Color.fdGrey(0.8) - AlphaTrick()
        )
        d2d.text(
            Font.Large,
            WipMessageMessage, -- T
            WipMessagePos.X, -- X
            WipMessagePos.Y, -- Y
            Color.fGrey(0.8) - AlphaTrick()
        )
    end
)