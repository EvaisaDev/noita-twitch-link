



insert_event({
    name = "Poison pit",
    desc = "Ew, what is this stuff.",
    func = function()
		local x, y = get_player_pos()
		local player = get_players()[1]
	  
		for i = 1, 5 do
			local blackhole = EntityLoad("data/entities/short_blackhole.xml", x, y + (i * 5))
			
		end
		local blackhole = EntityLoad("data/entities/poison_pit.xml", x, y)
    end
})
