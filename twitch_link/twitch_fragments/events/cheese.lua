



insert_event({
  name = "Cheese",
  desc = "The moon is made of cheese, so is the world.",
  func = function()
	spawn_item("data/entities/cheese.xml", 0, 0, false, true)
  end
})