



insert_event({
  name = "Windy",
  desc = "Wind blows aways from you!",
  func = function()
	async(function()
		local player = get_player()
		local x, y = get_player_pos()
		local cid = EntityLoad( "data/entities/wind.xml", x, y )
		EntityAddChild( player, cid )
		wait(2400)
		EntityKill(cid)
	end)
  end
})