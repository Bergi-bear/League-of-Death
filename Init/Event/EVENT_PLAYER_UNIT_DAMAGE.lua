do
	local DamageTrigger = CreateTrigger()
	for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
		local player = Player(i)
		TriggerRegisterPlayerUnitEvent(DamageTrigger, player, EVENT_PLAYER_UNIT_DAMAGING)
		TriggerRegisterPlayerUnitEvent(DamageTrigger, player, EVENT_PLAYER_UNIT_DAMAGED)
	end
	TriggerAddCondition(DamageTrigger, Condition(function() return GetEventDamage() >= 1 end))
	TriggerAddAction(DamageTrigger, function()
		local eventId         = GetHandleId(GetTriggerEventId())
		local isEventDamaging = eventId == GetHandleId(EVENT_PLAYER_UNIT_DAMAGING) -- До вычета брони
		local isEventDamaged  = eventId == GetHandleId(EVENT_PLAYER_UNIT_DAMAGED) -- После вычета брони
		
		local target          = GetTriggerUnit() -- тот кто получил урон
		local caster          = GetEventDamageSource() -- тот кто нанёс урон
		local damage          = GetEventDamage() -- число урона
		local damageType      = BlzGetEventDamageType()
		
		--{ DEBUG
		if false then
			print('-----------------------', damage)
			print('damaging', isEventDamaging)
			print('damaged', isEventDamaged)
		end
		--}
		
		if isEventDamaged then
			local item
			local data
			
			if IsUnitType(target, UNIT_TYPE_HERO) then
				data = ITEM.ShieldOfHeal
				item = GetInventoryItemById(target, data.id)
				if item ~= nil and GetUnitAbilityLevel(target, data.cd) == 0 then
					local level = GetItemLevel(item)
					StartItemCooldown(item, target, data.cd, data.cooldown - level)
					Heal(target, target, level * data.heal, true)
				end
			end
			
			if IsUnitType(caster, UNIT_TYPE_HERO) then
				data = ITEM.Basher
				item = GetInventoryItemById(caster, data.id)
				if item ~= nil and damageType == DAMAGE_TYPE_NORMAL and GetUnitAbilityLevel(caster, data.cd) == 0 then
					SetItemCharges(item, GetItemCharges(item) + 1)
					if GetItemCharges(item) >= 5 then
						SetItemCharges(item, 0)
						damage = damage * 2
						BlzSetEventDamage(damage)
						StartItemCooldown(item, caster, data.cd, 10)
						FlyTextTagCriticalStrike(target, math.ceil(damage) .. '!')
						DummyCastStun(target, 2)
					end
				end
			end
		end
	end)
end