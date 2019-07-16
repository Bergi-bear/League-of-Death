---@param item item
---@param target unit
---@param ability integer
---@param sec real
function StartItemCooldown(item, target, ability,sec)
	-- предмет, носитель предмета, ид способности по типу амулета защиты
	--print("startitemCD")
	BlzItemAddAbility(item, ability)
	local cd = BlzGetAbilityCooldown(ability, 0)
	if sec~=nil then
		BlzSetUnitAbilityCooldown(target,ability,0,sec)
		cd=sec
	end
	DummyCastOnUnit(nil, FourCC('A005'), 1, "creepthunderbolt", target)
	-- где 0 - первый уровень способности
	--print(cd)
	TimerStart(CreateTimer(), cd, false, function()
		BlzItemRemoveAbility(item, ability)
		DestroyTimer(GetExpiredTimer())
	end)
end