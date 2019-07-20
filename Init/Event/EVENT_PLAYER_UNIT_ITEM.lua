do
	local ItemNames = {}
	local function ItemName(item)
		local id = GetItemTypeId(item)
		if ItemNames[id] == nil then ItemNames[id] = GetItemName(item) end
		return ItemNames[id]
	end
	
	local ItemDescriptions = {}
	local function ItemDescription(item)
		local id = GetItemTypeId(item)
		if ItemDescriptions[id] == nil then ItemDescriptions[id] = BlzGetItemDescription(item) end
		return ItemDescriptions[id]
	end
	
	local ItemTrigger = CreateTrigger()
	for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
		local player = Player(i)
		TriggerRegisterPlayerUnitEvent(ItemTrigger, player, EVENT_PLAYER_UNIT_PICKUP_ITEM)
		TriggerRegisterPlayerUnitEvent(ItemTrigger, player, EVENT_PLAYER_UNIT_DROP_ITEM)
		TriggerRegisterPlayerUnitEvent(ItemTrigger, player, EVENT_PLAYER_UNIT_SELL_ITEM)
		TriggerRegisterPlayerUnitEvent(ItemTrigger, player, EVENT_PLAYER_UNIT_USE_ITEM)
		TriggerRegisterPlayerUnitEvent(ItemTrigger, player, EVENT_PLAYER_UNIT_PAWN_ITEM)
	end
	
	TriggerAddAction(ItemTrigger, function()
		local eventId         = GetHandleId(GetTriggerEventId())
		local isEventPickUp   = eventId == GetHandleId(EVENT_PLAYER_UNIT_PICKUP_ITEM)
		local isEventDrop     = eventId == GetHandleId(EVENT_PLAYER_UNIT_DROP_ITEM)
		local isEventSell     = eventId == GetHandleId(EVENT_PLAYER_UNIT_SELL_ITEM)
		local isEventUse      = eventId == GetHandleId(EVENT_PLAYER_UNIT_USE_ITEM)
		local isEventPawn     = eventId == GetHandleId(EVENT_PLAYER_UNIT_PAWN_ITEM)
		
		local caster          = GetTriggerUnit()
		
		local player          = GetOwningPlayer(caster)
		
		local item            = GetManipulatedItem()
		local itemId          = GetItemTypeId(item)
		local itemType        = GetItemType(item)
		local itemLevel       = BlzGetItemIntegerField(item, ITEM_IF_LEVEL)
		local itemLevelMax    = BlzGetItemIntegerField(item, ITEM_IF_PRIORITY)
		local itemName        = ItemName(item)
		local itemDescription = ItemDescription(item)
		
		
		--{ DEBUG
		if false then
			print('-----------------------', GetUnitName(caster))
			print('pickup', isEventPickUp)
			print('drop', isEventDrop)
			print('sell', isEventSell)
			print('use', isEventUse)
			print('pawn', isEventPawn)
		end
		--}
		
		if isEventPickUp then
			if itemType == ITEM_TYPE_CAMPAIGN then
				for i = 0, bj_MAX_INVENTORY do
					local slot = UnitItemInSlot(caster, i)
					if item ~= slot and itemId == GetItemTypeId(slot) then
						RemoveItem(item)
						itemLevel = itemLevel + BlzGetItemIntegerField(slot, ITEM_IF_LEVEL)
						item      = slot
						if itemLevel > itemLevelMax then
							local cost = BlzGetItemIntegerField(item, ITEM_IF_MAX_HIT_POINTS) * (itemLevel - itemLevelMax)
							itemLevel  = itemLevelMax
							SetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD) + cost)
							AddSpecialEffectTargetOnce('UI/Feedback/GoldCredit/GoldCredit.mdl', caster, 'origin')
							FlyTextTagGoldBounty(caster, '+' .. cost, player)
						end
					end
				end
				
				if itemId == ITEM.ShieldOfHeal.id then
					itemDescription = string.gsuber({ heal = ITEM.ShieldOfHeal.heal * itemLevel, cooldown = ITEM.ShieldOfHeal.cooldown - itemLevel }, itemDescription)
				elseif itemId == ITEM.StaffOfHeal.id then
					itemDescription = string.gsuber({ heal = ITEM.StaffOfHeal.heal * itemLevel }, itemDescription)
				end
				
				BlzSetItemIntegerField(item, ITEM_IF_LEVEL, itemLevel)
				BlzSetItemName(item, string.gsuber({ level = itemLevel, levelMax = itemLevelMax }, itemName))
				BlzSetItemDescription(item, itemDescription)
				BlzSetItemExtendedTooltip(item, itemDescription)
			elseif itemType == ITEM_TYPE_ARTIFACT then
				for i = 0, bj_MAX_INVENTORY do
					local slot = UnitItemInSlot(caster, i)
					if item ~= slot and itemId == GetItemTypeId(slot) then
						local cost = BlzGetItemIntegerField(item, ITEM_IF_MAX_HIT_POINTS)
						RemoveItem(item)
						SetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD) + cost)
						AddSpecialEffectTargetOnce('UI/Feedback/GoldCredit/GoldCredit.mdl', caster, 'origin')
						FlyTextTagGoldBounty(caster, '+' .. cost, player)
					end
				end
			end
		end
	end)
end