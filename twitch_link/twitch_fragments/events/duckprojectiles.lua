



insert_event({
  name = "Duck projectiles",
  desc = "Projectiles are now ducks!",
  func = function()
		local x, y = get_player_pos()
	  
		EntityLoad("data/entities/duck_projectiles.xml", x, y)
  end
})