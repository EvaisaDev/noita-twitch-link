



insert_event({
  name = "Worms Galore",
  desc = "Oh.. oh god...",
  func = function()
	  for i = 1, 10 do
		spawn_item("data/entities/animals/worm_tiny.xml", 100, 150, false, true)
	  end
  end
})