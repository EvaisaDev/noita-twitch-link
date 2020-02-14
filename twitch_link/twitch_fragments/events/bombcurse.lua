



insert_event({
    name = "Bomb Curse",
    desc = "You are leaving a bomb trail.",
    func = function()
		async(function()
			local x, y = get_player_pos()
			local player = get_players()[1]
		  
			local rain = EntityAddComponent( player, "LuaComponent", 
			{ 
				script_source_file = "data/entities/barrelrain.lua",
				execute_every_n_frame = "60",
			})
			
			wait(1200)
			
			EntityRemoveComponent( player, rain)
		end)
	end
})
