do
	local InitGlobals_hook = InitGlobals ---@type function
	function InitGlobals()
		InitGlobals_hook()
		
		-- frame
		BlzLoadTOCFile('UI\\Frame\\Main.toc')
		
		-- PLAYER
		PLAYER = {}
		for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
			SetPlayerState(Player(i), PLAYER_STATE_RESOURCE_GOLD, 9000)
			SetPlayerState(Player(i), PLAYER_STATE_RESOURCE_LUMBER, 9000)
			
			PLAYER[i] = {
				hero                   = nil,
				ability                = nil,
				race                   = math.random(1, #RACE - 1),
				attr                   = math.random(1, 3),
				perkPoint              = 60,
				perk                   = {},
				HeroPick_BgModel       = '',
				HeroPerk_AbilitySelect = 1,
				SwipeCount			   = 0,
				SwipeKilledCount 	   = 0
			}
		end
	end
end

---@param player player
---@param ability string
---@param row integer
---@param col integer
---@return integer
function GetPlayerAbilityPerkLevel(player, ability, row, col)
	local id = GetPlayerId(player)
	if (PLAYER[id].perk[ability] == nil) then return -1 end
	return PLAYER[id].perk[ability][row][col]
end

---@param player player
---@return table
function GetPlayerAbilityPerkLevels(player, ability)
	local id    = GetPlayerId(player)
	local count = { [0] = 1, 0, 0, 0, 0 }
	
	local perk  = PLAYER[id].perk[ability]
	
	for row = 1, 3 do
		for col = 1, 3 do
			count[row] = count[row] + perk[row][col]
		end
	end
	
	if count[1] > 0 and count[2] > 0 and count[3] > 0 then
		count[4] = 1
	end
	
	return count
end