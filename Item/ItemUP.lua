local ITEM_SELL_TRIGGER = CreateTrigger()
for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
	TriggerRegisterPlayerUnitEvent(ITEM_SELL_TRIGGER, Player(i), EVENT_PLAYER_UNIT_SELL_ITEM)
end
TriggerAddAction(ITEM_SELL_TRIGGER, function()
	local u  = GetBuyingUnit()
	local it = GetSoldItem()
	SetItemUserData(it, 1)

end)

local ITEM_PICKUP_TRIGGER = CreateTrigger()
for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
	TriggerRegisterPlayerUnitEvent(ITEM_PICKUP_TRIGGER, Player(i), EVENT_PLAYER_UNIT_PICKUP_ITEM)
	TriggerAddCondition(ITEM_PICKUP_TRIGGER, Condition(function() return GetItemType(GetManipulatedItem()) ~= ITEM_TYPE_POWERUP end))
end
TriggerAddAction(ITEM_PICKUP_TRIGGER, function()
	local u        = GetTriggerUnit()
	local it       = GetManipulatedItem()
	local oldit    = GetItemOfTypeFromUnitBJ(u, GetItemTypeId(it))
	local level    = GetItemUserData(oldit)
	
	local parsname = GetItemName(it)
	local parsdesc = BlzGetItemDescription(it)
	
	if GetHandleId(it) ~= GetHandleId(oldit) then
		level = GetItemUserData(it) + GetItemUserData(oldit)
		if level <= 4 then
			SetItemUserData(oldit, level)
			RemoveItem(it)
			--    print(level.." повышение уровня")
		else
			level = 4
			SetItemUserData(oldit, level)
			RemoveItem(it)
			print("возврат денег, невозможно иметь 2 предмета")
		
		end
	end
	
	local tempname = string.gsub(parsname, "lvl", level)
	local tempdesc = nil
	--- перечисляем типы предметов
	if GetItemTypeId(oldit) == FourCC('I003') then
		-- посох лекаря
		tempdesc = string.gsub(parsdesc, "perc", 5 * level)
		print("tempdesc=" .. tempdesc)
	end
	--print("tempname="..tempname)
	
	--- итоговая запись
	BlzSetItemName(oldit, tempname)
	if tempdesc ~= nil then
		--BlzSetItemDescription(oldit, tempdesc)
		BlzSetItemExtendedTooltip(oldit, tempdesc)
		print("смена описания")
	end

end)

function DubleItem(u, it)
	local b = false
	local k = 0
	local tempid
	for i = 0, 6, 1 do
		--    print("i="..i)
		tempid = GetItemTypeId(UnitItemInSlot(u, i))
		if tempid == GetItemTypeId(it) then
			k = k + 1
			--       print("k="..k)
		end
	end
	if k >= 2 then
		b = true
	end
	return b
end