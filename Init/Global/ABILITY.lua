ABILITY = {
	Horde       = {
		name        = 'Сила орка',
		id          = FourCC('0000'),
		description = 'Повышает характеристики орка',
		perk        = {
			[1] = {
				[1] = {
					name        = 'Стойкость Орды',
					description = 'Увеличивает количество HP'
				},
				[2] = {
					hide        = true,
					name        = 'Регенерация Орды',
					description = 'Увеличивает эффективность регенерации HP/MP'
				},
				[3] = {
					hide        = true,
					name        = 'Закалка Орды',
					description = 'Получает слабую магическую сопротивляемость'
				}
			},
			[2] = {
				[1] = {
					hide        = true,
					name        = 'Опыт Орды',
					description = 'Каждый 100-й убитый добавляет единицу основного аттрибута'
				},
				[2] = {
					hide        = true,
					name        = 'Сила Орды',
					description = 'Каждый 10-ый удар игнорирует броню'
				},
				[3] = {
					hide        = true,
					name        = 'Крепкость орды',
					description = 'Блокирует каждый 50-ый полученный удар'
				}
			},
			[3] = {
				[1] = {
					hide        = true,
					name        = 'Ярость Орды',
					description = 'Увеличивает урон от недостающего HP'
				},
				[2] = {
					hide        = true,
					name        = 'Кровожадность Орды',
					description = 'Каждый 20-ый убитый добавляет доп. очки раунда'
				},
				[3] = {
					hide        = true,
					name        = 'Живучесть Орды',
					description = 'Не умирает от смертельного урона, имеет перезарядку'
				}
			},
			[4] = {
				[1] = {
					hide        = true,
					name        = 'Легендарная Особенность Орды',
					description = 'Увеличивает все бонусы от Особенности Орды вдвое. Требует: Не менее трёх Особенностей Орды'
				}
			}
		}
	},
	ShakingBlow = {
		name        = 'Shaking Blow',
		id          = FourCC('ASBl'),
		description = 'Shakes the ground causing damage to enemies around',
		perk        = {
			[1] = {
				[1] = {
					name        = 'Berserk Strenght',
					description = 'Increases area of damage'
				},
				[2] = {
					name        = 'Destroyer Strenght',
					description = 'Increases damage by your strenght'
				},
				[3] = {
					name        = 'Champion Strenght',
					description = 'Slows down affected targets'
				}
			},
			[2] = {
				[1] = {
					name        = 'Berserk Skill',
					description = 'Reduces coldown from each enemy in area of effect'
				},
				[2] = {
					name        = 'Destroyer Skill',
					description = 'Reduces defence of affected targets'
				},
				[3] = {
					name        = 'Champion Skill',
					description = 'Reduces attack of affected targets'
				}
			},
			[3] = {
				[1] = {
					name        = 'Berserk Mastery',
					description = 'Deals more damage to enemies closer to center'
				},
				[2] = {
					name        = 'Destroyer Mastery',
					description = 'Becomes target spell. Deals extra damage along line in direction of target'
				},
				[3] = {
					name        = 'Champion Mastery',
					description = 'Provokes affected enemies to attack you'
				}
			},
			[4] = {
				[1] = {
					name        = 'Legendary Shaking Blow',
					description = 'Херачит землетрясение'
				}
			}
		}
	},
	
	Swipe       = { -- гневный удар, D
		name        = 'Swipe',
		id          = FourCC('AHel'),
		iditempass  = FourCC('ICHH'),
		max         = 10,
		--дальше идёт копирка функции надо переделать
		description = 'Every 10-th attack causes additional damage',
		perk        = {
			[1] = {
				[1] = {
					name        = 'Berserk Strenght',
					description = 'Makes double attack immediately'
				},
				[2] = {
					name        = 'Destroyer Strenght',
					description = 'Deals additional damage 3% of maximum target`s health '
				},
				[3] = {
					name        = 'Champion Strenght',
					description = 'Adds your strenght to damage'
				}
			},
			[2] = {
				[1] = {
					name        = 'Berserk Skill',
					description = 'Increases damage from each missing health point'
				},
				[2] = {
					name        = 'Destroyer Skill',
					description = 'Adds 100% splash attack to swipe'
				},
				[3] = {
					name        = 'Champion Skill',
					description = 'Stuns affected target for 1 sec'
				}
			},
			[3] = {
				[1] = {
					name        = 'Berserk Mastery',
					description = 'Increase move speed to max if target is dying'
				},
				[2] = {
					name        = 'Destroyer Mastery',
					description = 'Increases damage by killed enemies'
				},
				[3] = {
					name        = 'Champion Mastery',
					description = 'Knocks target`s weapons'
				}
			},
			[4] = {
				[1] = {
					name        = 'Legendary Shaking Blow',
					description = 'Reduces twice attack count to activate swipe		'
				}
			}
		}
	},
	
	BattleRush  = {
		name        = 'Battle Rush',
		id          = FourCC('ABRu'),
		description = 'Furiously rushs into the target causing damage to enemies on the way',
		perk        = {
			[1] = {
				[1] = {
					name        = 'Berserk Strenght',
					description = 'Increases damage radius'
				},
				[2] = {
					name        = 'Destroyer Strenght',
					description = 'Increases the range'
				},
				[3] = {
					name        = 'Champion Strenght',
					description = 'Pushs affected targets '
				}
			},
			[2] = {
				[1] = {
					hide        = true,
					name        = 'Опыт Орды',
					description = 'Каждый 100-й убитый добавляет единицу основного аттрибута'
				},
				[2] = {
					name        = 'Destroyer Skill',
					description = 'Stuns affected targets'
				},
				[3] = {
					hide        = true,
					name        = 'Крепкость орды',
					description = 'Блокирует каждый 50-ый полученный удар'
				}
			},
			[3] = {
				[1] = {
					hide        = true,
					name        = 'Ярость Орды',
					description = 'Увеличивает урон от недостающего HP'
				},
				[2] = {
					name        = 'Destroyer Mastery',
					description = 'Kills enemies with health less than 10%'
				},
				[3] = {
					hide        = true,
					name        = 'Живучесть Орды',
					description = 'Не умирает от смертельного урона, имеет перезарядку'
				}
			},
			[4] = {
				[1] = {
					name        = 'Legendary Battle Rush',
					description = 'Adds Shaking Blow effect at the end of way'
				}
			}
		}
	},
}

for key in pairs(ABILITY) do
	ABILITY[key].codename = key
	ABILITY[key].data     = {}
end