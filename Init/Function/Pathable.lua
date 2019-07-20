do
	local rect---@type rect
	local item ---@type item
	
	local InitGlobals_hook = InitGlobals ---@type function
	function InitGlobals()
		InitGlobals_hook()
		rect = Rect(0., 0., 128., 128.)
		item = CreateItem(FourCC('wolg'), 0, 0)
		SetItemVisible(item, false)
	end
	
	local items = {} ---@type table
	local function hide()
		local target = GetEnumItem()
		if not IsItemVisible(target) then return end
		table.insert(items, target)
		SetItemVisible(target, false)
	end
	
	---@param x real
	---@param y real
	---@return boolean
	function IsTerrainWalkable(x, y)
		MoveRectTo(rect, x, y)
		EnumItemsInRect(rect, nil, hide)
		
		SetItemPosition(item, x, y)
		local dx = GetItemX(item) - x
		local dy = GetItemY(item) - y
		SetItemVisible(item, false)
		
		for i = 1, #items do
			SetItemVisible(items[i], true)
		end
		items = {}
		
		return dx * dx + dy * dy <= 100 and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
	end
end

---@param x real
---@param y real
---@return boolean
function IsTerrainDeepWater (x, y)
	return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
end

---@param x real
---@param y real
---@return boolean
function IsTerrainShallowWater (x, y)
	return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) and IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
end

---@param x real
---@param y real
---@return boolean
function IsTerrainLand(x, y)
	return IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
end

---@param x real
---@param y real
---@return boolean
function IsTerrainPlatform (x, y)
	return not IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) and not IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY)
end