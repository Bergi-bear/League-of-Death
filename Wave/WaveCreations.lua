function AISimpleFounder(group)
	TimerStart(CreateTimer(), 2, true, function()
		ForGroup(group, function()
			local enum = GetEnumUnit()
			if GetUnitCurrentOrder(enum) ~= 851983 then
				GroupEnumUnitsInRect(GROUP_ENUM_ONCE, bj_mapInitialPlayableArea, nil)
				local target---@type unit
				local b = false
				local p = GetOwningPlayer(enum)
				while true do
					target = FirstOfGroup(GROUP_ENUM_ONCE)
					if target == nil then break end
					if IsUnitEnemy(target, p) and IsUnitType(target, UNIT_TYPE_HERO) and b == false then
						--print(GetUnitName(h))
						--PrintSpeed(h)
						IssuePointOrder(enum, "attack", GetUnitX(target), GetUnitY(target))
						b = true
					end
					GroupRemoveUnit(GROUP_ENUM_ONCE, target)
				end
			end
		end)
	end)
end

function StartWave(w, bb)
	local p  = Player(PLAYER_NEUTRAL_AGGRESSIVE)
	local creep---@type unit
	local AC = CreateGroup()--allcreep
	if w == 1 then
		--Кулак с вилами
		local boss  = CreateUnit(p, FourCC('H000'), -100, 3000, 0)
		local bossX = GetUnitX(boss)
		local bossY = GetUnitY(boss)
		GroupAddUnit(AC, boss)
		for i = 1, bb do
			creep = CreateUnit(p, FourCC('hpea'), bossX, bossY, math.random(0, 360))
			IssueImmediateOrder(creep, "stop")
			GroupAddUnit(AC, creep)
		end
		--AISimpleFounder(AC)
	end
end

TimerStart(CreateTimer(), 0, false, function()
	StartWave(1, 10)
end)

-------------------------
---
function MakeUnitFly(target)
	UnitAddAbility(target, FourCC('Aave'))
	UnitRemoveAbility(target, FourCC('Aave'))
end

function FallUnit(target, speed, start, flag)
	MakeUnitFly(target)
	SetUnitZ(target, start)
	local current = start
	TimerStart(CreateTimer(), TIMER_PERIOD, true, function()
		
		if GetUnitFlyHeight(target) <= 50 then
			DestroyTimer(GetExpiredTimer())
			SetUnitFlyHeight(target, 0, 0)
			if flag == 1 then --  оглушаем и наносим урон
			end
		else
			current = current - speed
			SetUnitFlyHeight(target, current, 0)
			--print(current)
		end
	end)
end