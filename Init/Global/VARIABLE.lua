---@author http://lua-users.org/wiki/CopyTable
---@param org table
---@return table
function table.clone(org)
	return { table.unpack(org) }
end

---@param data table
---@param str string
---@return string
function string.gsuber(data, str)
	for k, v in pairs(data) do
		str = string.gsub(str, '<' .. k .. '>', v)
	end
	return str
end

math.randomseed(os.time())

GROUP_ENUM_ONCE       = CreateGroup() -- Группа для одноразового перебора юнитов
TIMER_PERIOD          = 0.03125 -- Период таймера для движения: 1/32 секунды
BTLF_ID               = FourCC('BTLF')