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
		local casterOwner     = GetOwningPlayer(caster)
		local damage          = GetEventDamage() -- число урона
		local damageType      = BlzGetEventDamageType()
		
		--{ FIXME DEBUG
		if false then
			print('-----------------------', damage)
			print('damaging', isEventDamaging)
			print('damaged', isEventDamaged)
		end
		--}
		
		if isEventDamaged then
			local data---@type table
			local item---@type item
			local level ---@type integer
			
			if IsUnitType(target, UNIT_TYPE_HERO) then
				--Исцеляющий щит
				data        = ITEM.ShieldOfHeal
				item, level = GetInventoryItemById(target, data.id)
				if item ~= nil and GetUnitAbilityLevel(target, data.cd) == 0 then
					StartItemCooldown(item, target, data.cd, data.cooldown - level)
					Heal(target, target, level * data.heal, true)
				end
			end
			
			if IsUnitType(caster, UNIT_TYPE_HERO) then
				-- Маска смерти
				data        = ITEM.MaskOfDeath
				item, level = GetInventoryItemById(caster, data.id)
				if item ~= nil and damageType == DAMAGE_TYPE_NORMAL then
					
					if level <= 3 then
						Heal(caster, caster, level * data.heal, true)
					else
						Heal(caster, caster, 60 + damage * .15, true)
					end
				end
				
				-- Башер
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
				
				--Крутилка
				data = ABILITY.Swipe
				if damageType == DAMAGE_TYPE_NORMAL and GetUnitAbilityLevel(caster, data.id) > 0 then
					local id              = GetPlayerId(GetOwningPlayer(caster))
					PLAYER[id].SwipeCount = PLAYER[id].SwipeCount + 1
					AddItemToStock(caster, data.iditempass, PLAYER[id].SwipeCount, PLAYER[id].SwipeCount)
					if PLAYER[id].SwipeCount >= data.max then
						PLAYER[id].SwipeCount = 0
						AddItemToStock(caster, data.iditempass, 0, 0)
						SetUnitAnimation(caster, 'attack walk stand spin')
						GroupEnumUnitsInRange(GROUP_ENUM_ONCE, GetUnitX(caster), GetUnitY(caster), 200, nil)
						while true do
							local e = FirstOfGroup(GROUP_ENUM_ONCE)
							if e == nil then break end
							if IsUnitEnemy(caster, GetOwningPlayer(e)) then
								UnitDamageTarget(caster, e, 100, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
							end
							GroupRemoveUnit(GROUP_ENUM_ONCE, e)
						end
						TimerStart(CreateTimer(), 0.3, false, function()
							SetUnitAnimation(caster, 'stand')
							DestroyTimer(GetExpiredTimer())
						end)
					end
				end
			end
			
			-- Показыввем урон
			damage = GetEventDamage()
			if GetPlayerController(casterOwner) == MAP_CONTROL_USER and damage >= 1 then
				local textSize = 0.018 + damage / 10000
				FlyTextTag('-' .. math.ceil(damage), textSize, GetUnitX(target) - 32, GetUnitY(target), 32, 255, 0, 0, 255, 0, 0.03, 1.5, 2, casterOwner)
			end
		end
	end)
end