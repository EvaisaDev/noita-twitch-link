



insert_event({
  name = "Legos",
  desc = "Watch your step!",
  func = function()
	for i = 1, 20 do
		local caltrop = spawn_item("mods/spellbound_bundle/files/spellbound/projectiles/giant_disc_bullet2.xml", 50, 120)
		local sprite = EntityGetComponent(caltrop, "SpriteComponent")
		--EntityRemoveComponent(caltrop, sprite)
		local random_lego = "data/gfx/lego"..tostring(math.random(1,4))..".xml"
		EntityAddComponent(caltrop, "SpriteComponent", {
			image_file = random_lego
		})
		--ComponentSetValue(sprite, "image_file", "data/gfx/lego"..tostring(math.random(1,4))..".xml")
	end
  end
})