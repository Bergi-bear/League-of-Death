function HeroPerkInit()
	---@type function
	local Update
	
	--> GameUI
	local GameUI  = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
	
	--> Btn
	local BtnIcon = { 'ReplaceableTextures\\CommandButtons\\BTNCryptFiendUnBurrow.blp', 'ReplaceableTextures\\CommandButtons\\BTNCryptFiendBurrow.blp' }
	local Btn     = BlzCreateFrame('ScoreScreenBottomButtonTemplate', GameUI, 0, 0)
	BlzFrameSetSize(Btn, 0.04, 0.04)
	BlzFrameSetPoint(Btn, FRAMEPOINT_BOTTOMLEFT, GameUI, FRAMEPOINT_BOTTOMLEFT, 0, 0.18)
	local BtnTexture = BlzGetFrameByName('ScoreScreenButtonBackdrop', 0)
	BlzFrameSetTexture(BtnTexture, BtnIcon[1], 0, true)
	BlzFrameSetVisible(Btn, false)
	
	local BtnTextWrap = BlzCreateFrame('TimerDialog', Btn, 0, 0)
	BlzFrameSetSize(BtnTextWrap, 0.03, 0.023)
	BlzFrameSetPoint(BtnTextWrap, FRAMEPOINT_BOTTOM, Btn, FRAMEPOINT_TOP, 0, -0.005)
	BlzFrameSetVisible(BlzGetFrameByName('TimerDialogValue', 0), false)
	local BtnText = BlzGetFrameByName('TimerDialogTitle', 0)
	BlzFrameClearAllPoints(BtnText)
	BlzFrameSetPoint(BtnText, FRAMEPOINT_CENTER, BtnTextWrap, FRAMEPOINT_CENTER, 0, 0)
	BlzFrameSetText(BtnText, '0')
	
	local BtnTrigger = CreateTrigger()
	BlzTriggerRegisterFrameEvent(BtnTrigger, Btn, FRAMEEVENT_CONTROL_CLICK)
	BlzTriggerRegisterFrameEvent(BtnTrigger, Btn, FRAMEEVENT_MOUSE_ENTER)
	BlzTriggerRegisterFrameEvent(BtnTrigger, Btn, FRAMEEVENT_MOUSE_LEAVE)
	TriggerAddAction(BtnTrigger, function()
		if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
		elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_ENTER then
		elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_LEAVE then
		end
	end)
	
	--> AbilWrap
	local AbilWrap = BlzCreateFrame('EscMenuBackdrop', GameUI, 0, 0)
	BlzFrameSetSize(AbilWrap, 0.8, 0.292)
	BlzFrameSetPoint(AbilWrap, FRAMEPOINT_TOPLEFT, GameUI, FRAMEPOINT_TOPLEFT, 0, -0.05)
	BlzFrameSetVisible(AbilWrap, false)
	
	local AbilBtn        = {} ---@type table
	local AbilBtnTexture = {} ---@type table
	local PerkBtn        = {} ---@type table
	local PerkBtnTexture = {} ---@type table
	for i = 1, 6 do
		AbilBtn[i] = BlzCreateFrame('ScoreScreenBottomButtonTemplate', AbilWrap, 0, 0)
		BlzFrameSetSize(AbilBtn[i], 0.09, 0.09)
		AbilBtnTexture[i] = BlzGetFrameByName('ScoreScreenButtonBackdrop', 0)
		BlzFrameSetTexture(AbilBtnTexture[i], 'ReplaceableTextures\\CommandButtons\\BTNAbility_horde.blp', 0, true)
		if i == 1 then
			BlzFrameSetPoint(AbilBtn[i], FRAMEPOINT_TOPLEFT, AbilWrap, FRAMEPOINT_TOPLEFT, 0.03, -0.03)
		else
			BlzFrameSetPoint(AbilBtn[i], FRAMEPOINT_LEFT, AbilBtn[i - 1], FRAMEPOINT_RIGHT, 0, 0)
		end
		
		PerkBtn[i]        = {}
		PerkBtnTexture[i] = {}
		for j = 1, 10 do
			PerkBtn[i][j] = BlzCreateFrame('ScoreScreenBottomButtonTemplate', AbilWrap, 0, 0)
			
			BlzFrameSetSize(PerkBtn[i][j], 0.03, 0.03)
			PerkBtnTexture[i][j] = BlzGetFrameByName('ScoreScreenButtonBackdrop', 0)
			BlzFrameSetTexture(PerkBtnTexture[i][j], 'ReplaceableTextures\\CommandButtons\\BTNAbility_horde-Coloress.blp', 0, true)
			if j == 1 then
				BlzFrameSetPoint(PerkBtn[i][j], FRAMEPOINT_TOPLEFT, AbilBtn[i], FRAMEPOINT_BOTTOMLEFT, 0, 0)
			elseif j <= 3 then
				BlzFrameSetPoint(PerkBtn[i][j], FRAMEPOINT_LEFT, PerkBtn[i][j - 1], FRAMEPOINT_RIGHT, 0, 0)
			elseif j <= 9 then
				BlzFrameSetPoint(PerkBtn[i][j], FRAMEPOINT_TOP, PerkBtn[i][j - 3], FRAMEPOINT_BOTTOM, 0, 0)
			else
				BlzFrameSetPoint(PerkBtn[i][j], FRAMEPOINT_TOP, PerkBtn[i][j - 2], FRAMEPOINT_BOTTOM, 0, 0)
			end
		end
	
	end
	
	--> TextWrap
	local TextWrap = BlzCreateFrame('ListBoxWar3', AbilWrap, 0, 0)
	BlzFrameSetSize(TextWrap, 0.2, 0.23)
	BlzFrameSetPoint(TextWrap, FRAMEPOINT_TOPLEFT, AbilBtn[6], FRAMEPOINT_TOPRIGHT, 0, -0.002)
	
	--{ TEST
	local V = 0.3
	local function change(add)
		V = V + add
		ClearTextMessages()
		print(V)
		BlzFrameSetSize(TextWrap, 0.2, V)
	end
	--} TEST
	
	---@param player player
	Update = function(player)
		local id = GetPlayerId(player)
	
	end
	
	---@param player player
	function HeroPerkShow(player)
		local id = GetPlayerId(player)
		
		for i = 1, 6 do
			--BlzFrameSetVisible(AbilBtn[i], i <= #PLAYER[id].ability)
		end
		
		if player == GetLocalPlayer() then
			BlzFrameSetVisible(Btn, true)
			BlzFrameSetVisible(AbilWrap, true)
		end
	end
	
	
	--{ Debug frame values
	local OnKeyArrow = function(event, count)
		local OnKeyArrowTrigger = CreateTrigger()
		for i = 0, GetBJMaxPlayers() - 1 do
			TriggerRegisterPlayerEvent(OnKeyArrowTrigger, Player(i), event)
		end
		TriggerAddAction(OnKeyArrowTrigger, function() change(count)
		end)
	end
	OnKeyArrow(EVENT_PLAYER_ARROW_UP_DOWN, 0.001)
	OnKeyArrow(EVENT_PLAYER_ARROW_DOWN_DOWN, -0.001)
	OnKeyArrow(EVENT_PLAYER_ARROW_LEFT_DOWN, 0.01)
	OnKeyArrow(EVENT_PLAYER_ARROW_RIGHT_DOWN, -0.01)
	--}

end