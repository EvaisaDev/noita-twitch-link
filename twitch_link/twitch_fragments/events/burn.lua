



insert_event({
  name = "Catch Fire",
  desc = "It smells like burned flesh in here.",
  func = function()
	spawn_item("data/entities/set_on_fire.xml", 0, 0, false, true)
  end
})