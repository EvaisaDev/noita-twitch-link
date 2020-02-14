



insert_event({
  name = "Tentacles",
  desc = "uwu what's this?",
  func = function()
	for i = 1, 4 do
		spawn_item("data/entities/projectiles/deck/tentacle_portal.xml", 30, 120, true)
	end
  end
})