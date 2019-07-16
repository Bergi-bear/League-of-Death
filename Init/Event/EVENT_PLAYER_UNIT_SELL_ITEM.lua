local ITEM_SELL_TRIGGER = CreateTrigger()
for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
	TriggerRegisterPlayerUnitEvent(ITEM_SELL_TRIGGER, Player(i), EVENT_PLAYER_UNIT_SELL_ITEM)
end
TriggerAddAction(ITEM_SELL_TRIGGER, function()
	local u  = GetBuyingUnit()
	local it = GetSoldItem()
	SetItemUserData(it, 1)
end)