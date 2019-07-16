-- cистема урона с руки
EVENT_PLAYER_UNIT_DAMAGING_TRIGGER = CreateTrigger()
for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
	TriggerRegisterPlayerUnitEvent(EVENT_PLAYER_UNIT_DAMAGING_TRIGGER, Player(i), EVENT_PLAYER_UNIT_DAMAGING)
end
TriggerAddCondition(EVENT_PLAYER_UNIT_DAMAGING_TRIGGER, Condition(function() return GetEventDamage() >= 1 end))
TriggerAddAction(EVENT_PLAYER_UNIT_DAMAGING_TRIGGER, function()
	
	-- код функции сюда пишем условия
	local target                = GetTriggerUnit() -- тот кто получил урон
	local caster                = GetEventDamageSource() -- тот кто нанёс урон
	local damage                = GetEventDamage() -- число урона
	
	-- блок башера
	local BasherItem            = FourCC('I001')
	local BasherAbility         = FourCC('A005')
	local BasherCooldownAbility = FourCC('A007')
	if BlzGetEventDamageType() == DAMAGE_TYPE_NORMAL and UnitHasItemOfTypeBJ(caster, BasherItem) and GetUnitAbilityLevel(caster, BasherCooldownAbility) == 0 then
		--
		local item = GetItemOfTypeFromUnitBJ(caster, BasherItem)
		SetItemCharges(item, GetItemCharges(item) + 1) --увеличиваем заряды предмета за удар
		
		if GetItemCharges(item) >= 5 then
			SetItemCharges(item, 0)
			--print("прок баша, перезапуск")
			DummyCastOnUnit(caster, BasherAbility, 1, "creepthunderbolt", target)-- само оглушение башем
			BlzSetEventDamage(damage * 2)-- увеличиваем входщий урон в 2 раза
			StartItemCooldown(item, caster, BasherCooldownAbility)
		end
	end
	
	-- блок щита
	local ShieldItem            = FourCC('I002')
	local ShieldCooldownAbility = FourCC('A006')
	if UnitHasItemOfTypeBJ(target, ShieldItem) and GetUnitAbilityLevel(target, ShieldCooldownAbility) == 0 then
		print("лечение щита")
		Heal(target, target, 50, true)
		item = GetItemOfTypeFromUnitBJ(target, ShieldItem) -- помещаем в переменную предмет
		StartItemCooldown(item, target, ShieldCooldownAbility)-- стартуем кд на предмете
		--UnitAddItem(u, CreateItem(ShieldItem, 0, 0))-- добавлением эффект лечения через руну
	end
end)