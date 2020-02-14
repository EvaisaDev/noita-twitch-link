



insert_event({
    name = "Healthy rain",
    desc = "Its raining health!",
    func = function()
		local x, y = get_player_pos()
	  
		EntityLoad("data/entities/cloud_healthium.xml", x, y - 50)
    end
})
