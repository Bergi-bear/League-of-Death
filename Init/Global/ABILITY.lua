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
		id          = FourCC('A000'),
		description = 'Shakes the ground causing damage to enemies around',
		perk        = {
			[1] = {
				[1] = {
					name        = 'Berserk Strenght',
					description = 'Increases area of damage'
				},
				[2] = {
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
	jump        = {
		name        = 'Яростный врыв',
		id          = FourCC('0000'),
		icon        = 'ReplaceableTextures\\CommandButtons\\BTNThorns.blp',
		description = 'Яростно врывается прыжком в указанную область, нанося урон поражённым целям',
	},
	helix       = {
		name        = 'Размашистый удар',
		id          = FourCC('0000'),
		icon        = 'ReplaceableTextures\\CommandButtons\\BTNCommand.blp',
		description = 'Совершает резкий размашистый удар вокруг себя, нанося врагам урон',
	},
	swipe       = {
		name        = 'Гневный удар',
		id          = FourCC('0000'),
		icon        = 'ReplaceableTextures\\CommandButtons\\BTNTrueShot.blp',
		description = 'Каждый 10-ый удар совершается с особой яростью и наносит дополнительный урон',
	},
	rage        = {
		name        = 'Бешенство',
		id          = FourCC('0000'),
		icon        = 'ReplaceableTextures\\CommandButtons\\BTNSilence.blp',
		description = 'Герой впадает в бешенство, приобретая усиленные рефлексы, а также получает сопротивляемость к магии',
	}
}

for key in pairs(ABILITY) do
	ABILITY[key].codename = key
end