



insert_event({
    name = "Whisky Rain",
    desc = "Its raining whisky!",
    func = function()
		local x, y = get_player_pos()
	  
		EntityLoad("data/entities/cloud_whisky.xml", x, y - 50)
    end
})
