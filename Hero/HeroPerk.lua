do
	local InitGlobalsOrigin = InitGlobals ---@type function
	function InitGlobals()
		InitGlobalsOrigin()
		
		local Update---@type function
		local TipText---@type framehandle
		
		-- GameUI
		local GameUI  = BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI, 0)
		
		-- Btn
		local BtnIcon = { 'ReplaceableTextures/CommandButtons/BTNCryptFiendUnBurrow.blp', 'ReplaceableTextures/CommandButtons/BTNCryptFiendBurrow.blp' }
		local Btn     = BlzCreateFrame('ScoreScreenBottomButtonTemplate', GameUI, 0, 0)
		BlzFrameSetSize(Btn, 0.04, 0.04)
		BlzFrameSetPoint(Btn, FRAMEPOINT_BOTTOMLEFT, GameUI, FRAMEPOINT_BOTTOMLEFT, 0, 0.18)
		local BtnTexture = BlzGetFrameByName('ScoreScreenButtonBackdrop', 0)
		BlzFrameSetTexture(BtnTexture, BtnIcon[1], 0, true)
		BlzFrameSetVisible(Btn, false)
		FrameRegisterNoFocus(Btn)
		
		-- BtnText
		local BtnTextWrap = BlzCreateFrame('TimerDialog', Btn, 0, 0)
		BlzFrameSetSize(BtnTextWrap, 0.03, 0.023)
		BlzFrameSetPoint(BtnTextWrap, FRAMEPOINT_BOTTOM, Btn, FRAMEPOINT_TOP, 0, -0.005)
		BlzFrameSetVisible(BlzGetFrameByName('TimerDialogValue', 0), false)
		local BtnText = BlzGetFrameByName('TimerDialogTitle', 0)
		BlzFrameClearAllPoints(BtnText)
		BlzFrameSetPoint(BtnText, FRAMEPOINT_CENTER, BtnTextWrap, FRAMEPOINT_CENTER, 0, 0)
		BlzFrameSetText(BtnText, '0')
		
		-- PerkTrigger
		local PerkTriggerData = {} ---@type table
		local PerkTrigger     = CreateTrigger()
		TriggerAddAction(PerkTrigger, function()
			local player  = GetTriggerPlayer()
			local id      = GetPlayerId(player)
			local frame   = BlzGetTriggerFrame()
			local data    = PerkTriggerData[GetHandleId(frame)]
			
			local ability = PLAYER[id].ability[data[1]]
			local row     = data[2]
			local col     = data[3]
			
			local perk    = ability.perk[row][col]
			
			if BlzGetTriggerFrameEvent() == FRAMEEVENT_CONTROL_CLICK then
				PLAYER[id].perk[ability.codename][row][col] = PLAYER[id].perk[ability.codename][row][col] + 1
				PLAYER[id].perkPoint                        = math.max(0, PLAYER[id].perkPoint - 1)
				HeroPerkLearn(player, ability.codename, row, col)
				Update(player)
			elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_ENTER then
				FrameSetText(TipText, perk.name .. '\n\n' .. perk.description)
			elseif BlzGetTriggerFrameEvent() == FRAMEEVENT_MOUSE_LEAVE then
				FrameSetText(TipText, '')
			end
		end)
		
		---@param frame framehandle
		local function PerkTriggerAddEvent(frame)
			BlzTriggerRegisterFrameEvent(PerkTrigger, frame, FRAMEEVENT_CONTROL_CLICK)
			BlzTriggerRegisterFrameEvent(PerkTrigger, frame, FRAMEEVENT_MOUSE_ENTER)
			BlzTriggerRegisterFrameEvent(PerkTrigger, frame, FRAMEEVENT_MOUSE_LEAVE)
		end
		
		-- AbilWrap
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
			BlzFrameSetSize(AbilBtn[i], 0.09, 0.09)
			BlzFrameSetVisible(AbilBtn[i], false)
			
			AbilBtnTexture[i] = BlzGetFrameByName('ListBoxBackdrop', 0)
			
			BlzFrameSetAllPoints(BlzCreateFrame('ListBoxWar3', AbilBtn[i], 0, 0), AbilBtn[i])
			BlzFrameSetTexture(BlzGetFrameByName('ListBoxBackdrop', 0), 'UI/Icon/Border/LearnedSimple.blp', 0, true)
			
			Perk[i]           = {}
			PerkTexture[i]    = {}
			PerkBtn[i]        = {}
			PerkBtnTexture[i] = {}
			for j = 1, 10 do
				Perk[i][j] = BlzCreateFrame('ListBoxWar3', AbilBtn[i], 0, 0)
				local size = j == 10 and 0.05 or 0.03
				BlzFrameSetSize(Perk[i][j], size, size)
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
		
		BlzFrameSetPoint(AbilBtn[1], FRAMEPOINT_TOPLEFT, AbilWrap, FRAMEPOINT_TOPLEFT, 0.03, -0.03)
		BlzFrameSetPoint(AbilBtn[2], FRAMEPOINT_LEFT, AbilBtn[1], FRAMEPOINT_RIGHT, 0, 0)
		BlzFrameSetPoint(AbilBtn[3], FRAMEPOINT_LEFT, AbilBtn[2], FRAMEPOINT_RIGHT, 0, 0)
		BlzFrameSetPoint(AbilBtn[4], FRAMEPOINT_RIGHT, AbilBtn[5], FRAMEPOINT_LEFT, 0, 0)
		BlzFrameSetPoint(AbilBtn[5], FRAMEPOINT_RIGHT, AbilBtn[6], FRAMEPOINT_LEFT, 0, 0)
		BlzFrameSetPoint(AbilBtn[6], FRAMEPOINT_TOPRIGHT, AbilWrap, FRAMEPOINT_TOPRIGHT, -0.03, -0.03)
		
		-- TipTextWrap
		local TipTextWrap = BlzCreateFrame('ListBoxWar3', AbilWrap, 0, 0)
		BlzFrameSetSize(TipTextWrap, 0.198, 0.23)
		BlzFrameSetPoint(TipTextWrap, FRAMEPOINT_TOP, AbilWrap, FRAMEPOINT_TOP, 0, -0.032)
		
		--TipText
		local TipTextPadding = 0.012
		TipText              = BlzCreateFrameByType('TEXT', '', TipTextWrap, '', 0)
		BlzFrameSetSize(TipText, BlzFrameGetWidth(TipTextWrap) - TipTextPadding * 2, BlzFrameGetHeight(TipTextWrap) - TipTextPadding * 2)
		BlzFrameSetPoint(TipText, FRAMEPOINT_TOPLEFT, TipTextWrap, FRAMEPOINT_TOPLEFT, TipTextPadding, -TipTextPadding)
		
		---@param player player
		Update = function(player)
			local id = GetPlayerId(player)
			
			FrameSetText(BtnText, PLAYER[id].perkPoint)
			
			for i = 1, #PLAYER[id].ability do
				local ability = PLAYER[id].ability[i].codename ---@type string
				FrameSetTexture(AbilBtnTexture[i], 'UI/Icon/Ability/' .. ability .. '.blp', player)
				
				local count = GetPlayerAbilityPerkLevels(player, ability)
				
				for row, perks in ipairs(PLAYER[id].ability[i].perk) do
					for col in ipairs(perks) do
						local pk = (row - 1) * 3 + col
						BlzFrameSetVisible(Perk[i][pk], true)
						
						local lvl       = GetPlayerAbilityPerkLevel(player, ability, row, col)
						local legendary = row == 4 and 'Legendary' or ''
						
						local isEnabled = false
						local border    = 'Disabled'
						if lvl == 0
								and ((row < 4 and count[row - 1] > 0) or (row == 4 and count[4] > 0))
								and PLAYER[id].perkPoint > 0
						then
							border    = 'Available'
							isEnabled = true
						end
						if lvl > 0 then border = 'Learned' end
						
						if player == GetLocalPlayer() then
							BlzFrameSetEnable(PerkBtn[i][pk], isEnabled)
							BlzFrameSetTexture(PerkTexture[i][pk], 'UI/Icon/Perk/' .. ability .. '_' .. row .. '_' .. col .. '.blp', 0, true)
							BlzFrameSetTexture(PerkBtnTexture[i][pk], 'UI/Icon/Border/' .. border .. legendary .. '.blp', 0, true)
							
							if PLAYER[id].ability[i].perk[row][col].hide ~= nil then
								BlzFrameSetVisible(PerkBtn[i][pk], false)
								BlzFrameSetVisible(PerkTexture[i][pk], false)
							end
						end
					end
				end
			end
		end
		
		-- HeroPerkShow
		---@param player player
		function HeroPerkShow(player)
			local id = GetPlayerId(player)
			
			for i = 1, 6 do
				FrameSetVisible(AbilBtn[i], i <= #PLAYER[id].ability, player)
			end
			
			if player == GetLocalPlayer() then
				BlzFrameSetVisible(Btn, true)
				--BlzFrameSetVisible(AbilWrap, true)
			end
			
			--{ DEBUG
			--HeroPerkLearn(player, ABILITY.ShakingBlow.codename, 3, 2)
			--}
			
			Update(player)
		end
		
		-- HeroPerkWindowShow
		---@param player player
		---@param isShow boolean
		local function HeroPerkWindowShow(player, isShow)
			if isShow == nil then isShow = not BlzFrameIsVisible(AbilWrap) end
			if player == GetLocalPlayer() then
				BlzFrameSetVisible(AbilWrap, isShow)
				BlzFrameSetTexture(BtnTexture, BtnIcon[isShow and 2 or 1], 0, true)
			end
		end
		
		-- BtnTrigger
		local BtnTrigger = CreateTrigger()
		BlzTriggerRegisterFrameEvent(BtnTrigger, Btn, FRAMEEVENT_CONTROL_CLICK)
		TriggerAddAction(BtnTrigger, function() HeroPerkWindowShow(GetTriggerPlayer(), nil) end)
		
		local KeyTrigger = CreateTrigger()
		for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
			BlzTriggerRegisterPlayerKeyEvent(KeyTrigger, Player(i), OSKEY_ESCAPE, 0, true)
			BlzTriggerRegisterPlayerKeyEvent(KeyTrigger, Player(i), OSKEY_F2, 0, true)
		end
		TriggerAddAction(KeyTrigger, function()
			local key = BlzGetTriggerPlayerKey()
			if key == OSKEY_ESCAPE then
				HeroPerkWindowShow(GetTriggerPlayer(), false)
			elseif key == OSKEY_F2 then
				HeroPerkWindowShow(GetTriggerPlayer(), nil)
			end
		end)
		
		--{ TEST
		local V = 0.0
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
end