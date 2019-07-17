RACE = {
	-- 1: Horde
	{
		name  = "Орда",
		model = "UI\\Glues\\Singleplayer\\Orccampaign3d\\orccampaign3d.mdx",
		attr  = {
			{
				description = "Орк - cила",
				unit        = FourCC("O000"),
				ability     = {
					ABILITY.ShakingBlow,
					ABILITY.BattleRush,
					ABILITY.Horde
				}
			},
			{
				unit        = FourCC("O001"),
				description = "Орк - ловка",
				ability     = {
					ABILITY.Horde
				}
			},
			{
				unit        = FourCC("O002"),
				description = "Орк - инта",
				ability     = {
					ABILITY.Horde
				}
			}
		}
	},
	{
		name = "Случайная"
	}
}
