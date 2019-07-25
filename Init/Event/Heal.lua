function Heal(caster, target, heal, show)
	TimerStart(CreateTimer(), 0.00, false, function()
		local lose = GetWidgetLife(target) - GetUnitState(target, UNIT_STATE_LIFE)
		local k    = 1
		
		local item = GetInventoryItemById(caster, ITEM.StaffOfHeal.id)
		if item ~= nil then
			k = k + (ITEM.StaffOfHeal.heal * GetItemLevel(item) / 100)
		end
		
		item = GetInventoryItemById(target, ITEM.StaffOfHeal.id)
		if item ~= nil then
			k = k + (ITEM.StaffOfHeal.heal * GetItemLevel(item) / 100)
		end
		
		heal       = heal * k
		local over = heal > lose and heal > lose or 0 ---@type real
		
		SetWidgetLife(target, GetWidgetLife(target) + heal)
		if show == nil or show == true then
			local textSize = 0.01 + heal / 10000
			FlyTextTag('+' .. math.ceil(heal), textSize, GetUnitX(target) - 32, GetUnitY(target), 0, 30, 230, 29, 255, 0, 0.03, 1.5, 2, nil)
		end
	end)
end
