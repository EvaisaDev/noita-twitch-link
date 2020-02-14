



insert_event({
    name = "Instant ocean",
    desc = "I hate water levels.",
    func = function()
		local x, y = get_player_pos()
	  
		EntityLoad("data/entities/projectiles/deck/sea_water.xml", x, y - 150)
    end
})
