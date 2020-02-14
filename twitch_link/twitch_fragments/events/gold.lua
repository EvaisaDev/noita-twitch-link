



insert_event({
  name = "Gold rush",
  desc = "I smell gold.",
  func = function()
	  for i = 1, 30 do
		spawn_item("data/entities/items/pickup/goldnugget.xml", 50, 100)
	  end
  end
})