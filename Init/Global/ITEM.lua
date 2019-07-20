ITEM = {
	ShieldOfHeal = {
		id       = FourCC('ISoH'),
		cd       = FourCC('ASoH'),
		heal     = 25,
		cooldown = 10
	},
	Basher       = {
		id = FourCC('IBas'),
		cd = FourCC('ABas')
	},
	StaffOfHeal  = {
		id   = FourCC('IStH'),
		heal = 5
	}
}

do
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
			TimerStart(CreateTimer(), duration, false, function()
				BlzItemRemoveAbility(item, ability)
				DestroyTimer(GetExpiredTimer())
			end)
		end
	end
end

---@param whichUnit unit
---@param itemId integer
---@return integer
function GetInventoryItemById(whichUnit, itemId)
	local item
	for i = 0, bj_MAX_INVENTORY do
		item = UnitItemInSlot(whichUnit, i)
		if item ~= nil and GetItemTypeId(item) == itemId then
			return item
		end
	end
end