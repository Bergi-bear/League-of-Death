function Heal(caster, target, heal, show)
	TimerStart(CreateTimer(), 0.00, false, function()
		local lose = GetWidgetLife(target) - GetUnitState(target, UNIT_STATE_LIFE)
		local over = heal > lose and heal > lose or 0 ---@type real
		
		local item = GetInventoryItemById(caster, ITEM.StaffOfHeal.id)
		if item ~= nil then
			heal = heal + heal * (ITEM.StaffOfHeal.heal * GetItemLevel(item) / 100)
		end
		
		SetWidgetLife(target, GetWidgetLife(target) + heal)
		if show == nil or show == true then
			FlyTextTag('+' .. math.ceil(heal), 0.018, GetUnitX(target), GetUnitY(target), 0, 30, 230, 29, 255, 0, 0.03, 1.5, 2, nil)
		end
	end)
end
