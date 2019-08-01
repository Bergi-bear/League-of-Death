do
	local InitGlobalsOrigin = InitGlobals ---@type function
	function InitGlobals()
		InitGlobalsOrigin()
		
		--[[Shaking Blow]]
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
		
		---@param caster
		---@param angle
		---@param offset real
		DATA.Cast            = function(caster, angle, offset)
			local player           = GetOwningPlayer(caster)
			local ability          = ABILITY.ShakingBlow
			local spellId          = ability.id
			
			local cos, sin         = math.cos(angle), math.sin(angle)
			local casterX, casterY = GetUnitX(caster) + offset * cos, GetUnitY(caster) + offset * sin
			
			local target---@type unit
			local range            = GetPlayerAbilityPerkLevel(player, ability.codename, 1, 1) > 0 and 600 or 400
			local scale            = range / 300
			
			local damage, damaged  = BlzGetUnitBaseDamage(caster, 1) + GetPlayerAbilityPerkLevel(player, ability.codename, 1, 2) > 0 and GetHeroStr(caster, true) or 0, 0 ---@type integer
			local isDamageCenter   = GetPlayerAbilityPerkLevel(player, ability.codename, 3, 1) > 0
			if isDamageCenter then AddSpecialEffectOnce('Effect/Ability/ShakingBlow/AreaExtend.mdx', casterX, casterY) end
			local isCastSlow    = GetPlayerAbilityPerkLevel(player, ability.codename, 1, 3) > 0
			local isCastDefence = GetPlayerAbilityPerkLevel(player, ability.codename, 2, 2) > 0
			local isCastAttack  = GetPlayerAbilityPerkLevel(player, ability.codename, 2, 3) > 0
			local isProvocate   = GetPlayerAbilityPerkLevel(player, ability.codename, 3, 3) > 0
			
			AddSpecialEffectOnce('Objects/Spawnmodels/Undead/ImpaleTargetDust/ImpaleTargetDust.mdl', casterX, casterY)
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
			
			if GetPlayerAbilityPerkLevel(player, ability.codename, 2, 1) > 0 then
				local level    = GetUnitAbilityLevel(caster, spellId)
				local cooldown = BlzGetAbilityCooldown(spellId, level - 1)
				BlzSetUnitAbilityCooldown(caster, spellId, level - 1, math.max(0.1, cooldown - damaged * 0.2))
			end
			
			if GetPlayerAbilityPerkLevel(player, ability.codename, 4, 1) > 0 then
				local dummy = CreateUnit(player, ability.data.DummyId, casterX, casterY, 0)
				UnitAddAbility(dummy, ability.data.earthquakeId)
				UnitApplyTimedLife(dummy, BTLF_ID, 10)
				IssuePointOrderById(dummy, 852121, casterX, casterY)
			end
			
			if GetPlayerAbilityPerkLevel(player, ability.codename, 3, 2) > 0 then
				local missile = AddSpecialEffect('Effect/Ability/ShakingBlow/Wave/Wave.mdx', casterX, casterY)
				BlzSetSpecialEffectScale(missile, 0.5)
				local speedInc    = 1200 / (1 / TIMER_PERIOD)
				local distance    = range * 2
				local damageGroup = CreateGroup()
				BlzSetSpecialEffectYaw(missile, angle)
				BlzSetSpecialEffectHeight(missile, 0)
				TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
					local x, y = GetUnitX(caster) + speedInc * cos, GetUnitY(caster) + speedInc * sin
					distance   = distance - speedInc
					
					if distance <= 0 or not InMapXY(x, y) then
						DestroyEffect(missile)
						GroupClear(damageGroup)
						DestroyGroup(damageGroup)
						return DestroyTimer(GetExpiredTimer())
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
	
	end
	
	local SpellXY      = {} ---@type table
	local SpellTrigger = CreateTrigger()
	for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
		local player = Player(i)
		TriggerRegisterPlayerUnitEvent(SpellTrigger, player, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		TriggerRegisterPlayerUnitEvent(SpellTrigger, player, EVENT_PLAYER_UNIT_SPELL_CAST)
		TriggerRegisterPlayerUnitEvent(SpellTrigger, player, EVENT_PLAYER_UNIT_SPELL_EFFECT)
		TriggerRegisterPlayerUnitEvent(SpellTrigger, player, EVENT_PLAYER_UNIT_SPELL_ENDCAST)
		TriggerRegisterPlayerUnitEvent(SpellTrigger, player, EVENT_PLAYER_UNIT_SPELL_FINISH)
	end
	TriggerAddAction(SpellTrigger, function()
		local eventId          = GetHandleId(GetTriggerEventId())
		local isEventChannel   = eventId == GetHandleId(EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		local isEventCast      = eventId == GetHandleId(EVENT_PLAYER_UNIT_SPELL_CAST)
		local isEventEffect    = eventId == GetHandleId(EVENT_PLAYER_UNIT_SPELL_EFFECT)
		local isEventEndCast   = eventId == GetHandleId(EVENT_PLAYER_UNIT_SPELL_ENDCAST)
		local isEventFinish    = eventId == GetHandleId(EVENT_PLAYER_UNIT_SPELL_FINISH)
		
		local caster           = GetTriggerUnit()
		local casterHandleId   = GetHandleId(caster)
		local casterX, casterY = GetUnitX(caster), GetUnitY(caster)
		local casterOwner      = GetOwningPlayer(caster)
		
		local target ---@type unit
		local targetX, targetY---@type real
		
		local spellId          = GetSpellAbilityId()
		local spellX, spellY   = GetSpellTargetX(), GetSpellTargetY()
		if isEventCast then SpellXY[casterHandleId] = { spellX, spellY } end
		if spellX == 0 and spellY == 0 then spellX, spellY = SpellXY[casterHandleId][1], SpellXY[casterHandleId][2] end
		local spellAngle                   = spellX == 0 and spellY == 0 and math.rad(GetUnitFacing(caster)) or AngleBetweenXY(casterX, casterY, spellX, spellY) ---@type real
		local spellAngleCos, spellAngleSin = math.cos(spellAngle), math.sin(spellAngle) ---@type real
		local spellDistance                = DistanceBetweenXY(casterX, casterY, spellX, spellY)
		
		--{ FIXME DEBUG
		if false then
			print('-----------------------')
			print('channel', isEventChannel)
			print('cast', isEventCast)
			print('effect', isEventEffect)
			print('endcast', isEventEndCast)
			print('finish', isEventFinish)
		end
		--}
		
		--[[Shaking Blow]] if isEventFinish and spellId == ABILITY.ShakingBlow.id then
			ABILITY.ShakingBlow.data.Cast(caster, spellAngle, 128)
		end
		
		if isEventEffect and spellId == FourCC('MFal') then
			-- падение камня босс голем
			--print("mark")
			local eff = AddSpecialEffect("Abilities/Spells/NightElf/TrueshotAura/TrueshotAura.mdl", spellX, spellY)
			
			BlzSetSpecialEffectScale(eff, 2)
			
			TimerStart(CreateTimer(), 2, false, function()
				BlzSetSpecialEffectZ(eff, -100)
				local stone = CreateUnit(GetOwningPlayer(caster), FourCC('n002'), spellX, spellY, GetUnitFacing(caster))
				FallUnit(stone, 40, 500, 1)
				DestroyEffect(eff)-- сразу не уничтожается, поэтому скрываем
				--print("fall")
				DestroyTimer(GetExpiredTimer())
			end)
		end
		
		
		--[[Battle Rush]] if isEventEffect and spellId == ABILITY.BattleRush.id then
			local ability     = ABILITY.BattleRush
			local effect      = AddSpecialEffectTarget('Effect/Ability/BattleRush/Caster.mdx', caster, 'origin')
			local speedInc    = 2000 / (1 / TIMER_PERIOD)
			local damage      = BlzGetUnitBaseDamage(caster, 1)
			local damageGroup = CreateGroup()
			local range       = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 1, 1) > 0 and 150 or 75
			
			local isPush      = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 1, 3) > 0
			local isStun      = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 2, 2) > 0
			local isKill      = GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 3, 2) > 0
			
			TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
				casterX, casterY = casterX + speedInc * spellAngleCos, casterY + speedInc * spellAngleSin
				
				spellDistance    = spellDistance - speedInc
				
				if spellDistance <= 0 or not InMapXY(casterX, casterY) or not UnitAlive(caster) or not IsTerrainWalkable(casterX + 16 * spellAngleCos, casterY + 16 * spellAngleSin) then
					GroupClear(damageGroup)
					DestroyGroup(damageGroup)
					DestroyEffect(effect)
					
					if UnitAlive(caster) and GetPlayerAbilityPerkLevel(casterOwner, ability.codename, 4, 1) > 0 then
						ABILITY.ShakingBlow.data.Cast(caster, spellAngle, 0)
					end
					return DestroyTimer(GetExpiredTimer())
				end
				
				GroupEnumUnitsInRange(GROUP_ENUM_ONCE, casterX, casterY, range, nil)
				while true do
					target = FirstOfGroup(GROUP_ENUM_ONCE)
					if target == nil then break end
					
					if UnitAlive(target) and IsPlayerEnemy(casterOwner, GetOwningPlayer(target)) then
						if isPush then
							targetX, targetY  = GetUnitX(target), GetUnitY(target)
							
							local targetAngle = AngleBetweenXY(casterX, casterY, targetX, targetY)
							if DistanceBetweenXY(casterX, casterY, targetX, targetY) <= 256 and AngleDifference(spellAngle, targetAngle) < math.pi then
								SetUnitX(target, targetX + speedInc * math.cos(targetAngle))
								SetUnitY(target, targetY + speedInc * math.sin(targetAngle))
							end
						end
						
						if not IsUnitInGroup(target, damageGroup) then
							AddSpecialEffectTargetOnce('Abilities/Weapons/VengeanceMissile/VengeanceMissile.mdl', target, 'chest')
							GroupAddUnit(damageGroup, target)
							if isStun then DummyCastStun(target, 3) end
							if isKill and GetWidgetLife(target) / GetUnitState(target, UNIT_STATE_MAX_LIFE) <= 0.1 then
								SetWidgetLife(target, 1)
								SetUnitExploded(target, true)
							end
							UnitDamageTarget(caster, target, damage, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_FIRE, WEAPON_TYPE_WHOKNOWS)
							if isKill then SetUnitExploded(target, false) end
						end
					end
					
					GroupAddUnit(damageGroup, target)
					GroupRemoveUnit(GROUP_ENUM_ONCE, target)
				end
				
				SetUnitX(caster, casterX)
				SetUnitY(caster, casterY)
			end)
		end
		
		-- Clear Data
		if isEventEndCast then
			SpellXY[casterHandleId] = nil
		end
	end)
end