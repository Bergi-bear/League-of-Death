local t = CreateTrigger()
TriggerRegisterPlayerEvent(t, Player(0), EVENT_PLAYER_END_CINEMATIC)
TriggerAddAction(t, function()
	print()
	print()
	print()
	ClearTextMessages()
	for i = 0, 11 do
		print(BlzFrameIsVisible(BlzGetOriginFrame(ORIGIN_FRAME_COMMAND_BUTTON, i)))
	end

end)