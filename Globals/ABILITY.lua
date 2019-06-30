ABILITY = {
	horde = {
		name        = 'Сила орка',
		id          = FourCC('0000'),
		icon        = 'ReplaceableTextures\\CommandButtons\\BTNAbility1.blp',
		description = 'Повышает характеристики орка',
		perk        = {
			[1] = {
				[1] = {
					name        = 'Стойкость Орды',
					description = 'Увеличивает количество HP'
				},
				[2] = {
					name        = 'Регенерация Орды',
					description = 'Увеличивает эффективность регенерации HP/MP'
				},
				[3] = {
					name        = 'Закалка Орды',
					description = 'Получает слабую магическую сопротивляемость'
				}
			},
			[2] = {
				[1] = {
					name        = 'Опыт Орды',
					description = 'Каждый 100-й убитый добавляет единицу основного аттрибута'
				},
				[2] = {
					name        = 'Сила Орды',
					description = 'Каждый 10-ый удар игнорирует броню'
				},
				[3] = {
					name        = 'Крепкость орды',
					description = 'Блокирует каждый 50-ый полученный удар'
				}
			},
			[3] = {
				[1] = {
					name        = 'Ярость Орды',
					description = 'Увеличивает урон от недостающего HP'
				},
				[2] = {
					name        = 'Кровожадность Орды',
					description = 'Каждый 20-ый убитый добавляет доп. очки раунда'
				},
				[3] = {
					name        = 'Живучесть Орды',
					description = 'Не умирает от смертельного урона, имеет перезарядку'
				}
			},
			[4] = {
				[1] = {
					name        = 'Легендарная Особенность Орды',
					description = 'Увеличивает все бонусы от Особенности Орды вдвое. Требует: Не менее трёх Особенностей Орды'
				}
			}
		}
	},
	smash = {
		name        = 'Грохот',
		id          = FourCC('0000'),
		icon        = 'ReplaceableTextures\\CommandButtons\\BTNUnholyAura.blp',
		description = 'Герой совершает розящий удар по земле, нанося урон врагам вокруг (без цели)'
	},
	jump  = {
		name        = 'Яростный врыв',
		id          = FourCC('0000'),
		icon        = 'ReplaceableTextures\\CommandButtons\\BTNThorns.blp',
		description = 'Яростно врывается прыжком в указанную область, нанося урон поражённым целям',
	},
	helix = {
		name        = 'Размашистый удар',
		id          = FourCC('0000'),
		icon        = 'ReplaceableTextures\\CommandButtons\\BTNCommand.blp',
		description = 'Совершает резкий размашистый удар вокруг себя, нанося врагам урон',
	},
	swipe = {
		name        = 'Гневный удар',
		id          = FourCC('0000'),
		icon        = 'ReplaceableTextures\\CommandButtons\\BTNTrueShot.blp',
		description = 'Каждый 10-ый удар совершается с особой яростью и наносит дополнительный урон',
	},
	rage  = {
		name        = 'Бешенство',
		id          = FourCC('0000'),
		icon        = 'ReplaceableTextures\\CommandButtons\\BTNSilence.blp',
		description = 'Герой впадает в бешенство, приобретая усиленные рефлексы, а также получает сопротивляемость к магии',
	}
}

for key in pairs(ABILITY) do
	ABILITY[key].codename = key
end