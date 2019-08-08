do
	ITEM                                  = {
		ShieldOfHeal  = {
			id       = FourCC('ISoH'),
			cd       = FourCC('ASoH'),
			heal     = 25,
			cooldown = 10
		},
		Basher        = {
			id = FourCC('IBas'),
			cd = FourCC('ABas')
		},
		StaffOfHeal   = {
			id   = FourCC('IStH'),
			heal = 5
		},
		MaskOfDeath   = {
			id   = FourCC('IMoD'),
			heal = 20
		},
		SlippersOfAgi = {
			id  = FourCC('ISoA'),
			agi = 3
		},
		GauntletOfStr = {
			id  = FourCC('IGoS'),
			str = 3
		},
		CloakOfInt    = {
			id  = FourCC('ICoI'),
			int = 3
		},
	}
	
	local GetItemDescriptionOriginalTable = {} ---@type table
	
	---@param item item
	function GetItemDescriptionOriginal(item)
		local id = GetItemTypeId(item)
		if GetItemDescriptionOriginalTable[id] == nil then GetItemDescriptionOriginalTable[id] = BlzGetItemDescription(item) end
		return GetItemDescriptionOriginalTable[id]
	end
	
	local InitGlobalsOrigin = InitGlobals ---@type function
	function InitGlobals()
		InitGlobalsOrigin()
		local dummy = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), FourCC('dumy'), 0, 0, 0)
		UnitAddAbility(dummy, FourCC('cdon'))
		
		---@param item item
		---@param target unit
		---@param duration real
		function StartItemCooldown(item, target, ability, duration)
			BlzItemAddAbility(item, ability)
			SetUnitX(dummy, GetUnitX(target))
			SetUnitY(dummy, GetUnitY(target))
			SetUnitOwner(dummy, Player(PLAYER_NEUTRAL_AGGRESSIVE), false)
			IssueTargetOrderById(dummy, 852252, target) -- creepthunderbolt
			SetUnitOwner(dummy, Player(PLAYER_NEUTRAL_PASSIVE), false)
			BlzSetUnitAbilityCooldown(target, ability, 0, duration)
			TimerStart(CreateTimer(), duration - 0.01, false, function()
				BlzItemRemoveAbility(item, ability)
				DestroyTimer(GetExpiredTimer())
			end)
		end

		function UnitStartAbilityCooldown(unit, abilid, duration)
			local reloadcode=FourCC('ACD1')
			if GetUnitAbilityLevel(unit,abilid)<1 then -- нет способности
				print("способность уже на перезарядке или её нет")
			end
			UnitRemoveAbility(unit, abilid)
			UnitRemoveAbility(unit, reloadcode)
			UnitAddAbility(unit,reloadcode)

			BlzSetUnitAbilityCooldown(unit, reloadcode, 0, duration)

			--выставляем все параметры для подменяемой способности
			BlzSetAbilityIcon(reloadcode,BlzGetAbilityIcon(abilid))--иконку
			BlzSetAbilityPosX(reloadcode,BlzGetAbilityPosX(abilid))--x
			BlzSetAbilityPosY(reloadcode,BlzGetAbilityPosY(abilid))--y

			--DummyCastStun(unit,1)
			SetUnitX(dummy, GetUnitX(unit))
			SetUnitY(dummy, GetUnitY(unit))
			SetUnitOwner(dummy, Player(23), false)
			IssueTargetOrderById(dummy, 852252, unit) -- creepthunderbolt
			SetUnitOwner(dummy, Player(PLAYER_NEUTRAL_PASSIVE), false)

			TimerStart(CreateTimer(), 1, true, function()
				local k=0
				k=k+1
				if k>=duration then
					if GetUnitAbilityLevel(unit,reloadcode)>0 then
						UnitRemoveAbility(unit, reloadcode)
						UnitAddAbility(unit,abilid)
					end
					DestroyTimer(GetExpiredTimer())

				end
			end)
		end
	end
	
	---@param whichUnit unit
	---@param itemId integer
	---@return item, integer
	function GetInventoryItemById(whichUnit, itemId)
		local item---@type item
		for i = 0, bj_MAX_INVENTORY do
			item = UnitItemInSlot(whichUnit, i)
			if item ~= nil and GetItemTypeId(item) == itemId then
				return item, GetItemLevel(item)
			end
		end
		return nil, 0
	end
	
	---@param item item
	---@param description string
	function SetItemDescriptionAll(item, description)
		BlzSetItemDescription(item, description)
		BlzSetItemExtendedTooltip(item, description)
	end
	
	---@param player player
	---@param exclude item
	function ItemBonusUpdate(player, exclude)
		local id   = GetPlayerId(player)
		local hero = PLAYER[id].hero
		if hero == nil then return end
		
		local Str, StrOriginal = 0, GetHeroStr(hero, false)
		local Agi, AgiOriginal = 0, GetHeroAgi(hero, false)
		local Int, IntOriginal = 0, GetHeroInt(hero, false)
		
		for i = 0, bj_MAX_INVENTORY do
			local item = UnitItemInSlot(hero, i)
			local data---@type table
			if item ~= nil and exclude ~= item then
				local level = GetItemLevel(item)
				
				data        = ITEM.GauntletOfStr
				if GetItemTypeId(item) == data.id then
					Str = Str + level * data.str
					if level >= 4 then Str = Str + StrOriginal * (level == 4 and 0.1 or 0.2) end
					SetItemDescriptionAll(item, string.gsuber({ str = Str }, GetItemDescriptionOriginal(item)))
				end
				data = ITEM.SlippersOfAgi
				if GetItemTypeId(item) == data.id then
					Agi = Agi + level * data.agi
					if level >= 4 then Agi = Agi + AgiOriginal * (level == 4 and 0.1 or 0.2) end
					SetItemDescriptionAll(item, string.gsuber({ agi = Agi }, GetItemDescriptionOriginal(item)))
				end
				data = ITEM.CloakOfInt
				if GetItemTypeId(item) == data.id then
					Int = Int + level * data.int
					if level >= 4 then Int = Int + IntOriginal * (level == 4 and 0.1 or 0.2) end
					SetItemDescriptionAll(item, string.gsuber({ int = Int }, GetItemDescriptionOriginal(item)))
				end
			
			end
		end
		
		UnitSetBonus(hero, 1, Str)
		UnitSetBonus(hero, 2, Agi)
		UnitSetBonus(hero, 3, Int)
	end
	
	local ItemNames = {}
	local function ItemName(item)
		local id = GetItemTypeId(item)
		if ItemNames[id] == nil then ItemNames[id] = GetItemName(item) end
		return ItemNames[id]
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
		
		local hero            = GetTriggerUnit()
		
		local player          = GetOwningPlayer(hero)
		
		local item            = GetManipulatedItem()
		local itemId          = GetItemTypeId(item)
		local itemType        = GetItemType(item)
		local itemLevel       = BlzGetItemIntegerField(item, ITEM_IF_LEVEL)
		local itemLevelMax    = BlzGetItemIntegerField(item, ITEM_IF_PRIORITY)
		local itemName        = ItemName(item)
		local itemDescription = GetItemDescriptionOriginal(item)
		
		--{ FIXME DEBUG
		if false then
			print('-----------------------', GetUnitName(hero))
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
					local slot = UnitItemInSlot(hero, i)
					if item ~= slot and itemId == GetItemTypeId(slot) then
						RemoveItem(item)
						itemLevel = itemLevel + BlzGetItemIntegerField(slot, ITEM_IF_LEVEL)
						item      = slot
						if itemLevel > itemLevelMax then
							local cost = BlzGetItemIntegerField(item, ITEM_IF_MAX_HIT_POINTS) * (itemLevel - itemLevelMax)
							itemLevel  = itemLevelMax
							SetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD) + cost)
							AddSpecialEffectTargetOnce('UI/Feedback/GoldCredit/GoldCredit.mdl', hero, 'origin')
							FlyTextTagGoldBounty(hero, '+' .. cost, player)
						end
					end
				end
				
				if itemId == ITEM.ShieldOfHeal.id then
					itemDescription = string.gsuber({ heal = ITEM.ShieldOfHeal.heal * itemLevel, cooldown = ITEM.ShieldOfHeal.cooldown - itemLevel }, itemDescription)
				elseif itemId == ITEM.StaffOfHeal.id then
					itemDescription = string.gsuber({ heal = ITEM.StaffOfHeal.heal * itemLevel }, itemDescription)
				elseif itemId == ITEM.MaskOfDeath.id then
					if itemLevel <= 3 then
						itemDescription = string.gsuber({ heal = ITEM.MaskOfDeath.heal * itemLevel .. " ед." }, itemDescription)
					else
						itemDescription = string.gsuber({ heal = "60 + 15%%%% от нанесённого урона" }, itemDescription)
					end
				end
				
				BlzSetItemIntegerField(item, ITEM_IF_LEVEL, itemLevel)
				BlzSetItemName(item, string.gsuber({ level = itemLevel, levelMax = itemLevelMax }, itemName))
				SetItemDescriptionAll(item, itemDescription)
			elseif itemType == ITEM_TYPE_ARTIFACT then
				for i = 0, bj_MAX_INVENTORY do
					local slot = UnitItemInSlot(hero, i)
					if item ~= slot and itemId == GetItemTypeId(slot) then
						local cost = BlzGetItemIntegerField(item, ITEM_IF_MAX_HIT_POINTS)
						RemoveItem(item)
						SetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(player, PLAYER_STATE_RESOURCE_GOLD) + cost)
						AddSpecialEffectTargetOnce('UI/Feedback/GoldCredit/GoldCredit.mdl', hero, 'origin')
						FlyTextTagGoldBounty(hero, '+' .. cost, player)
					end
				end
			end
			
			ItemBonusUpdate(player)
		end
		
		if isEventDrop then
			ItemBonusUpdate(player, item)
		end
	end)
end