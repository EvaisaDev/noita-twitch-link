



insert_event({
  name = "Chest",
  desc = "A free chest for you!",
  func = function()
    if(math.random(1,3) == 1)then
		spawn_item("data/entities/animals/chest_mimic.xml",30, 100, true)
	else
		spawn_item("data/entities/items/pickup/chest_random.xml", 30, 100, true)
	end
  end
})