local EVENT_PLAYER_UNIT_SPELL_EFFECT_TRIGGER = CreateTrigger()
for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
	TriggerRegisterPlayerUnitEvent(EVENT_PLAYER_UNIT_SPELL_EFFECT_TRIGGER, Player(i), EVENT_PLAYER_UNIT_SPELL_EFFECT)
end
TriggerAddAction(EVENT_PLAYER_UNIT_SPELL_EFFECT_TRIGGER, function()
	local caster        = GetTriggerUnit()
	local casterX       = GetUnitX(caster)
	local casterY       = GetUnitY(caster)
	
	local casterOwner   = GetOwningPlayer(caster)
	
	local target ---@type unit
	
	local spellId       = GetSpellAbilityId()
	local spellX        = GetSpellTargetX()
	local spellY        = GetSpellTargetY()
	local spellLevel    = GetUnitAbilityLevel(caster, spellId)
	local spellDistance = DistanceBetweenXY(casterX, casterY, spellX, spellY)
	
	-- ShakingBlow
	if spellId == ABILITY.ShakingBlow.id then
		local codename = ABILITY.ShakingBlow.codename ---@type string
		local damage   = BlzGetUnitBaseDamage(caster, 1)
		local range    = 400
		
		if GetPlayerAbilityPerkLevel(casterOwner, codename, 1, 1) > 0 then
			range = 1000
		end
		
		local scale = range / 300
		AddSpecialEffectMatrixScale('Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl', casterX, casterY, scale, scale, 1)
		
		GroupEnumUnitsInRange(GROUP_ENUM_ONCE, casterX, casterY, range, nil)
		while true do
			target = FirstOfGroup(GROUP_ENUM_ONCE)
			if target == nil then break end
			
			BlzSetUnitAbilityCooldown(caster, spellId, spellLevel - 1, 0.1)
			
			if UnitAlive(target) and IsPlayerEnemy(casterOwner, GetOwningPlayer(target)) then
				UnitDamageTarget(caster, target, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
				DestroyEffect(AddSpecialEffectTarget('Effect\\Ability\\ShakingBlowTarget.mdx', target, 'origin'))
			end
			GroupRemoveUnit(GROUP_ENUM_ONCE, target)
		end
		
		return
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
				
				BlzSetSpecialEffectScale(AddSpecialEffect("Abilities\\Spells\\Human\\Thunderclap\\ThunderClapCaster.mdl", GetPolarOffsetX(casterX, d, a), GetPolarOffsetY(casterY, d, a)), effscale)
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



--force={}
--function PrintSpeed(u)
--   local h=GetHandleId(u)
--   force[h]={speed=10} -- set
--   print(force[h].speed)-- get-- выводит 10 всё норм
--end

function ForceUnit(u, d, s, a, flag, mf)
	--print("u "..GetUnitName(u))
	--print("d "..d)
	--print("s "..s)
	--print("a "..a)
	--print("flag "..flag)
	--print("mf "..mf)
	local h  = GetHandleId(u)
	local w  = 0
	local wf = 0
	
	if mf == nil then
		mf = 0
	else
		MakeUnitFly(u)
	end
	
	--[[
	--print(2)
	TimerStart(CreateTimer(), 0.03333, true, function()
		-- 30 раз в секунду
		--print("starttimer")
		local f = ParabolaZ(mf, d, wf * s)
		local x = GetPolarOffsetX(GetUnitX(u), s, a)
		local y = GetPolarOffsetY(GetUnitY(u), s, a)
		w       = w + s
		wf      = wf + 1
		
		-- если всё нормально, пытаемся сдвинуться
		SetUnitXY(u, x, y)
		if f ~= nil then
			print("f=" .. f)
		end
		SetUnitZ(u, f + GetTerrainZ(x, y))
		
		--print("w+s="..w)
		if w >= d or Out(x, y) == false or GetTerrainZ(GetUnitX(u), GetUnitY(u)) <= GetTerrainZ(x, y) - 10 then
			--
			--
			print("stop")
			DestroyTimer(GetExpiredTimer())
			IssueImmediateOrder(u, "stop")
			SetUnitZ(u, 0)
		end
	end)
	]]
end