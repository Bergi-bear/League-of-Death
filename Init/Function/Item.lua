---@param item item
---@param target unit
---@param ability integer
function StartItemCooldown(item, target, ability)
	-- предмет, носитель предмета, ид способности по типу амулета защиты
	print("startitemCD")
	BlzItemAddAbility(item, ability)
	DummyCastOnUnit(nil, FourCC('A005'), 1, "creepthunderbolt", target)-- A001 пускатель перезарядки баша
	local cd = BlzGetAbilityCooldown(ability, 0)-- где 0 - первый уровень способности
	--print(cd)
	TimerStart(CreateTimer(), cd, false, function()
		BlzItemRemoveAbility(item, ability)
		DestroyTimer(GetExpiredTimer())
	end)
end