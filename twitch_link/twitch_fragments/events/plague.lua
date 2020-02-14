



insert_event({
  name = "Plague",
  desc = "Rats everywhere!",
  func = function()
    local rats = math.random(15, 30)
    local plague = math.random(15, 30)

    for i = 1, rats do
        spawn_item("data/entities/animals/rat.xml", 150, 250, true)
    end
    for i = 1, plague do
        spawn_item("data/entities/misc/perks/plague_rats_rat.xml", 150, 250, true)
    end
  end
})