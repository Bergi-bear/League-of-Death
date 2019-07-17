do
	local InitGlobals_hook = InitGlobals ---@type function
	function InitGlobals()
		InitGlobals_hook()
		DUMMY = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC('dumy'), 0, 0, 0)
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

local DummyCastOnUnit_id = FourCC('e000')
---@param caster unit
---@param id integer
---@param level integer
---@param order string
---@param target unit
function DummyCastOnUnit (caster, id, level, order, target)
	local dummy = caster == nil
			and
			CreateUnit(Player(23), DummyCastOnUnit_id, GetUnitX(target), GetUnitY(target), 0)
			or
			CreateUnit(GetOwningPlayer(caster), DummyCastOnUnit_id, GetUnitX(caster), GetUnitY(caster), 0)
	UnitAddAbility(dummy, id)
	SetUnitAbilityLevel(dummy, id, level)
	IssueTargetOrder(dummy, order, target)
	UnitApplyTimedLife(dummy, BTLF_ID, 1)
end

---@param target unit
---@param order integer
function DummyCastTarget(target, order)
	SetUnitX(DUMMY, GetUnitX(target))
	SetUnitY(DUMMY, GetUnitY(target))
	IssueTargetOrderById(DUMMY, order, target)
end