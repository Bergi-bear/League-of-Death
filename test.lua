do
	-- Настройки
	local ABILITY_ID             = AbilityId('SFiB')
	local MISSILE_EFFECT         = { 'Abilities\\Weapons\\WaterElementalMissile\\WaterElementalMissile.mdl', 2 } --> model, scal
	local MISSILE_HEIGHT         = 100
	local MISSILE_START_DISTANCE = 100
	
	local TIMER_PERIOD           = 0.03125 --> 1/32
	local SPEED                  = 600
	local DISTANCE               = { 1200, 1800, 2400 }
	
	local DAMAGE_UNIT            = { 50, 75, 100 }
	local DAMAGE_UNIT_RANGE      = 64
	local DAMAGE_UNIT_PERIOD     = 0.09
	local DAMAGE_UNIT_EFFECT     = { 'Abilities\\Spells\\Other\\CrushingWave\\CrushingWaveDamage.mdl', 'origin' }
	local DAMAGE_EXPLODE         = { 100, 200, 300 }
	local DAMAGE_EXPLODE_RANGE   = 254
	local DAMAGE_EXPLODE_EFFECT  = 'Objects\\Spawnmodels\\Naga\\NagaDeath\\NagaDeath.mdl'
	
	-- Заклинание
	local SPEED_INC              = SPEED / (1 / TIMER_PERIOD)
	
	local function InMapXY(x, y)
		return
		x > GetRectMinX(bj_mapInitialPlayableArea)
				and
				x < GetRectMaxX(bj_mapInitialPlayableArea)
				and
				y > GetRectMinY(bj_mapInitialPlayableArea)
				and
				y < GetRectMaxY(bj_mapInitialPlayableArea)
	end
	
	local GetTerrainZ_location = Location(0, 0)
	local function GetTerrainZ(x, y)
		MoveLocation(GetTerrainZ_location, x, y);
		return GetLocationZ(GetTerrainZ_location);
	end
	
	local TRIGGER = CreateTrigger()
	for i = 0, bj_MAX_PLAYER_SLOTS - 1, 1
	do
		TriggerRegisterPlayerUnitEvent(TRIGGER, Player(i), EVENT_PLAYER_UNIT_SPELL_EFFECT)
	end
	TriggerAddCondition(t, Condition(function()
		return GetSpellAbilityId() == ABILITY_ID
	end))
	TriggerAddAction(TRIGGER, function()
		local caster   = GetTriggerUnit()
		local x        = GetUnitX(caster)
		local y        = GetUnitY(caster)
		
		local angle    = Atan2(GetSpellTargetY() - y, GetSpellTargetX() - x)
		local cos      = Cos(angle)
		local sin      = Sin(angle)
		
		x              = x + MISSILE_START_DISTANCE * cos
		y              = y + MISSILE_START_DISTANCE * sin
		local z        = GetTerrainZ(x, y) + MISSILE_HEIGHT
		local zx
		local zy
		
		local level    = GetUnitAbilityLevel(caster, ABILITY_ID)
		local distance = DISTANCE[level]
		
		local missile  = AddSpecialEffect(MISSILE_EFFECT[1], x, y)
		BlzSetSpecialEffectYaw(missile, angle)
		BlzSetSpecialEffectHeight(missile, MISSILE_HEIGHT)
		BlzSetSpecialEffectScale(missile, MISSILE_EFFECT[2])
		
		local damaged  = CreateGroup()
		local damaging = CreateGroup()
		
		local time     = 0
		
		TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
			zx = GetTerrainZ(x + 2 * SPEED_INC * Cos(angle), y + 1 * SPEED_INC * Sin(angle)) - z + MISSILE_HEIGHT
			zy = GetTerrainZ(x + 1 * SPEED_INC * Cos(angle), y + 2 * SPEED_INC * Sin(angle)) - z + MISSILE_HEIGHT
			
			if zx > z then angle = math.pi - angle end
			if zy > z then angle = 0 - angle end
			if zx > z or zy > z then
				cos = Cos(angle)
				sin = Sin(angle)
				BlzSetSpecialEffectYaw(missile, angle)
			end
			
			time     = time + TIMER_PERIOD
			
			x        = x + SPEED_INC * cos
			y        = y + SPEED_INC * sin
			distance = distance - SPEED_INC
			
			if
			not InMapXY(x, y)
					or
					distance <= 0
			then
				
				DestroyEffect(AddSpecialEffect(DAMAGE_EXPLODE_EFFECT, x, y))
				GroupEnumUnitsInRange(damaging, x, y, DAMAGE_EXPLODE_RANGE, Filter(function()
					return
					UnitAlive(GetFilterUnit())
							and
							IsPlayerEnemy(GetOwningPlayer(caster), GetOwningPlayer(GetFilterUnit()))
							and
							not IsUnitType(GetFilterUnit(), UNIT_TYPE_MAGIC_IMMUNE)
							and
							not IsUnitType(GetFilterUnit(), UNIT_TYPE_FLYING)
				end))
				
				ForGroup(damaging, function()
					GroupAddUnit(damaged, GetEnumUnit())
					DestroyEffect(AddSpecialEffectTarget(DAMAGE_UNIT_EFFECT[1], GetEnumUnit(), DAMAGE_UNIT_EFFECT[2]))
					UnitDamageTarget(caster, GetEnumUnit(), DAMAGE_UNIT[level], false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
				end)
				
				DestroyGroup(damaged)
				DestroyGroup(damaging)
				DestroyEffect(missile)
				DestroyTimer(GetExpiredTimer())
				return
			end
			
			BlzSetSpecialEffectX(missile, x)
			BlzSetSpecialEffectY(missile, y)
			BlzSetSpecialEffectHeight(missile, z - GetTerrainZ(x, y))
			
			if
			time > DAMAGE_UNIT_PERIOD
			then
				time = 0
				GroupEnumUnitsInRange(damaging, x, y, DAMAGE_UNIT_RANGE, Filter(function()
					return UnitAlive(GetFilterUnit())
							and
							IsPlayerEnemy(GetOwningPlayer(caster), GetOwningPlayer(GetFilterUnit()))
							and
							not IsUnitType(GetFilterUnit(), UNIT_TYPE_MAGIC_IMMUNE)
							and
							not IsUnitType(GetFilterUnit(), UNIT_TYPE_FLYING)
							and
							not IsUnitInGroup(GetFilterUnit(), damaged)
				end))
				
				ForGroup(damaging, function()
					GroupAddUnit(damaged, GetEnumUnit())
					DestroyEffect(AddSpecialEffectTarget(DAMAGE_UNIT_EFFECT[1], GetEnumUnit(), DAMAGE_UNIT_EFFECT[2]))
					UnitDamageTarget(caster, GetEnumUnit(), DAMAGE_UNIT[level], false, true, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
				end)
				
				GroupClear(damaging)
			end
		
		end)
	
	end)

end