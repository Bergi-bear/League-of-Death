do
	local InitGlobals_hook = InitGlobals ---@type function
	function InitGlobals()
		InitGlobals_hook()
		
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
end

-- EVENT_PLAYER_UNIT_SPELL_EFFECT
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
	local targetX---@type real
	local targetY---@type real
	
	local spellId       = GetSpellAbilityId()
	local spellX        = GetSpellTargetX()
	local spellY        = GetSpellTargetY()
	local spellLevel    = GetUnitAbilityLevel(caster, spellId)
	local spellAngle    = AngleBetweenXY(casterX, casterY, spellX, spellY)
	local spellDistance = DistanceBetweenXY(casterX, casterY, spellX, spellY)
	
	-- Battle Rush -----------------------------------------------------------------------------
	if spellId == ABILITY.BattleRush.id then
		local ability     = ABILITY.BattleRush
		
		local cos         = math.cos(spellAngle)
		local sin         = math.sin(spellAngle)
		local effect      = AddSpecialEffectTarget('Effect/Ability/BattleRush/Caster.mdx', caster, 'origin')
		local speedInc    = 2000 / (1 / TIMER_PERIOD)
		local damage      = BlzGetUnitBaseDamage(caster, 1)
		local damageGroup = CreateGroup()
		local range       = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 1, 1) > 0 and 150 or 75
		
		TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
			casterX       = casterX + speedInc * cos
			casterY       = casterY + speedInc * sin
			spellDistance = spellDistance - speedInc
			
			if spellDistance <= 0 or not InMapXY(casterX, casterY) or not UnitAlive(caster) or not IsTerrainWalkable(casterX + 16 * cos, casterY + 16 * sin) then
				DestroyTimer(GetExpiredTimer())
				GroupClear(damageGroup)
				DestroyGroup(damageGroup)
				DestroyEffect(effect)
				return
			end
			
			local isPush = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 1, 3) > 0
			
			GroupEnumUnitsInRange(GROUP_ENUM_ONCE, casterX, casterY, range, nil)
			while true do
				target = FirstOfGroup(GROUP_ENUM_ONCE)
				if target == nil then break end
				
				if UnitAlive(target) and IsPlayerEnemy(casterOwner, GetOwningPlayer(target)) then
					if isPush then
						targetX           = GetUnitX(target)
						targetY           = GetUnitY(target)
						local targetAngle = AngleBetweenXY(casterX, casterY, targetX, targetY)
						if AngleDiff(spellAngle, targetAngle) < bj_PI then
							SetUnitX(target, targetX + speedInc * math.cos(targetAngle))
							SetUnitY(target, targetY + speedInc * math.sin(targetAngle))
						end
					end
					
					if not IsUnitInGroup(target, damageGroup) then
						AddSpecialEffectTargetOnce('Abilities/Weapons/VengeanceMissile/VengeanceMissile.mdl', target, 'chest')
						GroupAddUnit(damageGroup, target)
						UnitDamageTarget(caster, target, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
					end
				end
				
				GroupAddUnit(damageGroup, target)
				GroupRemoveUnit(GROUP_ENUM_ONCE, target)
			end
			
			SetUnitX(caster, casterX)
			SetUnitY(caster, casterY)
		
		end)
		return
	end
	
	-- Shaking Blow -----------------------------------------------------------------------------
	if spellId == ABILITY.ShakingBlow.id then
		local ability        = ABILITY.ShakingBlow
		local range          = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 1, 1) > 0 and 600 or 400
		local scale          = range / 300
		
		local damage         = BlzGetUnitBaseDamage(caster, 1) + GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 1, 2) > 0 and GetHeroStr(caster, true) or 0 ---@type integer
		local damaged        = 0
		local isDamageCenter = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 3, 1) > 0
		if isDamageCenter then AddSpecialEffectOnce('Effect/Ability/ShakingBlow/AreaExtend.mdx', casterX, casterY) end
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
			UnitApplyTimedLife(dummy, BTLF_ID, 10)
			IssuePointOrderById(dummy, 852121, casterX, casterY)
		end
		
		if GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 3, 2) > 0 then
			local cos         = math.cos(spellAngle)
			local sin         = math.sin(spellAngle)
			local missile     = AddSpecialEffect('Effect/Ability/ShakingBlow/Wave/Wave.mdx', casterX, casterY)
			local x           = casterX
			local y           = casterY
			local speedInc    = 1200 / (1 / TIMER_PERIOD)
			local distance    = range * 2
			local damageGroup = CreateGroup()
			BlzSetSpecialEffectYaw(missile, spellAngle)
			BlzSetSpecialEffectHeight(missile, 0)
			TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
				x        = x + speedInc * cos
				y        = y + speedInc * sin
				distance = distance - speedInc
				
				if distance <= 0 or not InMapXY(x, y) then
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
		return
	end
	
	if spellId == 123 then
		--[|cffffcc00Уровень 1|r]
		--print("Пытаемся изменить подсказку")
		--local tips="Наносит урон врагам впереди себя \nУрон: Базовый урон x 2 ("..dability..") \nОбласть поражения: "..rability.."\nПерезарядка: "..abicd.." \nАгр: "..argtip.." \nЗамедление: "..stip.." \nПонижение брони: "..armtip.." \nЛегендарный: "..ltip
		--local tips = "Наносит урон врагам впереди себя \n|cffffcc00Урон:|r Базовый урон x 2 (|cffffcc00" .. dability .. "|r) \n|cffffcc00Область поражения:|r " .. rability .. "\n|cffffcc00Перезарядка:|r " .. abicd .. " \n|cffffcc00Агр:|r " .. argtip .. " \n|cffffcc00Замедление:|r " .. stip .. " \n|cffffcc00Понижение брони:|r " .. armtip .. " \n|cffffcc00Легендарный:|r " .. ltip
		
		--BlzSetAbilityExtendedTooltip(GetSpellAbilityId(), "111", 1)
		--BlzSetAbilityExtendedTooltip(GetSpellAbilityId(), "222", 2)--  работает на 0 уровне
		---BlzSetAbilityExtendedTooltip(GetSpellAbilityId(), tips, 0)
		--call BlzSetAbilityExtendedTooltip( 'ANcl', "Extended", 0 )
		--print("tips changed")
		--
	end

end)