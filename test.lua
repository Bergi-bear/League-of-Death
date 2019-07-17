function distance(a, b)
	local c---@type real
	local d---@type real
	if a > b then
		c = a - b
		d = b - a + 2 * bj_PI
	else
		c = b - a
		d = a - b + 2 * bj_PI
	end
	return c > d and d or c
end