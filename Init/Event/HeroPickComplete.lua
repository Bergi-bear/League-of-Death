---@param player player
function HeroPickComplete(player)
	local id   = GetPlayerId(player)
	local race = PLAYER[id].race
	local attr = PLAYER[id].attr
	local hero = PLAYER[id].hero
	
	if race == 1 and attr == 1 then
		AddItemToStock(hero, ABILITY.Swipe.iditempass, 0, 0)
	end
end