local InitGlobalsOrigin = InitGlobals
function InitGlobals()
    InitGlobalsOrigin()

    FogEnable(false)
    FogMaskEnable(false)

    BlzHideOriginFrames(true)
    local GAME = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
    BlzFrameSetAllPoints(BlzGetOriginFrame(ORIGIN_FRAME_WORLD_FRAME, 0), GAME)

    local HERO = CreateUnit(Player(0), FourCC('Obla'), 0, 0, 0)
    SetCameraTargetController(HERO, 0, 0, true)
    SuspendHeroXP(HERO, false)
    UnitModifySkillPoints(HERO, -1)

    SuspendTimeOfDay(true)
    --EnableSelect(false, false)
    --EnableDragSelect(false, false)
    --EnablePreSelect(false, false)
    --SelectUnit(HERO, true)

    do
        local wrap = BlzCreateFrame('ListBoxWar3', GAME, 0, 0)
        BlzFrameSetSize(wrap, 0.4, 0.4)
        BlzFrameSetPoint(wrap, FRAMEPOINT_CENTER, GAME, FRAMEPOINT_CENTER, 0, 0)
        BlzFrameSetVisible(wrap, false)
    end
    do
        local wrap = BlzCreateFrame('Leaderboard', GAME, 0, 0)
        BlzFrameSetSize(wrap, 0.4, 0.4)
        BlzFrameSetPoint(wrap, FRAMEPOINT_CENTER, GAME, FRAMEPOINT_CENTER, 0, 0)
        BlzFrameSetVisible(wrap, false)

        local title = BlzGetFrameByName('LeaderboardTitle', 0)
        BlzFrameSetText(title, 'Title')
    end

    local menu = BlzCreateFrame('LoadingPlayerSlot', GAME, 0, 0)
    BlzFrameSetSize(menu, 0.504, 0.05)
    BlzFrameSetPoint(menu, FRAMEPOINT_BOTTOM, GAME, FRAMEPOINT_BOTTOM, 0, 0.06)

    local btn, btnT = {}, {} ---@type table
    local hk
    for i = 1, 10 do
        btn[i] = BlzCreateFrame('ScoreScreenBottomButtonTemplate', menu, 0, 0)
        btnT[i] = BlzGetFrameByName('ScoreScreenButtonBackdrop', 0)

        BlzFrameSetSize(btn[i], 0.044, 0.044)

        if i == 1 then
            BlzFrameSetPoint(btn[i], FRAMEPOINT_BOTTOMLEFT, menu, FRAMEPOINT_TOPLEFT, 0.032, 0)
        else
            BlzFrameSetPoint(btn[i], FRAMEPOINT_LEFT, btn[i - 1], FRAMEPOINT_RIGHT, 0, 0)
        end

        BlzFrameSetTexture(btnT[i], 'ReplaceableTextures/CommandButtons/BTNSelectHeroOn.blp', 0, true)

        hk = BlzCreateFrameByType('TEXT', '', btn[i], '', 0)
        BlzFrameSetSize(hk, 0, 0)
        BlzFrameSetPoint(hk, FRAMEPOINT_BOTTOM, btn[i], FRAMEPOINT_TOP, 0, -0.002)
        BlzFrameSetText(hk, '|cffffcc00' .. (i < 10 and i or 0))

    end

    --{ TEST
    local V = 0
    local function change(add)
        V = V + add
        ClearTextMessages()
        print(V)

        BlzFrameSetPoint(hk, FRAMEPOINT_BOTTOMRIGHT, btn[1], FRAMEPOINT_TOPLEFT, V, -V)
    end
    --} TEST

    --{ Debug frame values
    local OnKeyArrow = function(event, count)
        local OnKeyArrowTrigger = CreateTrigger()
        for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
            TriggerRegisterPlayerEvent(OnKeyArrowTrigger, Player(i), event)
        end
        TriggerAddAction(OnKeyArrowTrigger, function()
            change(count)
        end)
    end
    OnKeyArrow(EVENT_PLAYER_ARROW_UP_DOWN, 0.001)
    OnKeyArrow(EVENT_PLAYER_ARROW_DOWN_DOWN, -0.001)
    OnKeyArrow(EVENT_PLAYER_ARROW_LEFT_DOWN, 0.01)
    OnKeyArrow(EVENT_PLAYER_ARROW_RIGHT_DOWN, -0.01)
    --}
end