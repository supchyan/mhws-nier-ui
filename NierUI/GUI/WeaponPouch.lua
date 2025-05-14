local Managers  = require("NierUI.Helpers.Managers")
local Color     = require("NierUI.Helpers.Color")
local Weapon    = require("NierUI.Helpers.Weapon")
local Font      = require("NierUI.Helpers.Font")
local Kireaji   = require("NierUI.Helpers.Kireaji")
local Config    = require("NierUI.Config")

local DefaultPos    = Config.WeaponSelect_Pos
local _S            = Config.UI_Scale


local oldSelectedWpID = 0
local oldClock = os.clock()

d2d.register(
    function() end,
    function()
        local cPlayerManageInfo = Managers.Player:getMasterPlayerInfo()
        local cHunterCreateInfo = Managers.Player:getHunterCreateInfo()
        local HunterCharacter   = cPlayerManageInfo:get_field("<Character>k__BackingField")

        if not HunterCharacter then return end
        if Managers.GUI:isMouseCursorAvailable() then return end

        function PosX()
            return _S * DefaultPos.X
        end
        function PosY()
            return _S * DefaultPos.Y
        end

        -- SELECTED WEAPON DRAW PROP.
        local SWP_BarBox = { 
            W = _S * 265, 
            H = _S * 80 
        }
        local SWP_BarDefPos = { 
            X = PosX(),
            Y = PosY()
        }
        local SWP_TypeNameDefPos = { 
            X = PosX() + _S * 20,
            Y = PosY() + SWP_BarBox.H / 2 - _S * 20
        }
        local SWP_DescDefPos = { 
            X = PosX() + _S * 20,
            Y = PosY() + SWP_BarBox.H / 2 + _S * 20 - _S * 16
        }

        local SWP_BarPos        = SWP_BarDefPos
        local SWP_TypeNamePos   = SWP_TypeNameDefPos
        local SWP_DescPos       = SWP_DescDefPos
        
        -- REVERSE WEAPON DRAW PROP.
        local RWP_BarBox = { 
            W = _S * 265, 
            H = _S * 56
        }
        local RWP_BarPos = { 
            X = PosX(),
            Y = PosY() + SWP_BarBox.H
        }
        local RWP_TypeNamePos = { 
            X = PosX() + _S * 20,
            Y = SWP_TypeNamePos.Y + SWP_BarBox.H
        }

        -- OBJECTS
        local cHunterStatus         = HunterCharacter:get_HunterStatus()
        local cHunterAttackPower    = cHunterStatus:get_AttackPower()
        local cHunterCritical       = cHunterStatus:get_CriticalRate()

        -- SELECTED ONLY
        local WP_ATTR = cHunterAttackPower:get_AttibuteType()

        -- WP DATA
        local S_Weapon      = HunterCharacter:get_Weapon()
        local SWP_Data      = S_Weapon:get_WpData()
        local SWP_Type      = S_Weapon:get_WpType()
        local SWP_ID        = cHunterCreateInfo:get_WpID()
        local SWP_TypeName  = Weapon.TypeName[SWP_Type + 1]
        local SWP_AttrName  = Weapon.AttrName[WP_ATTR  + 1]
        local SWP_Desc      = "["..tostring(SWP_ID).."]".." [Attribute: "..tostring(SWP_AttrName).."]"

        local R_Weapon      = HunterCharacter:get_ReserveWeapon()
        local RWP_Data      = R_Weapon._WpData
        local RWP_Type      = R_Weapon:get_WpType()
        local RWP_ID        = cHunterCreateInfo:get_ReserveWpID()           -- UNUSED --
        local RWP_TypeName  = Weapon.TypeName[R_Weapon:get_WpType() + 1]    -- UNUSED --
        local SWP_AttrName  = nil                                           -- UNUSED --
        local RWP_Desc      = "["..tostring(RWP_ID).."]"                    -- UNUSED --

        -- app.user_data.WeaponData.cData  WeaponDef:Data(app.WeaponDef.TYPE, System.Int32)

        -- local WP_BagType   = Weapon[Weapon:get_WeaponBagType() + 1]

        -- app.cHunterWeaponHanldingBase
        -- local WeaponHBase   = HunterCharacter:get_WeaponHandling()

        if oldSelectedWpID ~= SWP_ID then
            local _val = math.abs(math.cos(12. * (os.clock() - oldClock)))
            SWP_BarPos.Y        = SWP_BarDefPos.Y       + RWP_BarBox.H * _val
            SWP_TypeNamePos.Y   = SWP_TypeNameDefPos.Y  + RWP_BarBox.H * _val
            SWP_DescPos.Y       = SWP_DescDefPos.Y      + RWP_BarBox.H * _val

            if _val < 0.2 then
                oldSelectedWpID = SWP_ID
            end
        else
            oldClock = os.clock()
        end
        

        -- REVERSE WEAPON DRAW CALLS
        d2d.fill_rect(
            RWP_BarPos.X, -- X
            RWP_BarPos.Y, -- Y
            RWP_BarBox.W, -- W
            RWP_BarBox.H, -- H
            Color.Grey
        )
        d2d.text(
            Font.Large,
            "IN POUCH: "..RWP_TypeName, -- T
            RWP_TypeNamePos.X, -- X
            RWP_TypeNamePos.Y, -- Y 
            Color.dDefault
        )

        -- SELECTED WEAPON DRAW CALLS
        d2d.fill_rect(
            SWP_BarPos.X, -- X
            SWP_BarPos.Y, -- Y
            SWP_BarBox.W, -- W
            SWP_BarBox.H, -- H
            Color.Default
        )
        d2d.text( -- TEXT SHADOW
            Font.Large,
            "SELECTED: "..SWP_TypeName, -- T
            SWP_TypeNamePos.X - 1, -- X
            SWP_TypeNamePos.Y + 1, -- Y 
            Color.dGrey
        )
        d2d.text(
            Font.Large,
            "SELECTED: "..SWP_TypeName, -- T
            SWP_TypeNamePos.X, -- X
            SWP_TypeNamePos.Y, -- Y 
            Color.Grey
        )
        d2d.text( -- TEXT SHADOW
            Font.Default,
            SWP_Desc, -- T
            SWP_DescPos.X - 1, -- X
            SWP_DescPos.Y + 1, -- Y 
            Color.dGrey
        )
        d2d.text(
            Font.Default,
            SWP_Desc, -- T
            SWP_DescPos.X, -- X
            SWP_DescPos.Y, -- Y 
            Color.Grey
        )
    end
)