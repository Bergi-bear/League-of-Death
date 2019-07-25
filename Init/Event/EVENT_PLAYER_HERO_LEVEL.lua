do
	local HeroLevelTrigger = CreateTrigger()
	for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
		TriggerRegisterPlayerUnitEvent(HeroLevelTrigger, Player(i), EVENT_PLAYER_HERO_LEVEL, nil)
	end
	TriggerAddAction(HeroLevelTrigger, function()
		local hero   = GetTriggerUnit()
		local player = GetOwningPlayer(hero)
		local id     = GetPlayerId(player)
		local level  = GetHeroLevel(hero)
		
		if hero == PLAYER[id].hero then
			PLAYER[id].perkPoint = PLAYER[id].perkPoint + 1
			HeroPerkUpdate(player)
			ItemBonusUpdate(player)
		end
	end)
end