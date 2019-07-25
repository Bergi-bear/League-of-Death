do
	local ChatTrigger = CreateTrigger()
	for i = 0, bj_MAX_PLAYER_SLOTS - 1 do
		TriggerRegisterPlayerChatEvent(ChatTrigger, Player(i), '-', false)
	end
	TriggerAddAction(ChatTrigger, function()
		local player = GetTriggerPlayer()
		local id     = GetPlayerId(player)
		local chat   = GetEventPlayerChatString()
		
		if PLAYER[id] ~= nil then
			local hero = PLAYER[id].hero
			local str---@type string
			local count---@type number
			
			-- level
			str, count = string.gsub(chat, '-lvl', '')
			if count > 0 then
				if tonumber(str) == nil then
					print(chat, GetHeroLevel(hero))
				else
					SetHeroLevel(hero, GetHeroLevel(hero) + tonumber(str), true)
				end
			end
			
			-- strenght bonus
			str, count = string.gsub(chat, '-str', '')
			if count > 0 then
				if tonumber(str) == nil then
					print(chat, UnitGetBonus(hero, 1))
				else
					UnitSetBonus(hero, 1, tonumber(str))
				end
			end
			
			-- agility bonus
			str, count = string.gsub(chat, '-agi', '')
			if count > 0 then
				if tonumber(str) == nil then
					print(chat, UnitGetBonus(hero, 2))
				else
					UnitSetBonus(hero, 2, tonumber(str))
				end
			end
			
			-- intilligence bonus
			str, count = string.gsub(chat, '-int', '')
			if count > 0 then
				if tonumber(str) == nil then
					print(chat, UnitGetBonus(hero, 3))
				else
					UnitSetBonus(hero, 3, tonumber(str))
				end
			end
			
			-- damage bonus
			str, count = string.gsub(chat, '-dmg', '')
			if count > 0 then
				if tonumber(str) == nil then
					print(chat, UnitGetBonus(hero, 4))
				else
					UnitSetBonus(hero, 4, tonumber(str))
				end
			end
			
			-- armor bonus
			str, count = string.gsub(chat, '-arm', '')
			if count > 0 then
				if tonumber(str) == nil then
					print(chat, UnitGetBonus(hero, 5))
				else
					UnitSetBonus(hero, 5, tonumber(str))
				end
			end
			
			-- hp regen bonus
			str, count = string.gsub(chat, '-hp', '')
			if count > 0 then
				if tonumber(str) == nil then
					print(chat, UnitGetBonus(hero, 6))
				else
					UnitSetBonus(hero, 6, tonumber(str))
				end
			end
			
			-- mp regen bonus
			str, count = string.gsub(chat, '-mp', '')
			if count > 0 then
				if tonumber(str) == nil then
					print(chat, UnitGetBonus(hero, 7))
				else
					UnitSetBonus(hero, 7, tonumber(str))
				end
			end
		
		end
	end)
end

TimerStart(CreateTimer(), 1, false, function()
	print(
			'|cffffcc00Комманды чата:|r\n' ..
					'-lvl |cff00ff00X|r |cff808080уровень героя|r\n' ..
					'-str|agi|int |cff00ff00X|r |cff808080бонус аттрибутов героя|r\n' ..
					'-hp|mp |cff00ff00X|r |cff808080бонус регенерации героя|r\n' ..
					'\n\n\n\n\n'
	)
end)
