local Manager   = require("NierUI.Helpers.Manager")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Weapon    = require("NierUI.Helpers.Weapon")
local Guid      = require("NierUI.Helpers.Guid")
local Config    = require("NierUI.Config")

local DefaultPos = { 
    X = 60 + Config.WeaponPouch_PosOffset.X, 
    Y = -440 + Config.WeaponPouch_PosOffset.Y
}
local _S                = Config.UI_Scale
local useAlphaTrick     = true

local OldSWP_ID           = nil
local OldSWP_TypeName     = nil
local OldSWP_AttrName     = nil

local Clock     = {
    WpSwitch    = os.clock(),
    Alpha       = os.clock()
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
        local cPlayerManageInfo = Manager.Player:getMasterPlayerInfo()
        local cHunterCreateInfo = Manager.Player:getHunterCreateInfo()
        local HunterCharacter   = cPlayerManageInfo:get_field("<Character>k__BackingField")

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

        -- OBJECTS
        local cHunterStatus         = HunterCharacter:get_HunterStatus()
        local cHunterAttackPower    = cHunterStatus:get_AttackPower()
        local cHunterCritical       = cHunterStatus:get_CriticalRate()

        -- app.cHunterWeaponHandlingBase => get_ReserveShellWeaponAttrType()

        -- SELECTED ONLY

        -- SELECTED WP DATA
        local SWP_Handle    = HunterCharacter:get_WeaponHandling()
        local SWP_TYPE      = HunterCharacter:get_WeaponType()
        local SWP_ID        = HunterCharacter:get_WeaponID()
        local SWP_ATTR      = cHunterAttackPower:get_AttibuteType()
        local SWP_GUID      = Guid.Weapon.Name(nil, SWP_TYPE, SWP_ID)
        local SWP_TypeName  = Weapon.TypeName[SWP_TYPE + 1]
        local SWP_AttrName  = Weapon.AttrName[SWP_ATTR + 1]
        local SWP_Title     = Guid.ToString(nil, SWP_GUID) -- пусто
        local SWP_Desc      = tostring(SWP_TypeName).." ["..tostring(SWP_AttrName).."]"

        local SWP_TitleWidth, SWP_TitleHeight   = Font.Default:measure(SWP_Title)
        local SWP_DescWidth, SWP_DescHeight     = Font.Default:measure(SWP_Desc)

        -- RESERVE WP DATA
        local RWP_Handle    = HunterCharacter:get_ReserveWeaponHandling()
        local RWP_TYPE      = HunterCharacter:get_ReserveWeaponType()
        local RWP_ID        = HunterCharacter:get_ReserveWeaponID()       
        local RWP_ATTR      = nil                                           -- UNUSED --
        local RWP_GUID      = Guid.Weapon.Name(nil, RWP_TYPE, RWP_ID)    
        local RWP_TypeName  = Weapon.TypeName[RWP_TYPE + 1]    
        local RWP_AttrName  = nil                                           -- UNUSED --
        local RWP_Title     = Guid.ToString(nil, RWP_GUID)
        local RWP_Desc      = "["..tostring(RWP_TypeName).."]"              -- UNUSED --
        
        local RWP_TitleWidth, RWP_TitleHeight   = Font.Default:measure(RWP_Title)
        local RWP_DescWidth, RWP_DescHeight     = Font.Default:measure(RWP_Desc)

        -- SELECTED WEAPON DRAW MATH
        local SWP_BarMargin = _S * 2
        local SWP_BarBox = { 
            W = _S * 266, 
            H = 3 * SWP_TitleHeight + SWP_DescHeight + 4 * SWP_BarMargin
        }
        local SWP_BarDefPos = { 
            X = PosX(),
            Y = PosY()
        }
        local SWP_TypeNameDefPos = { 
            X = PosX() + _S * 20,
            Y = PosY() + .5 * SWP_BarBox.H - RWP_TitleHeight - SWP_BarMargin
        }
        local SWP_DescDefPos = { 
            X = PosX() + _S * 20,
            Y = PosY() + .5 * SWP_BarBox.H + SWP_BarMargin
        }

        local SWP_BarPos        = SWP_BarDefPos
        local SWP_TypeNamePos   = SWP_TypeNameDefPos
        local SWP_DescPos       = SWP_DescDefPos
        
        -- RESERVE WEAPON DRAW MATH
        local RWP_BarBox = { 
            W = _S * 266, 
            H = 3 * RWP_TitleHeight
        }
        local RWP_BarPos = { 
            X = SWP_BarDefPos.X,
            Y = SWP_BarDefPos.Y + SWP_BarBox.H
        }
        local RWP_TypeNamePos = { 
            X = RWP_BarPos.X + _S * 20,
            Y = RWP_BarPos.Y + RWP_TitleHeight
        }

        if OldSWP_ID ~= SWP_ID or OldSWP_TypeName ~= SWP_TypeName or OldSWP_AttrName ~= SWP_AttrName then
            local _val = math.abs(math.cos(8. * (os.clock() - Clock.WpSwitch)))
            SWP_BarPos.Y        = SWP_BarDefPos.Y       + _val * RWP_BarBox.H
            SWP_TypeNamePos.Y   = SWP_TypeNameDefPos.Y  + _val * RWP_BarBox.H
            SWP_DescPos.Y       = SWP_DescDefPos.Y      + _val * RWP_BarBox.H

            if _val < .4 then
                OldSWP_ID         = SWP_ID
                OldSWP_TypeName   = SWP_TypeName
                OldSWP_AttrName   = SWP_AttrName
            end
        else
            Clock.WpSwitch = os.clock()
        end

        -- RESERVE WEAPON DRAW CALLS
        d2d.fill_rect(
            RWP_BarPos.X, -- X
            RWP_BarPos.Y, -- Y
            RWP_BarBox.W, -- W
            RWP_BarBox.H, -- H
            Color.Grey - AlphaTrick()
        )
        d2d.text(
            Font.Large,
            RWP_Title, -- T
            RWP_TypeNamePos.X, -- X
            RWP_TypeNamePos.Y, -- Y 
            Color.dDefault - AlphaTrick()
        )

        -- SELECTED WEAPON DRAW CALLS
        d2d.fill_rect(
            SWP_BarPos.X, -- X
            SWP_BarPos.Y, -- Y
            SWP_BarBox.W, -- W
            SWP_BarBox.H, -- H
            Color.Default - AlphaTrick()
        )
        d2d.text( -- TEXT SHADOW
            Font.Large,
            SWP_Title, -- T
            SWP_TypeNamePos.X - 1, -- X
            SWP_TypeNamePos.Y + 1, -- Y 
            Color.dGrey - AlphaTrick()
        )
        d2d.text(
            Font.Large,
            SWP_Title, -- T
            SWP_TypeNamePos.X, -- X
            SWP_TypeNamePos.Y, -- Y 
            Color.Grey - AlphaTrick()
        )
        d2d.text( -- TEXT SHADOW
            Font.Default,
            SWP_Desc, -- T
            SWP_DescPos.X - 1, -- X
            SWP_DescPos.Y + 1, -- Y 
            Color.dGrey - AlphaTrick()
        )
        d2d.text(
            Font.Default,
            SWP_Desc, -- T
            SWP_DescPos.X, -- X
            SWP_DescPos.Y, -- Y 
            Color.Grey - AlphaTrick()
        )
    end
)