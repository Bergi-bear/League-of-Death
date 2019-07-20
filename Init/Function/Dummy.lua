do
	local InitGlobalsOrigin = InitGlobals ---@type function
	function InitGlobals()
		InitGlobalsOrigin()
		DUMMY = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC('dumy'), 0, 0, 0)
		
		-- Stun
		local StunId = FourCC('stun')
		UnitAddAbility(DUMMY, StunId)
		local StunAbility = BlzGetUnitAbility(DUMMY, StunId)
		---@param target unit
		---@param duration real
		function DummyCastStun(target, duration)
			SetUnitX(DUMMY, GetUnitX(target))
			SetUnitY(DUMMY, GetUnitY(target))
			BlzSetAbilityRealLevelField(StunAbility, ABILITY_RLF_DURATION_NORMAL, 0, duration)
			BlzSetAbilityRealLevelField(StunAbility, ABILITY_RLF_DURATION_HERO, 0, duration)
			IssueTargetOrderById(DUMMY, 852095, target) -- thunderbolt
		end
	end
end

---@param target unit
---@param id integer
---@param x real
---@param y real
function DummyCast (target, id, x, y)
	UnitAddItem(target,
	            CreateItem(
			            id,
			            x == nil and GetUnitX(target) or x,
			            y == nil and GetUnitY(target) or y
	            )
	)
end

---@param target unit
---@param order integer
function DummyCastTarget(target, order)
	SetUnitX(DUMMY, GetUnitX(target))
	SetUnitY(DUMMY, GetUnitY(target))
	IssueTargetOrderById(DUMMY, order, target)
end