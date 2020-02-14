



insert_event({
  name = "Thunder stones",
  desc = "Get away from the water!",
  func = function()
    for i = 1, 10 do
        spawn_item("data/entities/items/pickup/thunderstone.xml", 50, 250, false, true)
    end
  end
})