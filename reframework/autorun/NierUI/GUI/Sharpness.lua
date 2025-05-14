local Manager   = require("NierUI.Helpers.Manager")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Config    = require("NierUI.Config")
local Kireaji   = require("NierUI.Helpers.Kireaji")

local DefaultPos = { 
    X = 70 + Config.Kireaji_PosOffset.X, 
    Y = 96 + Config.Kireaji_PosOffset.Y
}
local _S = Config.UI_Scale
local useAlphaTrick = true

-- EMIL 
local Emil_Offset = 0

local Clock = {
    Emil    = os.clock(),
    Alpha   = os.clock()
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
        local Weapon        = HunterCharacter:get_Weapon()
        local WP_Type       = Weapon:get_WpType()

        -- app.cHunterWeaponHanldingBase
        local WeaponHBase   = HunterCharacter:get_WeaponHandling()

        -- Kireaji => Sharpness (Jp.)

        -- app.cWeaponKireaji
        local _Kireaji      = WeaponHBase:get_Kireaji() 
        local KI_Type       = _Kireaji:get_CurrentType()
        local KI_MaxType    = _Kireaji:get_MaxKireajiType()
        local KI_Offset     = _Kireaji:get_CurrentRate()
        local KI_BgColor    = Color.White
        local KI_Color      = Color.White

        -- KIREAJI ENUM INFO
        -- WHITE IS '5'
        -- GREEN IS '3'
        if KI_Type == Kireaji.White then
            KI_BgColor  = Color.Blue
            KI_Color    = Color.White
        end
        if KI_Type == Kireaji.Blue then
            KI_BgColor  = Color.Green
            KI_Color    = Color.Blue
        end
        if KI_Type == Kireaji.Green then
            KI_BgColor  = Color.Yellow
            KI_Color    = Color.Green
        end
        if KI_Type == Kireaji.Yellow then
            KI_BgColor  = Color.Orange
            KI_Color    = Color.Yellow
        end
        if KI_Type == Kireaji.Orange then
            KI_BgColor  = Color.Red
            KI_Color    = Color.Orange
        end
        if KI_Type == Kireaji.Red then
            KI_BgColor  = Color.Grey
            KI_Color    = Color.Red
        end

        if (_Kireaji:get_IsMaxKireaji() and KI_Type == Kireaji.White) or WeaponHBase:get_IsGunner() then
            if Emil_Offset < 0.995 then
                Emil_Offset = math.abs(math.sin(6. * (os.clock() - Clock.Emil)))
            end

            -- DRAW EMIL'S HEAD ON FULL WHITE KIREAJI
            d2d.fill_circle(
                PosX(), PosY(), 
                OuterR, 
                Color.White - AlphaTrick()
            )
            d2d.fill_circle(
                PosX() - Emil_Offset * _S * 5, PosY() - Emil_Offset * _S * .5, 
                InnerR * (1. - Emil_Offset * .5), 
                Color.Grey - AlphaTrick()
            )
            d2d.fill_circle(
                PosX() + Emil_Offset * _S * 5, PosY() - Emil_Offset * _S * .5, 
                InnerR * (1. - Emil_Offset * .5), 
                Color.Grey - AlphaTrick()
            )
        else
            -- RESET EMIL ANIM. INFO
            Emil_Offset = 0
            Clock.Emil  = os.clock()
            
            -- RING FILLS AS A CLOCK ACCORDING TO THE CURRENT KIREAJI VALUE.
            -- ALSO, IT CHANGES COLOR, DEPENDING ON KIREAJI'S STATE (TYPE..)
            d2d.ring(
                PosX(), PosY(), -- XY
                OuterR, InnerR, -- IN/OUT/ RADIUS
                0, 360, -- ANG/SWEEP
                KI_BgColor - AlphaTrick()
            )
            d2d.ring(
                PosX(), PosY(), -- XY
                OuterR, InnerR, -- IN/OUT/ RADIUS
                270, 360. * KI_Offset, -- ROT/SWEEP
                KI_Color - AlphaTrick()
            )
        end
    end
)