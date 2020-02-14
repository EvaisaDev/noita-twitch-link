



insert_event({
  name = "Earthquake",
  desc = "Take cover quick!",
  func = function()
	async(function()
        local TEXT = {
            font="data/fonts/font_pixel_white.xml",
            string="Earthquake in 5",
            offset_x="0",
            offset_y="26",
            alpha="0.50",
            scale_x="0.8",
            scale_y="0.8"
        }
		local shake = 1
		
        timer = append_text(get_player(), TEXT)
		TEXT.string = "5"
        for i=1, tonumber(TEXT.string) do
            wait(60)
            local num = tonumber(TEXT.string) - i
            ComponentSetValue( timer, "text", "Earthquake in "..tostring(num) )
			GameScreenshake( shake )
			shake = shake + 1
        end
        wait(60)
        EntityRemoveComponent(get_player(), timer)		 
		spawn_item("data/entities/projectiles/deck/crumbling_earth.xml", 10, 10, false, true)
	end)
  end
})