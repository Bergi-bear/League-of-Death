---@author http://lua-users.org/wiki/CopyTable
---@param org table
---@return table
function table.clone(org)
	return { table.unpack(org) }
end

---@param frame framehandle
---@param texFile string
---@param player player
function FrameSetTexture(frame, texFile, player)
	if player == nil or player == GetLocalPlayer() then
		BlzFrameSetTexture(frame, texFile, 0, true)
	end
end

---@param frame framehandle
---@param enabled boolean
function FrameSetEnable(frame, enabled)
	if player == nil or player == GetLocalPlayer() then
		BlzFrameSetEnable(frame, enabled)
	end
end

--> InitGlobals hook
local InitGlobals_hook = InitGlobals
function InitGlobals()
	InitGlobals_hook()
	
	-- setting
	math.randomseed(os.time())
	
	--> PLAYER
	PLAYER = {}
	for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
		PLAYER[i] = {
			hero                   = nil,
			ability                = nil,
			race                   = math.random(1, #RACE - 1),
			attr                   = math.random(1, 3),
			perkPoint              = 1,
			perk                   = {},
			HeroPick_BgModel       = '',
			HeroPerk_AbilitySelect = 1
		}
	end
	
	---@param player player
	---@param ability string
	---@param level integer
	---@param num integer
	---@return integer
	function GetPlayerAbilityPerkLevel(player, ability, level, num)
		local id = GetPlayerId(player)
		if (PLAYER[id].perk[ability] == nil) then return -1 end
		return PLAYER[id].perk[ability][level][num]
	end
	
	---@param player player
	---@return table
	function GetPlayerAbilityPerkLevels(player, ability)
		local id    = GetPlayerId(player)
		local count = { [0] = 1, 0, 0, 0, 0 }
		
		local perk  = PLAYER[id].perk[ability]
		
		for level = 1, 3 do
			for num = 1, 3 do
				count[level] = count[level] + perk[level][num]
			end
		end
		
		for i = 1, 3 do
			if GetPlayerAbilityPerkLevel(player, ability, 1, i) > 0
					and
					GetPlayerAbilityPerkLevel(player, ability, 2, i) > 0
					and
					GetPlayerAbilityPerkLevel(player, ability, 3, i) > 0
			then
				count[4] = 1
			end
		end
		
		return count
	end
	
	
	-- init
	HeroPerkInit()
	HeroPickInit()
end