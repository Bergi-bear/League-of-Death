function ehandler(err)
	print("ERROR:", err)
end

function FlyTextColor(s, u, red, green, blue, p)
	--takes string s,unit u, real red, real green, real blue, unit p returns nothing //FlyTextColor("",u,255,255,255,u)
	--xpcall(function()
	local ra = GetRandomReal(45, 135)
	-- print(1)
	if GetLocalPlayer() == GetOwningPlayer(p) and IsUnitDeadBJ(p) == false then
		--  print(2)
		CreateTextTagUnitBJ(s, u, 0, 11, red / 2.55, green / 2.55, blue / 2.55, 0)
		
		--  print(2,1)
		SetTextTagPermanent(bj_lastCreatedTextTag, false)
		--  print(2,2)
		SetTextTagLifespan(bj_lastCreatedTextTag, 2.00)
		--  print(2,2)
		SetTextTagVelocityBJ(bj_lastCreatedTextTag, 64, ra)
		--  print(2,4)
		SetTextTagFadepoint(bj_lastCreatedTextTag, 1.5)
		-- print(3)
	end
	--   print(4)
	--end, ehandler)
end

HealCount = {}
function Heal(u, targ, life, show)
	TimerStart(CreateTimer(), 0.00, false, function()
		local ch       = life--currentheal
		local losehp   = GetUnitState(targ, UNIT_STATE_MAX_LIFE) - GetUnitState(targ, UNIT_STATE_LIFE)
		local overheal = 0
		local k        = 1
		local it
		local lvl
		--- изменяем входящее лечение
		if UnitHasItemOfTypeBJ(u, FourCC('I003')) then
			it  = GetItemOfTypeFromUnitBJ(u, FourCC('I003'))
			lvl = GetItemUserData(it)
			k   = k + (0.05 * lvl)
		end
		
		if UnitHasItemOfTypeBJ(targ, FourCC('I003')) then
			it  = GetItemOfTypeFromUnitBJ(targ, FourCC('I003'))
			lvl = GetItemUserData(it)
			k   = k + (0.05 * lvl)
		end
		
		---
		ch = ch * k
		--- высчитываем реально лечение и сверх лечение
		if losehp <= ch then
			overheal = ch - losehp
			ch       = losehp
			--print("over="..overheal)
		else
		
		end
		--сам процесс лечения
		SetUnitState(targ, UNIT_STATE_LIFE, GetUnitState(targ, UNIT_STATE_LIFE) + ch)
		--сам процесс лечения
		if show == nil or show == true then
			FlyTextColor("+" .. math.ceil(ch), u, 30, 230, 29, u)
		end
		HealCount[GetPlayerId(GetOwningPlayer(u))] = ch
	end)
	--print(5)
end