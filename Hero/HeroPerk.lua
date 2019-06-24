function HeroPerkInit()
	--> GameUI
	local GameUI      = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
	local UberTooltip = BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP, 0)
	
	--> Btn
	local BtnIcon     = { 'ReplaceableTextures\\CommandButtons\\BTNCryptFiendUnBurrow.blp', 'ReplaceableTextures\\CommandButtons\\BTNCryptFiendBurrow.blp' }
	local Btn         = BlzCreateFrame('ScoreScreenBottomButtonTemplate', GameUI, 0, 0)
	BlzFrameSetSize(Btn, 0.04, 0.04)
	BlzFrameSetPoint(Btn, FRAMEPOINT_BOTTOMLEFT, GameUI, FRAMEPOINT_BOTTOMLEFT, 0, 0.18)
	local BtnTexture = BlzGetFrameByName('ScoreScreenButtonBackdrop', 0)
	BlzFrameSetTexture(BtnTexture, BtnIcon[1], 0, true)
	
	local BtnTextWrap = BlzCreateFrame('TimerDialog', Btn, 0, 0)
	BlzFrameSetSize(BtnTextWrap, 0.03, 0.023)
	BlzFrameSetPoint(BtnTextWrap, FRAMEPOINT_BOTTOM, Btn, FRAMEPOINT_TOP, 0, -0.005)
	BlzFrameSetVisible(BlzGetFrameByName('TimerDialogValue', 0), false)
	local BtnText = BlzGetFrameByName('TimerDialogTitle', 0)
	BlzFrameClearAllPoints(BtnText)
	BlzFrameSetPoint(BtnText, FRAMEPOINT_CENTER, BtnTextWrap, FRAMEPOINT_CENTER, 0, 0)
	BlzFrameSetText(BtnText, '12')
	print(BlzFrameGetHeight(BtnText))
	BlzFrameSetText(BtnText, '12\n12\n12\n12\n12\n12\n12\n12\n12\n')
	print(BlzFrameGetHeight(BtnText))
	
	local BtnTrigger = CreateTrigger()
	BlzTriggerRegisterFrameEvent(BtnTrigger, Btn, FRAMEEVENT_CONTROL_CLICK)
	BlzTriggerRegisterFrameEvent(BtnTrigger, Btn, FRAMEEVENT_MOUSE_ENTER)
	BlzTriggerRegisterFrameEvent(BtnTrigger, Btn, FRAMEEVENT_MOUSE_LEAVE)
	TriggerAddAction(BtnTrigger, function()
		if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
		
		elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_ENTER then
			
			BlzFrameSetVisible(UberTooltip, true)
			BlzFrameSetText(BlzGetOriginFrame(ORIGIN_FRAME_UBERTOOLTIP, 0), 'my text')
		elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_LEAVE then
			BlzFrameSetVisible(UberTooltip, false)
		end
	end)
	
	
	--{ TEST
	local V          = 0.1
	---@type function
	local change     = function(add)
		V = V + add
		ClearTextMessages()
		print(V)
	
	end
	--} TEST
	
	--{ DEBUG
	local OnKeyArrow = function(event, count)
		local OnKeyArrowTrigger = CreateTrigger()
		for i = 0, GetBJMaxPlayers() - 1 do
			TriggerRegisterPlayerEvent(OnKeyArrowTrigger, Player(i), event)
		end
		TriggerAddAction(OnKeyArrowTrigger, function() change(count) end)
	end
	OnKeyArrow(EVENT_PLAYER_ARROW_UP_DOWN, 0.001)
	OnKeyArrow(EVENT_PLAYER_ARROW_DOWN_DOWN, -0.001)
	OnKeyArrow(EVENT_PLAYER_ARROW_LEFT_DOWN, 0.01)
	OnKeyArrow(EVENT_PLAYER_ARROW_RIGHT_DOWN, -0.01)
	--} /DEBUG


end