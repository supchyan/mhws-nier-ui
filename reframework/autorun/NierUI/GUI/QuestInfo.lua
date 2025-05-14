local Manager   = require("NierUI.Helpers.Manager")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Config    = require("NierUI.Config")

local DefaultPos = { 
    X = 0 + Config.QuestInfo_PosOffset.X, 
    Y = 220 + Config.QuestInfo_PosOffset.Y 
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

        local QuestBoxMargin = _S * 10

        local QuestTime  = "[MM:SS]"
        local QuestTitle = "Quest name"
        local QuestDesc  = "* Quest description"
        
        local QuestTimeWidth, QuestTimeHeight   = Font.Large:measure(QuestTime)
        local QuestTitleWidth, QuestTitleHeight = Font.Large:measure(QuestTitle)
        local QuestDescWidth, QuestDescHeight   = Font.Default:measure(QuestDesc)


        local BoxDefWidth = QuestTitleWidth + QuestTimeWidth + QuestBoxMargin
        if QuestDescWidth > BoxDefWidth then
            BoxDefWidth = QuestDescWidth
        end

        local QuestBox = {
            W = BoxDefWidth + 10 * QuestBoxMargin,
            H = QuestTitleHeight + QuestDescHeight + 2.5 * QuestBoxMargin
        }

        local QuestBoxPos = {
            X = ScreenWidth - QuestBox.W + _S * DefaultPos.X,
            Y = _S * DefaultPos.Y
        }

        local QuestTimePos = {
            X = QuestBoxPos.X + QuestBoxMargin,
            Y = QuestBoxPos.Y + QuestBoxMargin
        }
        
        local QuestTitlePos = {
            X = QuestTimePos.X + QuestTimeWidth + QuestBoxMargin,
            Y = QuestTimePos.Y
        }

        local QuestDescPos = {
            X = QuestTimePos.X,
            Y = QuestTimePos.Y + QuestTitleHeight + .5 * QuestBoxMargin
        }

        -- BOX LINE DRAW CALLS
        d2d.fill_rect(
            QuestBoxPos.X - _S * 8, -- X
            QuestBoxPos.Y, -- Y 
            _S * 3, -- W
            QuestBox.H, -- H
            Color.dDefault - AlphaTrick()
        )

        -- QUEST BOX DRAW CALLS
        d2d.fill_rect(
            QuestBoxPos.X, -- X
            QuestBoxPos.Y, -- Y 
            QuestBox.W, -- W
            QuestBox.H, -- H
            Color.dDefault - AlphaTrick()
        )

        -- QUEST TIME DRAW CALLS
        d2d.text( -- SHADOW
            Font.Large,
            QuestTime, -- T
            QuestTimePos.X - 1, -- X
            QuestTimePos.Y + 1, -- Y
            Color.dRed - AlphaTrick()
        )
        d2d.text(
            Font.Large,
            QuestTime, -- T
            QuestTimePos.X, -- X
            QuestTimePos.Y, -- Y
            Color.Red - AlphaTrick()
        )

        -- QUEST TITLE DRAW CALLS
        d2d.text( -- SHADOW
            Font.Large,
            QuestTitle, -- T
            QuestTitlePos.X - 1, -- X
            QuestTitlePos.Y + 1, -- Y
            Color.dGrey - AlphaTrick()
        )
        d2d.text(
            Font.Large,
            QuestTitle, -- T
            QuestTitlePos.X, -- X
            QuestTitlePos.Y, -- Y
            Color.Grey - AlphaTrick()
        )

        -- QUEST DESC. DRAW CALLS
        d2d.text(
            Font.Default,
            QuestDesc, -- T
            QuestDescPos.X, -- X
            QuestDescPos.Y, -- Y
            Color.Grey - AlphaTrick()
        )
    end
)