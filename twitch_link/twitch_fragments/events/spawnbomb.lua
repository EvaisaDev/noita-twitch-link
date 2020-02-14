



insert_event({
  name = "Bomb the streamer",
  desc = "You better run!",
  func = function()
	for i = 1, 5 do
		spawn_item("data/entities/projectiles/bomb.xml", 20, 30)
	end
  end
})