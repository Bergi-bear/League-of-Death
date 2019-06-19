PLAYER = {} ---@type table

for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
	PLAYER[i] = {
		hero            = nil,
		heroSelectBgModel = '',
		race            = math.random(1, #RACE - 1),
		attr            = math.random(1, 3)
	}
end