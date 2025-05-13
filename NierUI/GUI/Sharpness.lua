local Managers  = require("NierUI.Helpers.Managers")
local Colors    = require("NierUI.Helpers.Colors")
local Fonts     = require("NierUI.Helpers.Fonts")
local Weapons   = require("NierUI.Helpers.Weapons")
local Kireaji   = require("NierUI.Helpers.Kireaji")
local Config    = require("NierUI.Config")

local DefaultPos    = Config.Kireaji_Pos
local _S            = Config.UI_Scale

-- EMIL 
local Emil_Offset = 0
local OldClock    = os.clock()

d2d.register(
    function() end,
    function()
        local HunterCharacter = Managers.Player:call("getMasterPlayerInfo"):get_field("<Character>k__BackingField")
        if not HunterCharacter then return end
        if Managers.GUI:isMouseCursorAvailable() then return end

        function PosX()
            return _S * DefaultPos.X
        end
        function PosY(index)
            return _S * DefaultPos.Y
        end

        -- GLOBAL
        local OuterR = _S * 12
        local InnerR = _S * 6

        -- WP PROPERTIES
        local _Weapon       = HunterCharacter:get_Weapon()
        local WP_Type       = _Weapon:get_WpType()

        -- app.cHunterWeaponHanldingBase
        local WeaponHBase   = HunterCharacter:get_WeaponHandling()

        -- Kireaji => Sharpness (Jp.)

        -- app.cWeaponKireaji
        local _Kireaji      = WeaponHBase:get_Kireaji() 
        local KI_Type       = _Kireaji:get_CurrentType()
        local KI_MaxType    = _Kireaji:get_MaxKireajiType()
        local KI_Offset     = _Kireaji:get_CurrentRate()
        local KI_BgColor    = Colors.White
        local KI_Color      = Colors.White

        -- KIREAJI ENUM INFO
        -- WHITE IS '5'
        -- GREEN IS '3'
        if KI_Type == Kireaji.White then
            KI_BgColor  = Colors.Blue
            KI_Color    = Colors.White
        end
        if KI_Type == Kireaji.Blue then
            KI_BgColor  = Colors.Green
            KI_Color    = Colors.Blue
        end
        if KI_Type == Kireaji.Green then
            KI_BgColor  = Colors.Yellow
            KI_Color    = Colors.Green
        end
        if KI_Type == Kireaji.Yellow then
            KI_BgColor  = Colors.Orange
            KI_Color    = Colors.Yellow
        end
        if KI_Type == Kireaji.Orange then
            KI_BgColor  = Colors.Red
            KI_Color    = Colors.Orange
        end
        if KI_Type == Kireaji.Red then
            KI_BgColor  = Colors.Grey
            KI_Color    = Colors.Red
        end

        if (_Kireaji:get_IsMaxKireaji() and KI_Type == Kireaji.White) or WeaponHBase:get_IsGunner() then
            -- DRAW EMIL'S HEAD ON FULL WHITE KIREAJI
            if Emil_Offset < 0.995 then
                Emil_Offset = math.abs(math.sin(6. * (os.clock() - OldClock)))
            end

            d2d.fill_circle(
                PosX(), PosY(), 
                OuterR, 
                Colors.White
            )
            d2d.fill_circle(
                PosX() - Emil_Offset * _S * 5, PosY() - Emil_Offset * _S * .5, 
                InnerR * (1. - Emil_Offset * .5), 
                Colors.Grey
            )
            d2d.fill_circle(
                PosX() + Emil_Offset * _S * 5, PosY() - Emil_Offset * _S * .5, 
                InnerR * (1. - Emil_Offset * .5), 
                Colors.Grey
            )
        else
            -- RESET EMIL ANIM. INFO
            Emil_Offset = 0
            OldClock    = os.clock()
            
            -- RING FILLS AS A CLOCK ACCORDING TO THE CURRENT KIREAJI VALUE.
            -- ALSO, IT CHANGES COLOR, DEPENDING ON KIREAJI'S STATE (TYPE..)
            d2d.ring(
                PosX(), PosY(), -- XY
                OuterR, InnerR, -- IN/OUT/ RADIUS
                0, 360, -- ANG/SWEEP
                KI_BgColor
            )
            d2d.ring(
                PosX(), PosY(), -- XY
                OuterR, InnerR, -- IN/OUT/ RADIUS
                270, 360. * KI_Offset, -- ROT/SWEEP
                KI_Color
            )
        end
    end
)