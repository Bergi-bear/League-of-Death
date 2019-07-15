---@param frame framehandle
---@param texFile string
---@param player player
function FrameSetTexture(frame, texFile, player)
	if player == nil or player == GetLocalPlayer() then
		BlzFrameSetTexture(frame, texFile, 0, true)
	end
end

---@param frame framehandle
---@param modelFile string
---@param player player
function FrameSetModel(frame, modelFile, player)
	if player == nil or player == GetLocalPlayer() then
		BlzFrameSetModel(frame, modelFile, 0)
	end
end

---@param frame framehandle
---@param enabled boolean
---@param player player
function FrameSetEnable(frame, enabled, player)
	if player == nil or player == GetLocalPlayer() then
		BlzFrameSetEnable(frame, enabled)
	end
end

---@param frame framehandle
---@param visible boolean
---@param player player
function FrameSetVisible(frame, visible, player)
	if player == nil or player == GetLocalPlayer() then
		BlzFrameSetVisible(frame, visible)
	end
end

---@param frame framehandle
---@param text string
---@param player player
function FrameSetText(frame, text, player)
	if player == nil or player == GetLocalPlayer() then
		BlzFrameSetText(frame, text)
	end
end

do
	local FocusTrigger = CreateTrigger()
	TriggerAddAction(FocusTrigger, function()
		if GetTriggerPlayer() == GetLocalPlayer() then
			BlzFrameSetEnable(BlzGetTriggerFrame(), false)
			BlzFrameSetEnable(BlzGetTriggerFrame(), true)
		end
	end)
	
	---@param frame framehandle
	function FrameRegisterNoFocus(frame)
		BlzTriggerRegisterFrameEvent(FocusTrigger, frame, FRAMEEVENT_CONTROL_CLICK)
	end
end