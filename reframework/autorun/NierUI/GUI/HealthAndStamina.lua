local Manager  = require("NierUI.Helpers.Manager")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Config    = require("NierUI.Config")

local DefaultPos    = Config.HpSt_Pos
local _S            = Config.UI_Scale
local HP_BarSize    = { X = _S * 200, Y = _S * 12 }
local ST_BarSize    = { X = _S * 200, Y = _S * 6  }
local SE_BarSize    = { X = _S * 200, Y = _S * 3  }
local HpStOffset    = _S * 4 -- Offset to make HP/ST bars bigger

d2d.register(
    function() end,
    function()
        local HunterCharacter = Manager.Player:call("getMasterPlayerInfo"):get_field("<Character>k__BackingField")
        if not HunterCharacter then return end
        if Manager.GUI:isMouseCursorAvailable() then return end

        function PosX()
            return _S * DefaultPos.X
        end
        function PosY(index)
            return _S * DefaultPos.Y + index * HP_BarSize.Y
        end

        -- HUNTER STATUS INFO PROPERTIES
        local Net_SocialUserInfo    = nil
        local StatusColor           = Color.fDefault(1.5)
        local StatusInfo            = "[OFFLINE]"

        if not Net_SocialUserInfo then -- LOBBY
            Net_SocialUserInfo = Manager.Network:get_UserInfoManager():getSelfUserInfo(1, 0)
        end
        if not Net_SocialUserInfo then -- QUEST
            Net_SocialUserInfo = Manager.Network:get_UserInfoManager():getSelfUserInfo(2, 0)
        end
        if not Net_SocialUserInfo then -- LINK
            Net_SocialUserInfo = Manager.Network:get_UserInfoManager():getSelfUserInfo(3, 0)
        end
        if not Net_SocialUserInfo then -- MEMORIES
            Net_SocialUserInfo = Manager.Network:get_UserInfoManager():getSelfUserInfo(4, 0)
        end

        if Net_SocialUserInfo then
            -- "HP: "..string.format("%.0f", HP).."", -- NetworkManager:get_field("_UserName") 
            StatusInfo  = "["..Net_SocialUserInfo:get_PlName()..", Lv"..tostring(Net_SocialUserInfo:get_HunterRank()).."]"
            StatusColor = Color.Default
        end

        -- HEALTH PROPERTIES
        local HealthManager = HunterCharacter:get_HunterHealth():get_HealthMgr()
        local HP            = HealthManager:get_Health()
        local MaxHP         = HealthManager:get_MaxHealth()
        local RedHP         = HunterCharacter:get_HunterHealth():get_RedHealth() -- recoverable health
        
        -- STAMINA PROPERTIES
        local HunterStamina = HunterCharacter:get_HunterStamina()
        local ST            = HunterStamina:get_Stamina()
        local MaxST         = HunterStamina:get_MaxStamina()

        -- VERTICAL LEFT LINE
        d2d.fill_rect(
            PosX() - _S * 9, -- X
            PosY(2), -- Y 
            SE_BarSize.Y, -- W
            HP_BarSize.Y + SE_BarSize.Y + ST_BarSize.Y + 2 * ST_BarSize.Y, -- H 
            Color.dDefault
        )

        -- PLAYER STATUS DRAW CALLS
        d2d.text(
            Font.Large, 
            StatusInfo, -- T 
            PosX(), -- X
            PosY(0), -- Y 
            StatusColor
        )

        -- HEALTH DRAW CALLS
        d2d.fill_rect(
            PosX(), -- X
            PosY(2), -- Y
            HpStOffset * MaxHP, -- W
            HP_BarSize.Y, -- H
            Color.Grey
        )
        d2d.fill_rect(
            PosX(), -- X
            PosY(2), -- Y
            HpStOffset * RedHP, -- W
            HP_BarSize.Y, -- H
            Color.Orange
        )
        d2d.fill_rect(
            PosX(), -- X
            PosY(2), -- Y 
            HpStOffset * HP, -- W
            HP_BarSize.Y, -- H
            Color.Default
        )
        
        -- SEPARATOR (HP RELATED) DRAW CALLS
        d2d.fill_rect(
            PosX(), -- X
            PosY(3.5), -- Y 
            _S * 5, -- W
            SE_BarSize.Y, -- H
            Color.dDefault
        )
        d2d.fill_rect(
            _S * 10 + PosX(), -- X
            PosY(3.5), -- Y
            HpStOffset * MaxHP * .34 - _S * 10, -- W
            SE_BarSize.Y, -- H
            Color.dDefault
        )
        d2d.fill_rect(
            PosX() + HpStOffset * MaxHP * .34 + _S * 5, -- X 
            PosY(3.5), -- Y 
            HpStOffset * MaxHP * .66 - _S * 15, -- W
            SE_BarSize.Y, -- H
            Color.dDefault
        )
        d2d.fill_rect(
            PosX() + HpStOffset * MaxHP - _S * 5, -- X 
            PosY(3.5), -- Y 
            _S * 5, -- W
            SE_BarSize.Y, -- H
            Color.dDefault
        )

        -- STAMINA DRAW CALLS
        d2d.fill_rect(
            PosX(), -- X 
            PosY(4.25), -- Y 
            HpStOffset * MaxST, -- W
            ST_BarSize.Y, 
            Color.Grey
        )
        d2d.fill_rect(
            PosX(), -- X 
            PosY(4.25), -- Y 
            HpStOffset * ST, -- W
            ST_BarSize.Y, -- H
            Color.Default
        )
        d2d.text(
            Font.Default, 
            ":"..string.format("%.2f", ST)..":", -- T
            PosX(), -- X
            PosY(5.3), -- Y 
            Color.dDefault
        )
    end
)