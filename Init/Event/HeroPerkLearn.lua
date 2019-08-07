--@param player player
---@param codename string
---@param row integer
---@param col integer
function HeroPerkLearn(player, codename, row, col)
	local id                            = GetPlayerId(player)
	local hero                          = PLAYER[id].hero
	PLAYER[id].perk[codename][row][col] = 1
	
	if codename == ABILITY.Horde.codename then
		if row == 1 then
			if col == 1 then
				BlzSetUnitMaxHP(hero, GetUnitState(hero, UNIT_STATE_MAX_LIFE) + 800)
			end
		end
	elseif codename == ABILITY.BattleRush.codename then
		if row == 1 then
			if col == 2 then
				BlzSetAbilityRealLevelField(BlzGetUnitAbility(hero, ABILITY.BattleRush.id), ABILITY_RLF_CAST_RANGE, 0, 5000)
			end
		end
	elseif codename == ABILITY.ShakingBlow.codename then
		if row == 3 then
			if col == 2 then
				SetUnitAbilityLevel(hero, ABILITY.ShakingBlow.id, 2)
			end
		end
	end
	
	SetWidgetLife(hero, GetUnitState(hero, UNIT_STATE_MAX_LIFE))
	SetUnitState(hero, UNIT_STATE_MANA, GetUnitState(hero, UNIT_STATE_MAX_MANA))
	DestroyEffect(AddSpecialEffectTarget('Abilities\\Spells\\Human\\HolyBolt\\HolyBoltSpecialArt.mdl', hero, 'origin'))
end