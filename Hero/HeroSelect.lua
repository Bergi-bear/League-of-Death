function HeroSelectInit()
	---@type function
	local Update
	
	--> Cinematic
	ShowInterface(false, 0)
	BlzEnableCursor(true)
	EnableUserControl(true)
	
	SetCineFilterTexture('ReplaceableTextures\\CameraMasks\\Black_mask.blp')
	SetCineFilterBlendMode(BLEND_MODE_BLEND)
	SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
	SetCineFilterStartUV(0, 0, 1, 1)
	SetCineFilterEndUV(0, 0, 1, 1)
	SetCineFilterStartColor(255, 255, 255, 255)
	SetCineFilterEndColor(255, 255, 255, 255)
	SetCineFilterDuration(0)
	DisplayCineFilter(true)
	
	-- GameUI
	local GameUI         = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
	
	--> Wrap
	local WrapPaddingTop = -0.036
	local Wrap           = BlzCreateFrameByType('FRAME', '', GameUI, '', 0)
	BlzFrameSetSize(Wrap, 1, 1)
	BlzFrameSetPoint(Wrap, FRAMEPOINT_CENTER, GameUI, FRAMEPOINT_CENTER, 0, 0)
	
	--> Model
	local ModelWrap = BlzCreateFrameByType('MENU', '', Wrap, '', 0)
	BlzFrameSetSize(ModelWrap, 1, 1)
	BlzFrameSetPoint(ModelWrap, FRAMEPOINT_CENTER, Wrap, FRAMEPOINT_CENTER, 0, 0)
	local Model = BlzCreateFrameByType('SPRITE', '', ModelWrap, '', 0)
	BlzFrameSetPoint(Model, FRAMEPOINT_CENTER, ModelWrap, FRAMEPOINT_CENTER, 0, 0)
	
	--> Race
	local WrapHeight    = 0.338
	local RaceWrapWidth = 0.193
	local RaceWrap      = BlzCreateFrame('EscMenuBackdrop', Wrap, 0, 0)
	BlzFrameSetSize(RaceWrap, RaceWrapWidth, WrapHeight)
	BlzFrameSetPoint(RaceWrap, FRAMEPOINT_LEFT, Wrap, FRAMEPOINT_LEFT, 0, 0)
	
	--> RaceBtn
	local BtnHeight = 0.03
	local BtnTop    = -0.012
	local BtnBottom = 0.038
	local RaceBtn   = {}
	
	for i = 1, #RACE do
		RaceBtn[i] = BlzCreateFrame('ScriptDialogButton', RaceWrap, 0, 0)
		BlzFrameSetText(RaceBtn[i], RACE[i].name)
		BlzFrameSetSize(RaceBtn[i], 0.128, BtnHeight)
		if i == 1 then
			BlzFrameSetPoint(RaceBtn[i], FRAMEPOINT_TOP, RaceWrap, FRAMEPOINT_TOP, 0, WrapPaddingTop)
		elseif i == #RACE then
			BlzFrameSetPoint(RaceBtn[i], FRAMEPOINT_BOTTOM, RaceWrap, FRAMEPOINT_BOTTOM, 0, BtnBottom)
		else
			BlzFrameSetPoint(RaceBtn[i], FRAMEPOINT_TOP, RaceBtn[i - 1], FRAMEPOINT_BOTTOM, 0, BtnTop)
		end
		
		local RaceBtnTrigger = CreateTrigger()
		BlzTriggerRegisterFrameEvent(RaceBtnTrigger, RaceBtn[i], FRAMEEVENT_CONTROL_CLICK)
		TriggerAddAction(
				RaceBtnTrigger,
				function()
					local player = GetTriggerPlayer()
					local id     = GetPlayerId(player)
					if i < #RACE then
						PLAYER[id].race = i
					else
						PLAYER[id].race = math.random(1, #RACE - 1)
						PLAYER[id].attr = math.random(1, 3)
					end
					Update(player)
				end
		)
	end
	
	--> Attr
	local AttrWrapWidth = 1 - RaceWrapWidth
	local AttrWrap      = BlzCreateFrame('EscMenuBackdrop', Wrap, 0, 0)
	BlzFrameSetSize(AttrWrap, AttrWrapWidth, WrapHeight)
	BlzFrameSetPoint(AttrWrap, FRAMEPOINT_LEFT, RaceWrap, FRAMEPOINT_RIGHT, 0.0315, 0)
	
	local function AttrBtnOnClick(frame, index)
		local AttrBtnTrigger = CreateTrigger()
		BlzTriggerRegisterFrameEvent(AttrBtnTrigger, frame, FRAMEEVENT_CONTROL_CLICK)
		TriggerAddAction(
				AttrBtnTrigger,
				function()
					local player                     = GetTriggerPlayer()
					PLAYER[GetPlayerId(player)].attr = index
					Update(player)
				end
		)
	end
	
	local AttrBtnWidth = 0.162
	local AttrBtn      = {}
	AttrBtn[2]         = BlzCreateFrame('ScriptDialogButton', AttrWrap, 0, 0)
	BlzFrameSetText(AttrBtn[2], 'Ловкость')
	BlzFrameSetSize(AttrBtn[2], AttrBtnWidth, BtnHeight)
	BlzFrameSetPoint(AttrBtn[2], FRAMEPOINT_TOP, AttrWrap, FRAMEPOINT_TOP, 0, WrapPaddingTop)
	AttrBtnOnClick(AttrBtn[2], 2)
	
	AttrBtn[1] = BlzCreateFrame('ScriptDialogButton', AttrWrap, 0, 0)
	BlzFrameSetText(AttrBtn[1], 'Сила')
	BlzFrameSetSize(AttrBtn[1], AttrBtnWidth, BtnHeight)
	BlzFrameSetPoint(AttrBtn[1], FRAMEPOINT_RIGHT, AttrBtn[2], FRAMEPOINT_LEFT, BtnTop, 0)
	AttrBtnOnClick(AttrBtn[1], 1)
	
	AttrBtn[3] = BlzCreateFrame('ScriptDialogButton', AttrWrap, 0, 0)
	BlzFrameSetText(AttrBtn[3], 'Интеллект')
	BlzFrameSetSize(AttrBtn[3], AttrBtnWidth, BtnHeight)
	BlzFrameSetPoint(AttrBtn[3], FRAMEPOINT_LEFT, AttrBtn[2], FRAMEPOINT_RIGHT, -BtnTop, 0)
	AttrBtnOnClick(AttrBtn[3], 3)
	
	--> Portrait
	local PortraitSize = 0.162
	local PortraitWrap = BlzCreateFrame('ListBoxWar3', AttrWrap, 0, 0)
	BlzFrameSetSize(PortraitWrap, PortraitSize, PortraitSize)
	BlzFrameSetPoint(PortraitWrap, FRAMEPOINT_TOPLEFT, AttrBtn[1], FRAMEPOINT_BOTTOMLEFT, 0, BtnTop)
	
	local PortraitTextureWrap = BlzCreateFrame('ListBoxWar3', AttrWrap, 0, 0)
	BlzFrameSetSize(PortraitTextureWrap, PortraitSize - 0.01, PortraitSize - 0.01)
	BlzFrameSetPoint(PortraitTextureWrap, FRAMEPOINT_CENTER, PortraitWrap, FRAMEPOINT_CENTER, 0, 0)
	local PortraitTexture = BlzGetFrameByName('ListBoxBackdrop', 0)
	
	
	--> TipText
	local TipTextWrap     = BlzCreateFrame('ListBoxWar3', AttrWrap, 0, 0)
	BlzFrameSetSize(TipTextWrap, 0.336, PortraitSize)
	BlzFrameSetPoint(TipTextWrap, FRAMEPOINT_LEFT, PortraitWrap, FRAMEPOINT_RIGHT, 0.012, 0)
	
	local TipTextPadding = 0.012
	local TipText        = BlzCreateFrameByType('TEXT', '', TipTextWrap, '', 0)
	BlzFrameSetSize(TipText, BlzFrameGetWidth(TipTextWrap) - TipTextPadding * 2, BlzFrameGetHeight(TipTextWrap) - TipTextPadding * 2)
	BlzFrameSetPoint(TipText, FRAMEPOINT_TOP, TipTextWrap, FRAMEPOINT_TOP, 0, -TipTextPadding)
	
	---@param player player
	---@param text string
	local function SetTipText(player, text)
		local id = GetPlayerId(player)
		if text == '' then
			text = RACE[PLAYER[id].race].attr[PLAYER[id].attr].description
		end
		
		if player == GetLocalPlayer() then
			BlzFrameSetText(TipText, text)
		end
	end
	
	--> AbilBtn
	local AbilBtn                  = {} ---@type table
	local AbilBtnTexture           = {} ---@type table
	local AbilityBtnOnLeaveTrigger = CreateTrigger()
	TriggerAddAction(AbilityBtnOnLeaveTrigger, function()
		SetTipText(GetTriggerPlayer(), '')
	end)
	
	---@param index integer
	local function AbilBtnOnEnter(index)
		local AbilBtnOnEnterTrigger = CreateTrigger()
		BlzTriggerRegisterFrameEvent(AbilBtnOnEnterTrigger, AbilBtn[index], FRAMEEVENT_MOUSE_ENTER)
		TriggerAddAction(
				AbilBtnOnEnterTrigger,
				function()
					local player = GetTriggerPlayer()
					local id     = GetPlayerId(player)
					SetTipText(player, RACE[PLAYER[id].race].attr[PLAYER[id].attr].ability[index].description)
				end
		)
	end
	
	CinematicModeBJ()
	
	local AbilEmptyTextFile = 'ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp'
	for i = 1, 6 do
		
		AbilBtn[i] = BlzCreateFrame('ListBoxWar3', AttrWrap, 0, 0)
		BlzFrameSetSize(AbilBtn[i], 0.05, 0.05)
		if i == 1 then
			BlzFrameSetPoint(AbilBtn[i], FRAMEPOINT_TOPLEFT, TipTextWrap, FRAMEPOINT_BOTTOMLEFT, 0, -0.01)
		else
			BlzFrameSetPoint(AbilBtn[i], FRAMEPOINT_LEFT, AbilBtn[i - 1], FRAMEPOINT_RIGHT, 0.0074, 0)
		end
		AbilBtnTexture[i] = BlzGetFrameByName('ListBoxBackdrop', 0)
		BlzFrameSetTexture(AbilBtnTexture[i], AbilEmptyTextFile, 0, true)
		
		BlzTriggerRegisterFrameEvent(AbilityBtnOnLeaveTrigger, AbilBtn[i], FRAMEEVENT_MOUSE_LEAVE)
		AbilBtnOnEnter(i)
	end
	
	--> StartBtn
	local StartBtn = BlzCreateFrame('ScriptDialogButton', AttrWrap, 0, 0)
	BlzFrameSetText(StartBtn, 'Выбрать')
	BlzFrameSetSize(StartBtn, PortraitSize, BtnHeight)
	BlzFrameSetPoint(StartBtn, FRAMEPOINT_BOTTOMLEFT, AttrWrap, FRAMEPOINT_BOTTOMLEFT, 0.032, BtnBottom)
	
	---@param player player
	local function Start(player)
		local id = GetPlayerId(player)
		local x  = GetStartLocationX(id)
		local y  = GetStartLocationY(id)
		
		if PLAYER[id].hero ~= nil then return end
		PLAYER[id].hero = CreateUnit(player, RACE[PLAYER[id].race].attr[PLAYER[id].attr].unit, x, y, 90)
		
		if player == GetLocalPlayer() then
			BlzFrameSetVisible(Wrap, false)
			BlzFrameSetVisible(RaceWrap, false)
			BlzFrameSetVisible(AttrWrap, false)
			
			ShowInterface(true, 0)
			BlzFrameSetVisible(BlzGetOriginFrame(ORIGIN_FRAME_PORTRAIT, 0), true)
			DisplayCineFilter(false)
			
			ClearSelection()
			SelectUnit(PLAYER[id].hero, true)
			PanCameraTo(x, y)
		end
	end
	
	local StartTrigger = CreateTrigger()
	BlzTriggerRegisterFrameEvent(StartTrigger, StartBtn, FRAMEEVENT_CONTROL_CLICK)
	TriggerAddAction(StartTrigger, function() Start(GetTriggerPlayer()) end)
	
	--> Update
	Update = function(player)
		local id   = GetPlayerId(player)
		
		local race = PLAYER[id].race
		for i = 1, #RACE - 1 do
			if player == GetLocalPlayer() then
				BlzFrameSetEnable(RaceBtn[i], race ~= i)
			end
		end
		
		local attr = PLAYER[id].attr
		for i = 1, 3 do
			if player == GetLocalPlayer() then
				BlzFrameSetEnable(AttrBtn[i], attr ~= i)
			end
		end
		
		local abilitys = RACE[race].attr[attr].ability
		for i = 1, 6 do
			if player == GetLocalPlayer() then
				BlzFrameSetVisible(AbilBtn[i], i <= #abilitys)
				if (i <= #abilitys) then
					BlzFrameSetTexture(AbilBtnTexture[i], RACE[race].attr[attr].ability[i].icon, 0, true)
				end
			end
		end
		
		if RACE[race].model ~= PLAYER[id].heroSelectBgModel then
			PLAYER[id].heroSelectBgModel = RACE[race].model
			if (player == GetLocalPlayer()) then
				BlzFrameSetModel(Model, PLAYER[id].heroSelectBgModel, 0)
			end
		end
		
		if (player == GetLocalPlayer()) then
			BlzFrameSetTexture(PortraitTexture, 'UI\\Hero\\Previev\\' .. race .. '_' .. attr .. '.blp', 0, true)
			SetTipText(player, '')
		end
	end
	
	Update(GetLocalPlayer())
	
	--Start(GetLocalPlayer())
end