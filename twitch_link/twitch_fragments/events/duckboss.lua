



insert_event({
  name = "Mighty Duck",
  desc = "Quack.",
  func = function()
		local duck = spawn_item("data/entities/animals/duck/duckboss_entity.xml", 150, 150, true, true)
		local x, y = EntityGetTransform(duck)
		EntityLoad("data/entities/duck_hole.xml", x, y)
  end
})