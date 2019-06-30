do
	local InitGlobals_hook = InitGlobals
	function InitGlobals()
		InitGlobals_hook()
		
		-- setting
		math.randomseed(os.time())
		
		-- PLAYER
		PLAYER = {}
		for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
			PLAYER[i] = {
				hero              = nil,
				heroSelectBgModel = '',
				race              = math.random(1, #RACE - 1),
				attr              = math.random(1, 3),
				perkPoint         = 1,
				perk              = {}
			}
			
			for k = 1, 6 do
				PLAYER[i].perk[k] = {
					{ 0, 0, 0 }, --> 1
					{ 0, 0, 0 }, --> 2
					{ 0, 0, 0 }, --> 3
					{ 0 }, --> 4
				}
			end
		end
		
		---@param player player
		---@param ability integer
		---@param perk integer
		---@return integer
		function GetPlayerPerkLevel(player, ability, perk)
			return PLAYER[GetPlayerId(player)][ability][perk]
		end
		
		-- init
		HeroPickInit()
		--HeroPerkInit()
	end
end