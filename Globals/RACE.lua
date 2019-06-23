RACE = {
	-- 1: ork
	{
		name  = "Орда",
		model = "UI\\Glues\\Singleplayer\\Orccampaign3d\\orccampaign3d.mdx",
		attr  = {
			-- 1: str
			{
				description = "Орк - cила",
				unit        = FourCC("O000"),
				ability     = {
					ABILITY.ork
				}
			},
			-- 2: agi
			{
				unit        = FourCC("O001"),
				description = "Орк - ловка",
				ability     = {
					ABILITY.ork
				}
			},
			-- 3: int
			{
				unit        = FourCC("O002"),
				description = "Орк - инта",
				ability     = {
					ABILITY.ork
				}
			}
		}
	},
	--[[
	-- 2: human
	{
		name  = "Человек",
		model = "UI\\Glues\\Singleplayer\\Humancampaign3d\\humancampaign3d.mdx",
		attr  = {
			-- 1: str
			{
				unit        = FourCC("Hmkg"),
				description = "Хуман - сила"
			},
			-- 2: agi
			{
				unit        = FourCC("Hpal"),
				description = "Хуман - ловка"
			},
			-- 3: int
			{
				unit        = FourCC("Hblm"),
				description = "Хуман - инта"
			}
		}
	},
	-- 3: undead
	{
		name  = "Нежить",
		model = "UI\\Glues\\Singleplayer\\Undeadcampaign3d\\undeadcampaign3d.mdx",
		attr  = {
			-- 1: str
			{
				unit        = FourCC("Ucrl"),
				description = "Андед - сила"
			},
			-- 2: agi
			{
				unit        = FourCC("Udre"),
				description = "Андед - ловка"
			},
			-- 3: int
			{
				unit        = FourCC("Ulic"),
				description = "Андед - инта"
			}
		}
	},
	-- 4: elf
	{
		name  = "Эльф",
		model = "UI\\Glues\\Singleplayer\\Nightelfcampaign3d\\nightelfcampaign3d.mdx",
		attr  = {
			-- 1: str
			{
				unit        = FourCC("Ucrl"),
				description = "Эльф - сила"
			},
			-- 2: agi
			{
				unit        = FourCC("Udre"),
				description = "Эльф - ловка"
			},
			-- 3: int
			{
				unit        = FourCC("Ulic"),
				description = "Эльф - инта"
			}
		}
	},
	]]
	-- 5
	{
		name = "Случайная"
	}
}
