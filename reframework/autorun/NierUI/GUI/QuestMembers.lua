local Manager   = require("NierUI.Helpers.Manager")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Config    = require("NierUI.Config")

local DefaultPos = { 
    X = 97 + Config.QuestMems_PosOffset.X, 
    Y = 214 + Config.QuestMems_PosOffset.Y
}
local _S = Config.UI_Scale
local useAlphaTrick = true

local Clock = {
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
        function PosY(offset)
            return _S * DefaultPos.Y  + _S * 20 * offset
        end
        function IndexOffset(index)
            return _S * 57 * index
        end

        -- INSTANCE ITERATE DATA
        local cPlayerManageControl  = Manager.Player:get_field("_InstancedPlayerList")
        local cPMC_Array            = cPlayerManageControl:get_field("_Array")
        local lastIndex             = cPlayerManageControl:get_Length() - 1

        -- DRAW CALL FOR EACH INSTANCE MEMBER
        for index = 0, lastIndex do -- 2 => lastIndex
            -- app.cPlayerManageInfo[] => app.HunterCharacter
            local i_HunterCharacter         = cPMC_Array[index]:get_PlayerInfo():get_Character() -- [0] => index
            local i_cHunterContextHolder    = cPMC_Array[index]:get_PlayerInfo():get_ContextHolder() -- [0] => index

            -- USER DATA
            local i_cHunterContext  = i_cHunterContextHolder:get_Pl()
            local i_IsUserControl   = i_HunterCharacter:get_IsUserControl()
            local i_PlayerName      = i_cHunterContext:get_PlayerName()

            -- HEALTH DATA
            local i_HelathMgr       = i_HunterCharacter:get_HunterHealth():get_HealthMgr()
            local i_RedHP           = i_HunterCharacter:get_HunterHealth():get_RedHealth()
            local i_HP              = i_HelathMgr:get_Health()
            local i_MaxHP           = i_HelathMgr:get_MaxHealth()

            -- HEALTH BAR DATA
            local HP_BarOffset      = 2
            local HP_BarBox         = { W = _S * 200, H = _S * 10 }
            
            if not i_IsUserControl then -- PREVENTS LOCAL PLAYER INFO DRAWING
                -- LINE BELOW HEALTH
                d2d.fill_rect(
                    PosX() - _S * 9, -- X
                    PosY(0) + IndexOffset(index), -- Y
                    _S * 3, -- W
                    _S * 51, -- H
                    Color.dDefault - AlphaTrick()
                )

                d2d.text(
                    Font.Large,
                    i_PlayerName, -- T
                    PosX(), -- X
                    PosY(0) + IndexOffset(index), -- Y 
                    Color.Default - AlphaTrick()
                )
                d2d.fill_rect(
                    PosX(), -- X
                    PosY(1.1) + IndexOffset(index), -- Y
                    HP_BarBox.W, -- W
                    HP_BarBox.H, -- H
                    Color.Grey - AlphaTrick()
                )
                d2d.fill_rect(
                    PosX(), -- X
                    PosY(1.1) + IndexOffset(index), -- Y
                    HP_BarBox.W * (i_RedHP / i_MaxHP), -- W
                    HP_BarBox.H, -- H
                    Color.Orange - AlphaTrick()
                )
                d2d.fill_rect(
                    PosX(), -- X
                    PosY(1.1) + IndexOffset(index), -- Y 
                    HP_BarBox.W * (i_HP / i_MaxHP), -- W
                    HP_BarBox.H, -- H
                    Color.Default - AlphaTrick()
                )

                -- NUMBERS HP INFO
                d2d.text(
                    Font.Default, 
                    ":"..string.format("%.2f", i_HP)..":", -- T
                    PosX(), -- X
                    PosY(1.8) + IndexOffset(index), -- Y 
                    Color.dDefault - AlphaTrick()
                )
            end 
        end
    end
)