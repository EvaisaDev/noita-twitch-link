



insert_event({
  name = "Black holes",
  desc = "Tear that world apart.",
  func = function()
	  for i = 1, 3 do
		spawn_item("data/entities/projectiles/deck/black_hole_big.xml", 100, 150, true, true)
	  end
  end
})