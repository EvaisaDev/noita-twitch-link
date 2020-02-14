



insert_event({
  name = "Regular ducks",
  desc = "These are just ducks, don't worry about it.",
  func = function()
	for i = 1, 25 do
        local duck = spawn_item("data/entities/animals/duck.xml", 10, 50, false)
    end
  end
})