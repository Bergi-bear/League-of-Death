RACE = {
	-- 1: horde
	{
		name  = "Орда",
		model = "UI\\Glues\\Singleplayer\\Orccampaign3d\\orccampaign3d.mdx",
		attr  = {
			-- 1: str
			{
				description = "Орк - cила",
				unit        = FourCC("O000"),
				ability     = {
					ABILITY.horde
				}
			},
			-- 2: agi
			{
				unit        = FourCC("O001"),
				description = "Орк - ловка",
				ability     = {
					ABILITY.horde
				}
			},
			-- 3: int
			{
				unit        = FourCC("O002"),
				description = "Орк - инта",
				ability     = {
					ABILITY.horde
				}
			}
		}
	},
	{
		name = "Случайная"
	}
}
