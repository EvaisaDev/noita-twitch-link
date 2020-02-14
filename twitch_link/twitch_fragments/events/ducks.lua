



insert_event({
  name = "Spicy ducks",
  desc = "What the duck is going on!",
  func = function()
	for i = 1, 20 do
        local duck = spawn_item("data/entities/animals/duck/duck.xml", 30, 80, false)
		local x, y = EntityGetTransform(duck)
		local duckbomb = EntityLoad("data/entities/duckbomb.xml", x, y)
		EntityAddChild( duck, duckbomb )
    end
  end
})