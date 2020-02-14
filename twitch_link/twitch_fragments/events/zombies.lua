	



insert_event({
  name = "Zombie apocalypse",
  desc = "Waves of monsters.",
  func = function()
	async(function()
        local TEXT = {
            font="data/fonts/font_pixel_white.xml",
            string="10",
            offset_x="2",
            offset_y="32",
            alpha="0.50",
            scale_x="0.8",
            scale_y="0.8"
        }
		local player = get_player()
		if(EntityIsAlive(player))then return end
        local timer = append_text(get_player(), TEXT)
        
        local tnt = math.random(5, 9)
        local small_bombs = math.random(10, 15)
        local bombs = math.random(5, 10)

        for i=1, tonumber(TEXT.string) do
            wait(60)
            local num = tonumber(TEXT.string) - i
            ComponentSetValue( timer, "text", tostring(num) )
        end
        wait(60)
		if(EntityIsAlive(player))then return end
        EntityRemoveComponent(get_player(), timer)

        GameScreenshake( 200 )
		enemies = {"data/entities/animals/zombie_weak.xml","data/entities/animals/longleg.xml","data/entities/animals/worm.xml","data/entities/animals/shotgunner_weak.xml","data/entities/animals/miner_weak.xml"}
        for i = 1, small_bombs do
            spawn_item(enemies[math.random(1,table.getn(enemies))], 80, 200)
        end

        TEXT.string = "10"
		if(EntityIsAlive(player))then return end
        timer = append_text(get_player(), TEXT)
        for i=1, tonumber(TEXT.string) do
            wait(60)
            local num = tonumber(TEXT.string) - i
            ComponentSetValue( timer, "text", tostring(num) )
        end
        wait(60)
		if(EntityIsAlive(player))then return end
        EntityRemoveComponent(get_player(), timer)

        GameScreenshake( 400 )
		pre_bosses = {"data/entities/animals/acidshooter_weak.xml","data/entities/animals/fireskull.xml","data/entities/animals/giantshooter_weak.xml","data/entities/animals/shotgunner_weak.xml"}

        for i = 1, bombs do
            spawn_item(pre_bosses[math.random(1,table.getn(pre_bosses))], 80, 200)
        end

        TEXT.string = "10"
		if(EntityIsAlive(player))then return end
        timer = append_text(get_player(), TEXT)
        for i=1, tonumber(TEXT.string) do
            wait(60)
            local num = tonumber(TEXT.string) - i
            ComponentSetValue( timer, "text", tostring(num) )
        end
        wait(60)
		if(EntityIsAlive(player))then return end
        EntityRemoveComponent(get_player(), timer)
        GameScreenshake( 1000 )
		bosses = {"data/entities/animals/worm_big.xml","data/entities/animals/thundermage.xml","data/entities/animals/iceskull.xml","data/entities/animals/scavenger_grenade.xml"}
        for i = 1, 2 do
			spawn_item(bosses[math.random(1,table.getn(bosses))], 80, 200)
		end
        TEXT.string = "10"
		if(EntityIsAlive(player))then return end
        timer = append_text(get_player(), TEXT)
        for i=1, tonumber(TEXT.string) do
            wait(60)
            local num = tonumber(TEXT.string) - i
            ComponentSetValue( timer, "text", tostring(num) )
        end
        wait(60)
		if(EntityIsAlive(player))then return end
        EntityRemoveComponent(get_player(), timer)
        GameScreenshake( 1000 )
		  for i = 1, 40 do
			spawn_item("data/entities/items/pickup/goldnugget.xml", 50, 100)
		  end
    end)
  end
})