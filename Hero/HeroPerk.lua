function HeroPerkInit()
	local DEBUG---@type framehandle
	
	--[[
	local framehandle mainbutton = BlzCreateFrame("ScoreScreenBottomButtonTemplate", BlzGetOriginFrame(ORIGIN_FRAME_GAME_UI,0), 0,  0)
	local framehandle imgFrame = BlzGetFrameByName("ScoreScreenButtonBackdrop",  0)
	local framehandle tooltipBox = BlzCreateFrame("ListBoxWar3", mainbutton, 0,  0)
	local framehandle tooltip = BlzCreateFrameByType("TEXT", "StandardInfoTextTemplate", tooltipBox, "StandardInfoTextTemplate",  0)
	
	call BlzFrameSetSize(mainbutton, 0.04, 0.04)
	
	call BlzFrameSetSize(tooltipBox, 0.3, 0.1)
	call BlzFrameSetSize(tooltip, 0.28, 0.08)//tooltip-Text is smaller than the box, so it wont touch the border.

call BlzFrameSetTexture(imgFrame, "ReplaceableTextures\\CommandButtons\\BTNPeasant.blp", 0, true) //set the image of the imgFrame, with 0 the texture is streched with 1 the frame is filled with that texture.

call BlzFrameSetAbsPoint(mainbutton, FRAMEPOINT_TOPLEFT, 0.4, 0.3) //positionate button on the screen
	
	
	call BlzFrameSetPoint(tooltip, FRAMEPOINT_CENTER, tooltipBox, FRAMEPOINT_CENTER, 0.0, 0.0) //place tooltip into tooltipBox
	call BlzFrameSetPoint(tooltipBox, FRAMEPOINT_BOTTOM, mainbutton, FRAMEPOINT_TOP, 0.0, 0.0) //place tooltipBox with its bottom to the mainButtons TOP. tooltipBox will be over the mainbutton
	
	call BlzFrameSetTooltip(mainbutton, tooltipBox) //show tooltipBox only when mainbutton is hovered with the mouse.
call BlzFrameSetText(tooltip, "Sound\\Music\\mp3Music\\Credits.mp3|nSound\\Music\\mp3Music\\PH.mp3|n|cffffcc00Sound\\Music\\mp3Music\\War2IntroMusic.mp3") //text of the tooltip
]]
	
	
	--{ TEST
	local V      = 0.01
	---@type function
	local change = function(add)
		V = V + add
		BlzFrameSetText(DEBUG, V)
	end
	--} TEST
	
	--{ DEBUG
	DEBUG        = BlzCreateFrameByType('TEXT', '', RaceWrap, '', 0)
	BlzFrameSetSize(DEBUG, 0.555, 0.02)
	BlzFrameSetPoint(DEBUG, FRAMEPOINT_BOTTOMLEFT, RaceWrap, FRAMEPOINT_BOTTOMLEFT, 0, 0)
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