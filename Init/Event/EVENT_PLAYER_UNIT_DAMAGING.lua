-- cистема урона с руки
EVENT_PLAYER_UNIT_DAMAGING_TRIGGER = CreateTrigger()
for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
	TriggerRegisterPlayerUnitEvent(EVENT_PLAYER_UNIT_DAMAGING_TRIGGER, Player(i), EVENT_PLAYER_UNIT_DAMAGING)
end
TriggerAddCondition(EVENT_PLAYER_UNIT_DAMAGING_TRIGGER, Condition(function() return GetEventDamage() > 1 end))
TriggerAddAction(EVENT_PLAYER_UNIT_DAMAGING_TRIGGER, function()
	
	-- код функции сюда пишем условия
	local target = GetTriggerUnit() -- тот кто получил урон
	local caster = GetEventDamageSource() -- тот кто нанёс урон
	local damage = GetEventDamage() -- число урона
	
	-- блок башера
	if BlzGetEventDamageType() == DAMAGE_TYPE_NORMAL and UnitHasItemOfTypeBJ(caster, FourCC('I001')) and GetUnitAbilityLevel(caster, FourCC('A007')) == 0 then
		--
		local item = GetItemOfTypeFromUnitBJ(caster, FourCC('I001'))
		SetItemCharges(item, GetItemCharges(item) + 1) --увеличиваем заряды предмета за удар
		
		if GetItemCharges(item) >= 5 then
			SetItemCharges(item, 0)
			--print("прок баша, перезапуск")
			DummyCastOnUnit(caster, FourCC('A005'), 1, "creepthunderbolt", target)-- само оглушение башем
			BlzSetEventDamage(damage * 2)-- увеличиваем входщий урон в 2 раза
			StartItemCooldown(item, caster, FourCC('A007'))
		end
	end
	--- блок щита
	if UnitHasItemOfTypeBJ(target, FourCC('I002')) and GetUnitAbilityLevel(target, FourCC('A006')) == 0 then
		print("лечение щита")
		Heal(target, target, 50, true)
		item = GetItemOfTypeFromUnitBJ(target, FourCC('I002')) -- помещаем в переменную предмет
		StartItemCooldown(item, target, FourCC('A006'))-- стартуем кд на предмете
		--UnitAddItem(u, CreateItem(FourCC('I002'), 0, 0))-- добавлением эффект лечения через руну
	end
end)