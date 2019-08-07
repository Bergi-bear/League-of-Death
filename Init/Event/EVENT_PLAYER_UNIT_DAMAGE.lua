do
	local DamageTrigger = CreateTrigger()
	for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
		TriggerRegisterPlayerUnitEvent(DamageTrigger, Player(i), EVENT_PLAYER_UNIT_DAMAGING) -- До вычета брони
		TriggerRegisterPlayerUnitEvent(DamageTrigger, Player(i), EVENT_PLAYER_UNIT_DAMAGED) -- После вычета брони
	end
	TriggerAddAction(DamageTrigger, function()
		local damage     = GetEventDamage() -- число урона
		local damageType = BlzGetEventDamageType()
		if damage < 1 then return end
		
		local eventId         = GetHandleId(GetTriggerEventId())
		local isEventDamaging = eventId == GetHandleId(EVENT_PLAYER_UNIT_DAMAGING)
		local isEventDamaged  = eventId == GetHandleId(EVENT_PLAYER_UNIT_DAMAGED)
		
		local target          = GetTriggerUnit() -- тот кто получил урон
		local caster          = GetEventDamageSource() -- тот кто нанёс урон
		local casterOwner     = GetOwningPlayer(caster)
		
		--{ FIXME DEBUG
		if false then
			print('-----------------------', damage)
			print('damaging', isEventDamaging)
			print('damaged', isEventDamaged)
		end
		--}
		
		if isEventDamaged then -- не указано какой тип предмета перезаряжается, Назар Всё сломал =(
			local data---@type table
			-- тут какой-то баг, ибо этот свойство срабатывает у любого предмета
			if IsUnitType(target, UNIT_TYPE_HERO) then
				for i = 0, bj_MAX_INVENTORY do
					local item = UnitItemInSlot(target, i)
					if item ~= nil then
						local level = GetItemLevel(item)
						data        = ITEM.ShieldOfHeal
						if item ~= nil and GetUnitAbilityLevel(target, data.cd) == 0 and UnitHasItemOfTypeBJ(target,FourCC('ISoH')) then
							StartItemCooldown(GetItemOfTypeFromUnitBJ(target,FourCC('ISoH')), target, data.cd, data.cooldown - level)
							Heal(target, target, level * data.heal, true)
						end
					end
				end
			end
			
			if IsUnitType(caster, UNIT_TYPE_HERO) then -- маска смерти
				-- необходимо переместить способность после всех просчётов дамага для достижения максимального вампиризма у значения damage
				for i = 0, bj_MAX_INVENTORY do
					local item = UnitItemInSlot(caster, i)
					if item ~= nil then
						local level = GetItemLevel(item)
						if damageType == DAMAGE_TYPE_NORMAL then
							data = ITEM.MaskOfDeath
							if GetItemTypeId(item) == data.id then
								Heal(caster, caster, level <= 3 and level * data.heal or 60 + damage * 0.15, true)
							end
							data = ITEM.Basher
							if GetItemTypeId(item) == data.id and GetUnitAbilityLevel(caster, data.cd) == 0 then
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
				end
				
				--Гневный удар
				data = ABILITY.Swipe
				if damageType == DAMAGE_TYPE_NORMAL and GetUnitAbilityLevel(caster, data.id) > 0 then
					--local ability     = data
					--local normalbat
					local id= GetPlayerId(GetOwningPlayer(caster))
					local legendarymax=0
					PLAYER[id].SwipeCount = PLAYER[id].SwipeCount + 1
					AddItemToStock(caster, data.iditempass, PLAYER[id].SwipeCount, PLAYER[id].SwipeCount)
					if true then legendarymax=data.max/2 end-- легендарный перк
					if true and PLAYER[id].SwipeCount == data.max-legendarymax-1 then BlzSetUnitAttackCooldown(caster,0.3,0) end -- двойная атака, подготовка -- перк двойно атаки



					if PLAYER[id].SwipeCount >= data.max-legendarymax then--это момент удара
						--print("nset= "..normalbat) -- тут уже получается 0
						if true then BlzSetUnitAttackCooldown(caster, 1.77,0) end -- перк двойно атаки я ленивый, не написал в Player

						damage = damage * 2--обычное выставление дамага

						if true then damage=damage+GetHeroStr(caster,true) end-- perk допдамага от силы
						if true then damage=damage+GetUnitState(target,UNIT_STATE_MAX_LIFE)*.03 end-- perk допдамага От макс хп врага
						if true then damage=damage*(1+(1-GetUnitState(caster,UNIT_STATE_LIFE)/GetUnitState(caster,UNIT_STATE_MAX_LIFE))) end -- перк увеличивающий за процент потерянного хп
						if true then DummyCastStun(target, 1) end-- перк секундного стана
						if true then damage=damage+PLAYER[id].SwipeKilledCount end-- перк бонуса урона способности после убийств
						if true then
								UnitAddAbility(target,FourCC('Abun'))
							TimerStart(CreateTimer(), 5, false, function()
								UnitRemoveAbility(target,FourCC('Abun'))
								DestroyTimer(GetExpiredTimer())
							end)
						end -- разоружение на 5 секунд
						if true then UnitAddItem(caster,CreateItem(FourCC('IDCS'),0,0)) end-- ускорение, но нужно переделать на убийство

							BlzSetEventDamage(damage)
						PLAYER[id].SwipeCount = 0
						AddItemToStock(caster, data.iditempass, 0, 0)
						--SetUnitAnimation(caster, 'attack walk stand spin')
						if true then-- перкс сплеша
						GroupEnumUnitsInRange(GROUP_ENUM_ONCE, GetUnitX(target), GetUnitY(target), 150, nil)
						while true do
							local e = FirstOfGroup(GROUP_ENUM_ONCE)
							if e == nil then break end
							if IsUnitEnemy(caster, GetOwningPlayer(e)) then
								UnitDamageTarget(caster, e, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
							end
							GroupRemoveUnit(GROUP_ENUM_ONCE, e)
						end
						end
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