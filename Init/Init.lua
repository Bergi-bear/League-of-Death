---@author http://lua-users.org/wiki/CopyTable
---@param org table
---@return table
function table.clone(org)
	return { table.unpack(org) }
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
	
	-- init
	HeroPerkInit()
	HeroPickInit()
end