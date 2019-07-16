local ITEM_PICKUP_TRIGGER = CreateTrigger()
for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
	TriggerRegisterPlayerUnitEvent(ITEM_PICKUP_TRIGGER, Player(i), EVENT_PLAYER_UNIT_PICKUP_ITEM)
end

TriggerAddAction(ITEM_PICKUP_TRIGGER, function()
	local u        = GetTriggerUnit()
	local item     = GetManipulatedItem()
	local oldit    = GetItemOfTypeFromUnitBJ(u, GetItemTypeId(item))
	local level    = GetItemUserData(oldit)
	
	local parsname = GetItemName(item)
	local parsdesc = BlzGetItemDescription(item)
	
	if GetItemType(item) == ITEM_TYPE_POWERUP then
		if GetHandleId(item) ~= GetHandleId(oldit) then
			level = GetItemUserData(item) + GetItemUserData(oldit)
			if level <= 4 then
				SetItemUserData(oldit, level)
				RemoveItem(item)
				--    print(level.." повышение уровня")
			else
				level = 4
				SetItemUserData(oldit, level)
				RemoveItem(item)
				print("возврат денег, невозможно иметь 2 предмета")
			end
		end
		
		local tempname = string.gsub(parsname, "lvl", level)
		local tempdesc
		--- перечисляем типы предметов
		if GetItemTypeId(oldit) == FourCC('I003') then
			-- посох лекаря
			tempdesc = string.gsub(parsdesc, "perc", 5 * level)
		elseif GetItemTypeId(oldit) == FourCC('I002') then
			-- щит целителя
			if level <= 3 then
				tempdesc = string.gsub(parsdesc, "<heal>", 50 * level)
				tempdesc = string.gsub(tempdesc, "<cd>", "5")
			else
				tempdesc = string.gsub(parsdesc, "<heal>", "150")
				tempdesc = string.gsub(tempdesc, "<cd>", "2,5")
			end
		end
		
		--- итоговая запись
		BlzSetItemName(oldit, tempname)
		if tempdesc ~= nil then
			BlzSetItemExtendedTooltip(oldit, tempdesc)
		end
	end
end)