



insert_event({
  name = "Deerpocalypse",
  desc = "Oh deer.",
  func = function()
	for i = 1, 12 do
        spawn_item("data/entities/projectiles/deck/exploding_deer.xml", 50, 160, true)
        spawn_item("data/entities/animals/deer.xml", 50, 160, true)
    end
  end
})