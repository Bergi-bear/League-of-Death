function HeroPerkInit()
	local Update---@type function
	
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
	
	--> PerkTrigger
	local PerkTriggerData = {} ---@type table
	local PerkTrigger     = CreateTrigger()
	TriggerAddAction(PerkTrigger, function()
		local player  = GetTriggerPlayer()
		local id      = GetPlayerId(player)
		local frame   = BlzGetTriggerFrame()
		local data    = PerkTriggerData[GetHandleId(frame)]
		
		local ability = PLAYER[id].ability[data[1]].codename
		local level   = data[2]
		local num     = data[3]
		
		if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
			--print(ability, level, num)
			PLAYER[id].perk[ability][level][num] = PLAYER[id].perk[ability][level][num] + 1
			
			Update(player)
		elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_ENTER then
			--print('hover')
		elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_LEAVE then
		end
	end)
	
	---@param frame framehandle
	local function PerkTriggerAddEvent(frame)
		BlzTriggerRegisterFrameEvent(PerkTrigger, frame, FRAMEEVENT_CONTROL_CLICK)
		BlzTriggerRegisterFrameEvent(PerkTrigger, frame, FRAMEEVENT_MOUSE_ENTER)
		BlzTriggerRegisterFrameEvent(PerkTrigger, frame, FRAMEEVENT_MOUSE_LEAVE)
	end
	
	--> AbilWrap
	local AbilWrap = BlzCreateFrame('EscMenuBackdrop', GameUI, 0, 0)
	BlzFrameSetSize(AbilWrap, 0.8, 0.292)
	BlzFrameSetPoint(AbilWrap, FRAMEPOINT_TOPLEFT, GameUI, FRAMEPOINT_TOPLEFT, 0, -0.05)
	BlzFrameSetVisible(AbilWrap, false)
	
	local AbilBtn        = {} ---@type table
	local AbilBtnTexture = {} ---@type table
	local Perk           = {} ---@type table
	local PerkTexture    = {} ---@type table
	local PerkBtn        = {} ---@type table
	local PerkBtnTexture = {} ---@type table
	for i = 1, 6 do
		AbilBtn[i] = BlzCreateFrame('ListBoxWar3', AbilWrap, 0, 0)
		BlzFrameSetVisible(AbilBtn[i], false)
		BlzFrameSetSize(AbilBtn[i], 0.09, 0.09)
		
		AbilBtnTexture[i] = BlzGetFrameByName('ListBoxBackdrop', 0)
		
		BlzFrameSetAllPoints(BlzCreateFrame('ListBoxWar3', AbilBtn[i], 0, 0), AbilBtn[i])
		BlzFrameSetTexture(BlzGetFrameByName('ListBoxBackdrop', 0), 'UI\\Icon\\Border\\Learned.blp', 0, true)
		
		if i == 1 then
			BlzFrameSetPoint(AbilBtn[i], FRAMEPOINT_TOPLEFT, AbilWrap, FRAMEPOINT_TOPLEFT, 0.03, -0.03)
		else
			BlzFrameSetPoint(AbilBtn[i], FRAMEPOINT_LEFT, AbilBtn[i - 1], FRAMEPOINT_RIGHT, 0, 0)
		end
		
		Perk[i]           = {}
		PerkTexture[i]    = {}
		PerkBtn[i]        = {}
		PerkBtnTexture[i] = {}
		
		for j = 1, 10 do
			Perk[i][j] = BlzCreateFrame('ListBoxWar3', AbilBtn[i], 0, 0)
			BlzFrameSetSize(Perk[i][j], 0.03, 0.03)
			PerkTexture[i][j] = BlzGetFrameByName('ListBoxBackdrop', 0)
			BlzFrameSetVisible(Perk[i][j], false)
			
			PerkBtn[i][j] = BlzCreateFrame('ScoreScreenBottomButtonTemplate', Perk[i][j], 0, 0)
			BlzFrameSetAllPoints(PerkBtn[i][j], Perk[i][j])
			PerkBtnTexture[i][j]                        = BlzGetFrameByName('ScoreScreenButtonBackdrop', 0)
			
			local level                                 = math.floor((j + 1) / 3 + 0.5)
			local num                                   = j + 3 - level * 3
			PerkTriggerData[GetHandleId(PerkBtn[i][j])] = { i, level, num }
			PerkTriggerAddEvent(PerkBtn[i][j])
			
			if j == 1 then
				BlzFrameSetPoint(Perk[i][j], FRAMEPOINT_TOPLEFT, AbilBtn[i], FRAMEPOINT_BOTTOMLEFT, 0, 0)
			elseif j <= 3 then
				BlzFrameSetPoint(Perk[i][j], FRAMEPOINT_LEFT, Perk[i][j - 1], FRAMEPOINT_RIGHT, 0, 0)
			elseif j <= 9 then
				BlzFrameSetPoint(Perk[i][j], FRAMEPOINT_TOP, Perk[i][j - 3], FRAMEPOINT_BOTTOM, 0, 0)
			else
				BlzFrameSetPoint(Perk[i][j], FRAMEPOINT_TOP, Perk[i][j - 2], FRAMEPOINT_BOTTOM, 0, 0)
			end
		end
	end
	
	--> TextWrap
	local TextWrap = BlzCreateFrame('ListBoxWar3', AbilWrap, 0, 0)
	BlzFrameSetSize(TextWrap, 0.198, 0.23)
	BlzFrameSetPoint(TextWrap, FRAMEPOINT_TOPLEFT, AbilBtn[6], FRAMEPOINT_TOPRIGHT, 0.002, -0.002)
	
	---@param player player
	Update = function(player)
		local id = GetPlayerId(player)
		
		for i = 1, #PLAYER[id].ability do
			local ability = PLAYER[id].ability[i].codename ---@type string
			FrameSetTexture(AbilBtnTexture[i], 'UI\\Icon\\Ability\\' .. ability .. '.blp', player)
			
			local count = GetPlayerAbilityPerkLevels(player, ability)
			
			for level, perks in ipairs(PLAYER[id].ability[i].perk) do
				for num in ipairs(perks) do
					local pk = (level - 1) * 3 + num
					BlzFrameSetVisible(Perk[i][pk], true)
					
					local lvl       = GetPlayerAbilityPerkLevel(player, ability, level, num)
					local legendary = level == 4 and 'Legendary' or ''
					
					local isEnabled = false
					local border    = 'Disabled'
					if lvl == 0 and ((level < 4 and count[level - 1] > 0) or (level == 4 and count[4] > 0)) then
						border    = 'Available'
						isEnabled = true
					end
					if lvl > 0 then border = 'Learned' end
					
					if player == GetLocalPlayer() then
						BlzFrameSetEnable(PerkBtn[i][pk], isEnabled)
						BlzFrameSetTexture(PerkTexture[i][pk], 'UI\\Icon\\Perk\\' .. ability .. '_' .. level .. '_' .. num .. '.blp', 0, true)
						BlzFrameSetTexture(PerkBtnTexture[i][pk], 'UI\\Icon\\Border\\' .. legendary .. border .. '.blp', 0, true)
					end
				end
			end
		end
	end
	
	---@param player player
	function HeroPerkShow(player)
		local id = GetPlayerId(player)
		
		for i = 1, 6 do
			BlzFrameSetVisible(AbilBtn[i], i <= #PLAYER[id].ability)
		end
		
		if player == GetLocalPlayer() then
			BlzFrameSetVisible(Btn, true)
			--BlzFrameSetVisible(AbilWrap, true)
		end
		
		Update(player)
	end
	
	
	--> BtnTrigger
	--> PerkTrigger
	local BtnTrigger = CreateTrigger()
	TriggerAddAction(BtnTrigger, function()
		local player    = GetTriggerPlayer()
		local isVisible = BlzFrameIsVisible(AbilWrap)
		
		if player == GetLocalPlayer() then
			BlzFrameSetVisible(AbilWrap, not isVisible)
			BlzFrameSetTexture(BtnTexture, BtnIcon[isVisible and 1 or 2], 0, true)
		end
	end)
	BlzTriggerRegisterFrameEvent(BtnTrigger, Btn, FRAMEEVENT_CONTROL_CLICK)
	
	--{ TEST
	local V = 0.2
	local function change(add)
		V = V + add
		ClearTextMessages()
		print(V)
	end
	--} TEST
	
	--{ Debug frame values
	local OnKeyArrow = function(event, count)
		local OnKeyArrowTrigger = CreateTrigger()
		for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
			TriggerRegisterPlayerEvent(OnKeyArrowTrigger, Player(i), event)
		end
		TriggerAddAction(OnKeyArrowTrigger, function() change(count) end)
	end
	OnKeyArrow(EVENT_PLAYER_ARROW_UP_DOWN, 0.001)
	OnKeyArrow(EVENT_PLAYER_ARROW_DOWN_DOWN, -0.001)
	OnKeyArrow(EVENT_PLAYER_ARROW_LEFT_DOWN, 0.01)
	OnKeyArrow(EVENT_PLAYER_ARROW_RIGHT_DOWN, -0.01)
	--}

end