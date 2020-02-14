



insert_event({
    name = "Thunder storm",
    desc = "Shocking, I know right?",
    func = function()
		for i = 1, 2 do
			local x, y = get_player_pos()
		  
			EntityLoad("data/entities/projectiles/deck/cloud_thunder.xml", x + math.random(-30, 30), y - 50)
		end
	end
})
