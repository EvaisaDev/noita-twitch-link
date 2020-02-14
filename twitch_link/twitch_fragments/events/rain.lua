



insert_event({
    name = "Depression",
    desc = "What a sad day..",
    func = function()
		local x, y = get_player_pos()
	  
		EntityLoad("data/entities/cloud_water.xml", x, y - 50)
    end
})