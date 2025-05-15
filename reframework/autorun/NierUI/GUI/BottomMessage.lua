local Manager   = require("NierUI.Helpers.Manager")
local Color     = require("NierUI.Helpers.Color")
local Font      = require("NierUI.Helpers.Font")
local Config    = require("NierUI.Config")

-- DPS METER
-- app.EnemyCharacter:get_field("_MiniComponentHolder"):get_field("_DamageCounter") => app.mcEnemyDamageCounter

local _S = Config.UI_Scale

d2d.register(
    function() end,
    function()
        local  HunterCharacter = Manager.Player:call("getMasterPlayerInfo"):get_field("<Character>k__BackingField")
        if not HunterCharacter then return end
        if Manager.GUI:isMouseCursorAvailable() then return end

        local ScreenWidth, ScreenHeight = d2d.surface_size()
        local Message = "[Nier UI ver. 0.1]"
        local Margin = _S * 10

        local cQuestDirector   = Manager.Mission:get_QuestDirector()
        local cActiveQuestData = cQuestDirector:get_QuestData()

        -- PREVENT CALLS, IF NOT DURING THE QUEST
        if cActiveQuestData and Config.DrawQuestElapsedTime then 
            local QuestRemainTime   = cQuestDirector:get_QuestRemainTime()
            local QuestMaxTime      = cActiveQuestData:getTimeLimit()
            local QuestTime         = "[Time Elapsed: "..string.format("%.3f", QuestMaxTime - QuestRemainTime / 60).." min]"

            Message = QuestTime
        end

        local MessageWidth, MessageHeight = Font.Large:measure(Message)

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
            Font.Large, 
            Message,
            BoxPos.X + Margin,
            BoxPos.Y + Margin,
            Color.Default
        )
    end
)