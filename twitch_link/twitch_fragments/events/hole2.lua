



insert_event({
    name = "Diggy hole",
    desc = "Watch your step!",
    func = function()
		local x, y = get_player_pos()
		local player = get_players()[1]
	  
		for i = 1, 25 do
			local blackhole = EntityLoad("data/entities/short_blackhole.xml", x, y + (i * 8))

		end
    end
})
