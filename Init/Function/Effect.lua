---@param modelName string
---@param xe real
---@param ye real
---@param x real
---@param y real
---@param z real
function AddSpecialEffectMatrixScale(modelName, xe, ye, x, y, z)
	local effect = AddSpecialEffect(modelName, xe, ye)
	BlzSetSpecialEffectMatrixScale(effect, x, y, z)
	DestroyEffect(effect)
end

---@param modelName string
---@param x real
---@param y real
function AddSpecialEffectXY(modelName, x, y)
	DestroyEffect(AddSpecialEffect(modelName, x, y))
end