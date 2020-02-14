



insert_event({
  name = "Holy bomb",
  desc = "Well.. shit.",
  func = function()
	spawn_item("data/entities/projectiles/bomb_holy.xml", 5, 10, false, true)
  end
})