function EVENT_PLAYER_UNIT_SPELL_EFFECT_INIT()
	-- Shaking Blow
	local DATA        = ABILITY.ShakingBlow.data ---@type table
	
	DATA.DummyId      = FourCC('dumy')
	DATA.earthquakeId = FourCC('ASBE')
	DATA.Dummy        = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), DATA.DummyId, 0, 0, 0)
	UnitAddAbility(DATA.Dummy, FourCC('ASBS')) -- slow
	UnitAddAbility(DATA.Dummy, FourCC('ASBA')) -- defence
	UnitAddAbility(DATA.Dummy, FourCC('ASBD')) -- damage
	UnitAddAbility(DATA.Dummy, DATA.earthquakeId) -- earthquake
	
	---@param target unit
	---@param order integer
	DATA.DummyCastTarget = function(target, order)
		SetUnitX(DATA.Dummy, GetUnitX(target))
		SetUnitY(DATA.Dummy, GetUnitY(target))
		IssueTargetOrderById(DATA.Dummy, order, target)
	end
	
	---@param caster unit
	---@param target unit
	---@param damage real
	---@param isCastSlow boolean
	---@param isCastDefence boolean
	---@param isCastAttack boolean
	---@param isProvocate boolean
	---@return integer
	DATA.Damage          = function(caster, target, damage, isCastSlow, isCastDefence, isCastAttack, isProvocate)
		local casterOwner = GetOwningPlayer(caster)
		if not UnitAlive(target) or not IsPlayerEnemy(casterOwner, GetOwningPlayer(target)) then return 0 end
		
		DestroyEffect(AddSpecialEffectTarget('Effect/Ability/ShakingBlow/Target.mdx', target, 'origin'))
		if isCastSlow then DATA.DummyCastTarget(target, 852075) end -- slow
		if isCastDefence then DATA.DummyCastTarget(target, 852662) end -- acidbomb
		if isCastAttack then DATA.DummyCastTarget(target, 852189) end -- cripple
		if isProvocate then IssueTargetOrderById(target, 851983, caster) end -- 851983
		
		UnitDamageTarget(caster, target, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
		return 1
	end
end

-- EVENT_PLAYER_UNIT_SPELL_EFFECT
local EVENT_PLAYER_UNIT_SPELL_EFFECT_TRIGGER = CreateTrigger()
for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
	TriggerRegisterPlayerUnitEvent(EVENT_PLAYER_UNIT_SPELL_EFFECT_TRIGGER, Player(i), EVENT_PLAYER_UNIT_SPELL_EFFECT)
end
TriggerAddAction(EVENT_PLAYER_UNIT_SPELL_EFFECT_TRIGGER, function()
	local caster      = GetTriggerUnit()
	local casterX     = GetUnitX(caster)
	local casterY     = GetUnitY(caster)
	
	local casterOwner = GetOwningPlayer(caster)
	
	local target ---@type unit
	
	local spellId     = GetSpellAbilityId()
	local spellX      = GetSpellTargetX()
	local spellY      = GetSpellTargetY()
	local spellLevel  = GetUnitAbilityLevel(caster, spellId)
	--local spellDistance = DistanceBetweenXY(casterX, casterY, spellX, spellY)
	
	-- Shaking Blow
	if spellId == ABILITY.ShakingBlow.id then
		local ability        = ABILITY.ShakingBlow
		local range          = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 1, 1) > 0 and 600 or 400
		local scale          = range / 300
		
		local damage         = BlzGetUnitBaseDamage(caster, 1) + GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 1, 2) > 0 and GetHeroStr(caster, true) or 0 ---@type integer
		local damaged        = 0
		local isDamageCenter = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 3, 1) > 0
		if isDamageCenter then
			AddSpecialEffectXY('Effect/Ability/ShakingBlow/AreaExtend.mdx', casterX, casterY)
		end
		local isCastSlow    = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 1, 3) > 0
		local isCastDefence = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 2, 2) > 0
		local isCastAttack  = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 2, 3) > 0
		local isProvocate   = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 3, 3) > 0
		
		AddSpecialEffectMatrixScale('Abilities/Spells/Human/Thunderclap/ThunderClapCaster.mdl', casterX, casterY, scale, scale, 1)
		GroupEnumUnitsInRange(GROUP_ENUM_ONCE, casterX, casterY, range, nil)
		while true do
			target = FirstOfGroup(GROUP_ENUM_ONCE)
			if target == nil then break end
			
			local distance     = DistanceBetweenXY(casterX, casterY, GetUnitX(target), GetUnitY(target))
			local damageCenter = isDamageCenter and damage * ((range - distance) / distance) or 0
			damaged            = damaged + ability.data.Damage(caster, target, damage + damageCenter, isCastSlow, isCastDefence, isCastAttack, isProvocate)
			GroupRemoveUnit(GROUP_ENUM_ONCE, target)
		end
		
		if GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 2, 1) > 0 then
			local cooldown = BlzGetAbilityCooldown(spellId, spellLevel - 1)
			BlzSetUnitAbilityCooldown(caster, spellId, spellLevel - 1, math.max(0.1, cooldown - damaged * 0.2))
		end
		
		if GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 4, 1) > 0 then
			local dummy = CreateUnit(casterOwner, ability.data.DummyId, casterX, casterY, 0)
			UnitAddAbility(dummy, ability.data.earthquakeId)
			UnitApplyTimedLife(dummy, Dummy_BTLF, 10)
			IssuePointOrderById(dummy, 852121, casterX, casterY)
		end
		
		if GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 3, 2) > 0 then
			local angle       = AngleBetweenXY(casterX, casterY, spellX, spellY)
			local cos         = math.cos(angle)
			local sin         = math.sin(angle)
			local missile     = AddSpecialEffect('Effect/Ability/ShakingBlow/Wave/Wave.mdx', casterX, casterY)
			local x           = casterX
			local y           = casterY
			local speedInc    = 1200 / (1 / TIMER_PERIOD)
			local distance    = range * 2
			local damageGroup = CreateGroup()
			BlzSetSpecialEffectYaw(missile, angle)
			BlzSetSpecialEffectHeight(missile, 0)
			TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
				x        = x + speedInc * cos
				y        = y + speedInc * sin
				distance = distance - speedInc
				
				if distance <= 0 then
					DestroyEffect(missile)
					DestroyTimer(GetExpiredTimer())
					GroupClear(damageGroup)
					DestroyGroup(damageGroup)
					return
				end
				
				GroupEnumUnitsInRange(GROUP_ENUM_ONCE, x, y, 150, nil)
				while true do
					target = FirstOfGroup(GROUP_ENUM_ONCE)
					if target == nil then break end
					
					if not IsUnitInGroup(target, damageGroup) then
						ability.data.Damage(caster, target, damage, isCastSlow, isCastDefence, isCastAttack, isProvocate)
					end
					
					GroupAddUnit(damageGroup, target)
					GroupRemoveUnit(GROUP_ENUM_ONCE, target)
				end
				
				BlzSetSpecialEffectX(missile, x)
				BlzSetSpecialEffectY(missile, y)
			end)
		end
	end
	
	if spellId == 123 then
		-- выставляем перки
		local dability     = BlzGetUnitBaseDamage(caster, 1)-- урон
		local rability     = 150 -- радиус действия способности
		local effscale     = 1-- мастшабирование эффекта
		local distabil     = 0--максимальная дистанци
		local brokenarmory = false -- снижаем броню
		local isslow       = false -- замедляем
		local isaggr       = false -- агрим
		local abicd        = BlzGetAbilityCooldown(GetSpellAbilityId(), 1 - GetUnitAbilityLevel(caster, GetSpellAbilityId()))
		local ltip         = "Не изучен"
		local stip         = "нет"
		local argtip       = "нет"
		local armtip       = "нет"
		
		if true then
			rability = rability * 2
			effscale = 2
		end -- перк радиуса
		
		if true then
			SetUnitAbilityLevel(caster, GetSpellAbilityId(), 2)
			distabil = 600
			ltip     = "Наносит урон врагам по линии 3 раза"
			--print("Легендарный перк")
		end -- перк дистанции ЛЕГЕНДАРНЫЙ
		
		if true then
			isslow = true
			stip   = "50 % замедление на 5 секунд"
		end-- перк замедления
		
		if true then
			brokenarmory = true
			armtip       = "-5 брони на 5 сек"
		end--перк понижения брони
		
		if true then
			if abicd >= 5 then
				abicd = 1
				BlzSetUnitAbilityCooldown(caster, GetSpellAbilityId(), 1 - GetUnitAbilityLevel(caster, GetSpellAbilityId()), abicd)
				-- print(abicd)
			end
		end-- перкс перезарядки
		
		if true then
			dability = dability * 1.5
		
		end -- перк урона
		
		if true then
			argtip = "Да"
			isaggr = true
		end -- перк агра
		
		--[|cffffcc00Уровень 1|r]
		--print("Пытаемся изменить подсказку")
		--local tips="Наносит урон врагам впереди себя \nУрон: Базовый урон x 2 ("..dability..") \nОбласть поражения: "..rability.."\nПерезарядка: "..abicd.." \nАгр: "..argtip.." \nЗамедление: "..stip.." \nПонижение брони: "..armtip.." \nЛегендарный: "..ltip
		local tips = "Наносит урон врагам впереди себя \n|cffffcc00Урон:|r Базовый урон x 2 (|cffffcc00" .. dability .. "|r) \n|cffffcc00Область поражения:|r " .. rability .. "\n|cffffcc00Перезарядка:|r " .. abicd .. " \n|cffffcc00Агр:|r " .. argtip .. " \n|cffffcc00Замедление:|r " .. stip .. " \n|cffffcc00Понижение брони:|r " .. armtip .. " \n|cffffcc00Легендарный:|r " .. ltip
		
		--BlzSetAbilityExtendedTooltip(GetSpellAbilityId(), "111", 1)
		--BlzSetAbilityExtendedTooltip(GetSpellAbilityId(), "222", 2)--  работает на 0 уровне
		BlzSetAbilityExtendedTooltip(GetSpellAbilityId(), tips, 0)
		--call BlzSetAbilityExtendedTooltip( 'ANcl', "Extended", 0 )
		--print("tips changed")
		--
		
		TimerStart(CreateTimer(), 0.4, false, function()
			DestroyTimer(GetExpiredTimer())
			print("активация грохота на дистанции")
			if distabil == 0 then a = f end
			local d = 50
			--a=bj_RADTODEG*Atan2(sy - y, sx - x)
			
			TimerStart(CreateTimer(), 0.1, true, function()
				
				if d >= distabil then DestroyTimer(GetExpiredTimer()) end
				-- урон
				GroupEnumUnitsInRange(GROUP_ENUM_ONCE, GetPolarOffsetX(casterX, d, a), GetPolarOffsetY(casterY, d, a), rability, nil)
				while true do
					e = FirstOfGroup(GROUP_ENUM_ONCE)
					if e == nil then break end
					if IsUnitEnemy(e, GetOwningPlayer(caster)) then
						UnitDamageTarget(caster, e, dability, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
						
						if isslow then
							--DummyCastOnUnit(caster, FourCC('A003'), 1, 852075, e) -- slow
						end
						
						if isaggr and IsUnitDeadBJ(e) == false then
							print("agr " .. GetUnitName(e))
							IssueTargetOrder(e, "attack", caster)
						end
					
					end
					GroupRemoveUnit(GROUP_ENUM_ONCE, e)
				end
				-- урон конец
				
				BlzSetSpecialEffectScale(AddSpecialEffect("Abilities/Spells/Human/Thunderclap/ThunderClapCaster.mdl", GetPolarOffsetX(casterX, d, a), GetPolarOffsetY(casterY, d, a)), effscale)
				if brokenarmory then DummyCast(caster, FourCC('I000'), GetPolarOffsetX(casterX, d, a), GetPolarOffsetY(casterY, d, a)) end
				d = (rability) + d
				--print(d)
			end)
		end)
		return
	end
	
	
	--Яростный врыв, прыжок
	if GetSpellAbilityId() == FourCC('A004') then
		
		--ForceUnit(caster, dtp, 30, a)
	end
	-- другая способность

end)-- end triggerUSpE