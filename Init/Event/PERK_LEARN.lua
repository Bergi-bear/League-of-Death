---@param player player
---@param codename string
---@param row integer
---@param col integer
function HeroPerkLearn(player, codename, row, col)
	local id   = GetPlayerId(player)
	local hero = PLAYER[id].hero
	
	if codename == ABILITY.Horde.codename then
		if row == 1 then
			if col == 1 then
				BlzSetUnitMaxHP(hero, GetUnitState(hero, UNIT_STATE_MAX_LIFE) + 1000)
			end
		end
	end
	
	SetWidgetLife(hero, GetUnitState(hero, UNIT_STATE_MAX_LIFE))
	DestroyEffect(AddSpecialEffectTarget('Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl', hero, 'origin'))
end