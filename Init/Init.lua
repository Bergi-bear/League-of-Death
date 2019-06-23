do
	local InitGlobals_hook = InitGlobals
	function InitGlobals()
		InitGlobals_hook()
		HeroSelectInit()
		HeroPerkInit()
	end
end