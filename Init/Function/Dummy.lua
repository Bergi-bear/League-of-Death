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

do
	local BTLF = FourCC('BTLF')
	local ID   = FourCC('e000')
	
	---@param caster unit
	---@param id integer
	---@param level integer
	---@param order string
	---@param target unit
	function DummyCastOnUnit (caster, id, level, order, target)
		local dummy = caster == nil
				and
				CreateUnit(Player(23), ID, GetUnitX(target), GetUnitY(target), 0)
				or
				CreateUnit(GetOwningPlayer(caster), ID, GetUnitX(caster), GetUnitY(caster), 0)
		UnitAddAbility(dummy, id)
		SetUnitAbilityLevel(dummy, id, level)
		IssueTargetOrder(dummy, order, target)
		UnitApplyTimedLife(dummy, BTLF, 1)
	end

end