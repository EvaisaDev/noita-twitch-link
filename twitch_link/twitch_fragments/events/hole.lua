



insert_event({
    name = "Biggy hole",
    desc = "Watch your step even more!",
    func = function()
		local x, y = get_player_pos()
		local player = get_players()[1]
	  
		for i = 1, 35 do
			local blackhole = EntityLoad("data/entities/short_fat_blackhole.xml", x, y + (i * 8))

		end
    end
})
