dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/perks/perk.lua")
dofile("data/scripts/perks/perk_list.lua")
dofile( "data/scripts/gun/gun_enums.lua")
dofile( "data/scripts/gun/procedural/gun_action_utils.lua")

insert_event({
    name = "Acid trap",
    desc = "This looks dangerous!",
    func = function()
		local x, y = get_player_pos()

		EntityLoad("data/entities/acid_trap.xml", x, y - 130)
    end
})

insert_event({
    name = "Whisky Rain",
    desc = "Its raining whisky!",
    func = function()
		local x, y = get_player_pos()
	  
		EntityLoad("data/entities/cloud_whisky.xml", x, y - 50)
    end
})

insert_event({
    name = "Always Cast",
    desc = "One of your wands got a random always cast.",
    func = function()
        local wands = get_wands()
        if wands == nil then return end
        local wand = wands[Random(1,table.getn(wands))]

		local player = get_player()
		local x, y = EntityGetTransform(player)
		
		AddGunActionPermanent( wand, GetRandomAction( x, y, 6, 666))
		

        local ability = EntityGetAllComponents(wand)
        for _, c in ipairs(ability) do
            if ComponentGetTypeName(c) == "AbilityComponent" then
                local deck_capacity = tonumber(ComponentObjectGetValue(c, "gun_config", "deck_capacity"))
				deck_capacity = deck_capacity + 1
                ComponentObjectSetValue(c, "gun_config", "deck_capacity", tostring(deck_capacity))
            end
        end		
    end
})

insert_event({
  name = "Anger gods",
  desc = "You have angered the gods!",
  func = function()
		spawn_item("data/entities/misc/spawn_necromancer_shop.xml", 150, 200, true)
  end
})

insert_event({
    name = "Bomb Curse",
    desc = "You are leaving a bomb trail.",
    func = function()
		async(function()
			local x, y = get_player_pos()
			local player = get_players()[1]
		  
			local rain = EntityAddComponent( player, "LuaComponent", 
			{ 
				script_source_file = "data/entities/barrelrain.lua",
				execute_every_n_frame = "60",
			})
			
			wait(600)
			
			EntityRemoveComponent( player, rain)
		end)
	end
})

insert_event({
  name = "Big boy worm",
  desc = "That is one big worm!",
  func = function()
		spawn_item("data/entities/animals/worm_big.xml", 100, 150, true)
  end
})

insert_event({
  name = "Blazing enemies",
  desc = "Enemies are blazing!",
  func = function()
    for _,player_entity in pairs( get_players() ) do
        local x, y = EntityGetTransform( player_entity );
        for _,entity in pairs( EntityGetInRadiusWithTag( x, y, 10000, "enemy" ) or {} ) do
		
			if(EntityHasTag(entity, "drone_friendly"))then 
				return 
			end
            GetGameEffectLoadTo( entity, "PROTECTION_FIRE", true );
            
            EntityAddComponent( entity, "ShotEffectComponent", { extra_modifier = "BURN_TRAIL", } );

            EntityAddComponent( entity, "ParticleEmitterComponent", 
            { 
                emitted_material_name="fire",
                count_min="6",
                count_max="8",
                x_pos_offset_min="-4",
                y_pos_offset_min="-4",
                x_pos_offset_max="4",
                y_pos_offset_max="4",
                x_vel_min="-10",
                x_vel_max="10",
                y_vel_min="-10",
                y_vel_max="10",
                lifetime_min="1.1",
                lifetime_max="2.8",
                create_real_particles="1",
                emit_cosmetic_particles="0",
                emission_interval_min_frames="1",
                emission_interval_max_frames="1",
                delay_frames="2",
                is_emitting="1",
            })    

            EntityAddComponent( entity, "ParticleEmitterComponent", 
            { 
                emitted_material_name="fire",
                custom_style="FIRE",
                count_min="1",
                count_max="1",
                x_pos_offset_min="0",
                y_pos_offset_min="0",
                x_pos_offset_max="0",
                y_pos_offset_max="0",
                is_trail="1",
                trail_gap="1.0",
                x_vel_min="-5",
                x_vel_max="5",
                y_vel_min="-10",
                y_vel_max="10",
                lifetime_min="1.1",
                lifetime_max="2.8",
                create_real_particles="1",
                emit_cosmetic_particles="0",
                emission_interval_min_frames="1",
                emission_interval_max_frames="1",
                delay_frames="2",
                is_emitting="1",
            })  
        end
    end
  end
})

insert_event({
  name = "Blindness",
  desc = "It sure got dark in here!",
  func = function()
    for _,player_entity in pairs( get_players() ) do
        local game_effect = GetGameEffectLoadTo( player_entity, "BLINDNESS", false );
        if game_effect ~= nil then
            ComponentSetValue( game_effect, "frames", 900 );
        end
    end
  end
})

insert_event({
  name = "Catch Fire",
  desc = "It smells like burned flesh in here.",
  func = function()
	spawn_item("data/entities/set_on_fire.xml", 0, 0)
  end
})



insert_event({
  name = "Cheese",
  desc = "The moon is made of cheese, so is the world.",
  func = function()
	spawn_item("data/entities/cheese.xml", 0, 0)
  end
})



insert_event({
  name = "Chest",
  desc = "A free chest for you!",
  func = function()
    if(Random(1,3) == 1)then
		spawn_item("data/entities/animals/chest_mimic.xml",30, 100, true)
	else
		spawn_item("data/entities/items/pickup/chest_random.xml", 30, 100, true)
	end
  end
})



insert_event({
  name = "Invert controls",
  desc = "You look very confused.",
  func = function()
	local player = get_players()[1]
	local game_effect = GetGameEffectLoadTo(player, "CONFUSION", true);
    if game_effect ~= nil then 
		ComponentSetValue(game_effect, "frames", "1200"); 
	end
  end
})



insert_event({
  name = "Health down",
  desc = "Your max HP got decreased!",
  func = function()
	local player = get_players()[1]
	
    local damagemodels = EntityGetComponent(player, "DamageModelComponent")
    if (damagemodels ~= nil) then
        for i, damagemodel in ipairs(damagemodels) do
            local max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp"))
            local cur_hp = tonumber(ComponentGetValue(damagemodel, "hp"))
            local new_cur = cur_hp - ((cur_hp / 100) * Random(4, 10))
			local new_max = max_hp - ((max_hp / 100) * Random(4, 10))
            ComponentSetValue(damagemodel, "max_hp", new_max)
            ComponentSetValue(damagemodel, "hp", new_cur)
        end
    end

  end
})



insert_event({
  name = "Deerpocalypse",
  desc = "Oh deer.",
  func = function()
	for i = 1, 5 do
        spawn_item("data/entities/projectiles/deck/exploding_deer.xml", 50, 150, true)
        spawn_item("data/entities/animals/deer.xml", 100, 300, true)
    end
  end
})



insert_event({
    name = "Downgrade wand",
    desc = "One of your wands has been downgraded.",
    func = function()
        local wands = get_wands()
        if wands == nil then return end
        local to_boost = wands[Random(1,table.getn(wands))]


        local ability = EntityGetAllComponents(to_boost)
        local boost_speed = Random(0, 1)
        local boost_recharge = Random(0, 1)
        local reduce_spread = Random(0, 1)
        local unshuffle = Random(0, 1)
        for _, c in ipairs(ability) do
            if ComponentGetTypeName(c) == "AbilityComponent" then
                local mana_max = tonumber(ComponentGetValue(c, "mana_max"))
                local mana_charge = tonumber(ComponentGetValue(c, "mana_charge_speed"))
                local deck_capacity = tonumber(ComponentObjectGetValue(c, "gun_config", "deck_capacity"))
                mana_max = mana_max - ((mana_max / 100) * Random(10, 20))
                mana_charge = mana_charge - ((mana_charge / 100) * Random(10, 20))
				if(3 < deck_capacity)then
					deck_capacity = deck_capacity - Random(1, 3)
				end
                ComponentSetValue(c, "mana_max", tostring(mana_max))
                ComponentSetValue(c, "mana_charge_speed", tostring(mana_charge))
                ComponentObjectSetValue(c, "gun_config", "deck_capacity", tostring(deck_capacity))
                if boost_recharge > 0 then
                    local cur_recharge = ComponentObjectGetValue(c, "gun_config", "reload_time") cur_recharge = cur_recharge - ((cur_recharge / 100) * Random(10, 20)) ComponentObjectSetValue(c, "gun_config", "reload_time", tostring(cur_recharge))
                end
                if boost_speed > 0 then
                    local cur_speed = ComponentObjectGetValue(c, "gunaction_config", "fire_rate_wait")
                    cur_speed = cur_speed + ((cur_speed / 100) * Random(10, 20))
                    ComponentObjectSetValue(c, "gunaction_config", "fire_rate_wait", tostring(cur_speed))
                end
                if reduce_spread > 0 then
                    local cur_spread = ComponentObjectGetValue(c, "gunaction_config", "spread_degrees")
                    cur_spread = cur_spread + ((cur_spread / 100) * Random(10, 20))
                    ComponentObjectSetValue(c, "gunaction_config", "spread_degrees", tostring(cur_spread))
                end
                if unshuffle > 0 then
                    ComponentObjectSetValue(c, "gun_config", "shuffle_deck_when_empty", tostring(1))
                end
            end
        end
    end
})




insert_event({
  name = "Drone party",
  desc = "Have some drones!",
  func = function()
	drones = {"mods/risk_of_drones/files/dronemod/evaisa/spells/entities/attack_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/basic_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/missile_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/flame_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/health_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/equipment_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/laser_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/health_drone2.xml" }       
	for i = 1, 3 do
		spawn_item(drones[Random(1,table.getn(drones))], 10, 10, true)
	end
  end
})



insert_event({
  name = "Regular ducks.",
  desc = "These are just ducks, don't worry about it.",
  func = function()
	for i = 1, 15 do
        local duck = spawn_item("data/entities/animals/duck.xml", 10, 50, true)
    end
  end
})



insert_event({
  name = "Spicy ducks",
  desc = "What the duck is going on!",
  func = function()
	for i = 1, 5 do
        local duck = spawn_item("data/entities/animals/duck.xml", 10, 50, true)
		local x, y = EntityGetTransform(duck)
		local duckbomb = EntityLoad("data/entities/duckbomb.xml", x, y)
		EntityAddChild( duck, duckbomb )
    end
  end
})



insert_event({
  name = "Earthquake",
  desc = "Take cover quick!",
  func = function()
	spawn_item("data/entities/projectiles/deck/crumbling_earth.xml", 10, 10)
  end
})



insert_event({
  name = "Stun",
  desc = "You have been stunned",
  func = function()
    local player = get_player()
    local game_effect = GetGameEffectLoadTo( player, "ELECTROCUTION", true );
    if game_effect ~= nil then ComponentSetValue( game_effect, "frames", 120 ); end
  end
})



insert_event({
  name = "More gold",
  desc = "Gold pickups are temporarily worth alot more.",
  func = function()
	local player = get_players()[1]
	for i = 1, 3 do
		local game_effect = GetGameEffectLoadTo(player, "EXTRA_MONEY", true);
		if game_effect ~= nil then 
			ComponentSetValue(game_effect, "frames", "3600"); 
		end
	end
  end
})



insert_event({
  name = "Transformation",
  desc = "Enemies are chaotic polymorphed.",
  func = function()
    for _,player_entity in pairs( get_players() ) do
        local x, y = EntityGetTransform( player_entity );
        for _,entity in pairs( EntityGetInRadiusWithTag( x, y, 10000, "enemy" ) or {} ) do
		
			if(EntityHasTag(entity, "drone_friendly"))then 
				return 
			end
            GetGameEffectLoadTo( entity, "POLYMORPH_RANDOM", true );
        end
    end
  end
})



insert_event({
  name = "Enemy shields",
  desc = "Enemies have shields.",
  func = function()
    for _,player_entity in pairs( get_players() ) do
        local x, y = EntityGetTransform( player_entity );
        for _,entity in pairs( EntityGetInRadiusWithTag( x, y, 10000, "enemy" ) or {} ) do
            local x, y = EntityGetTransform( entity );
            local hitbox = EntityGetFirstComponent( entity, "HitboxComponent" );
            local radius = nil;
            local height = 18;
            local width = 18;
            if hitbox ~= nil then
                height = tonumber( ComponentGetValue( hitbox, "aabb_max_y" ) ) - tonumber( ComponentGetValue( hitbox, "aabb_min_y" ) );
                width = tonumber( ComponentGetValue( hitbox, "aabb_max_x" ) ) - tonumber( ComponentGetValue( hitbox, "aabb_min_x" ) );
            end
			if(EntityHasTag(entity, "drone_friendly"))then 
				return 
			end
            radius = math.max( height, width ) + 6;
            local shield = EntityLoad( "data/entities/misc/animal_energy_shield.xml", x, y );
            local inherit_transform = EntityGetFirstComponent( shield, "InheritTransformComponent" );
            if inherit_transform ~= nil then
                ComponentSetValue( inherit_transform, "parent_hotspot_tag", "shield_center" );
            end
            local emitters = EntityGetComponent( shield, "ParticleEmitterComponent" ) or {};
            for _,emitter in pairs( emitters ) do
                ComponentSetValueValueRange( emitter, "area_circle_radius", radius, radius );
            end
            local energy_shield = EntityGetFirstComponent( shield, "EnergyShieldComponent" );
            ComponentSetValue( energy_shield, "radius", tostring( radius ) );

            local hotspot = EntityAddComponent( entity, "HotspotComponent",{
                _tags="shield_center"
            } );
            ComponentSetValueVector2( hotspot, "offset", 0, -height * 0.3 );

            if shield ~= nil then EntityAddChild( entity, shield ); end
        end
    end
  end
})



insert_event({
  name = "Enemy teleportitis",
  desc = "Enemies have teleportitis.",
  func = function()
    for _,player_entity in pairs( get_players() ) do
        local x, y = EntityGetTransform( player_entity );
        for _,entity in pairs( EntityGetInRadiusWithTag( x, y, 10000, "enemy" ) or {} ) do
		
			if(EntityHasTag(entity, "drone_friendly"))then 
				return 
			end
            GetGameEffectLoadTo( entity, "TELEPORTATION", true );
        end
    end
  end
})



insert_event({
  name = "Farts",
  desc = "You feel gassy.",
  func = function()
  	local player = get_players()[1]
    local game_effect = GetGameEffectLoadTo(player, "FARTS", true);
    if game_effect ~= nil then 
        ComponentSetValue(game_effect, "frames", 1800);
    end
  end
})



insert_event({
  name = "Fire trap",
  desc = "Oh my gOD RUN!!",
  func = function()
	spawn_item("data/entities/projectiles/deck/circle_fire.xml", 70, 120, true)
  end
})



insert_event({
  name = "Full heal",
  desc = "You got your health back!",
  func = function()
	local player = get_players()[1]
	local max_hp = 0
	local healing = 0
	
	local x, y = EntityGetTransform( player )

	local damagemodels = EntityGetComponent( player, "DamageModelComponent" )
	if( damagemodels ~= nil ) then
		for i,damagemodel in ipairs(damagemodels) do
			max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) )
			local hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
			
			healing = max_hp - hp
			
			ComponentSetValue( damagemodel, "hp", max_hp)
		end
	end

	EntityLoad("data/entities/particles/image_emitters/heart_fullhp_effect.xml", x, y-12)
	EntityLoad("data/entities/particles/heart_out.xml", x, y-8)
	--GameTriggerMusicEvent( "music/temple/enter", true, x, y )

  end
})



insert_event({
  name = "Genocide",
  desc = "Kill all enemies",
  func = function()
	local enemies = EntityGetWithTag( "enemy" )
	for k, enemy in pairs(enemies) do 
		local x, y = EntityGetTransform(enemy)
		if(EntityHasTag(enemy, "drone_friendly"))then
			
		else
			EntityLoad("data/entities/murdershot.xml", x, y)
		end
	end
  end
})



insert_event({
  name = "Gold rush",
  desc = "I smell gold.",
  func = function()
	  for i = 1, 30 do
		spawn_item("data/entities/items/pickup/goldnugget.xml", 50, 100)
	  end
  end
})



insert_event({
    name = "Healthy rain",
    desc = "Its raining health!",
    func = function()
		local x, y = get_player_pos()
	  
		EntityLoad("data/entities/cloud_healthium.xml", x, y - 50)
    end
})




insert_event({
  name = "Tentacles",
  desc = "uwu what's this?",
  func = function()
	for i = 1, 4 do
		spawn_item("data/entities/projectiles/deck/tentacle_portal.xml", 10, 70, true)
	end
  end
})



insert_event({
    name = "Diggy hole",
    desc = "Watch your step!",
    func = function()
		local x, y = get_player_pos()
		local player = get_players()[1]
	  
		for i = 1, 25 do
			local blackhole = EntityLoad("data/entities/short_blackhole.xml", x, y + (i * 8))

		end
    end
})




insert_event({
  name = "Holy bomb",
  desc = "Well.. shit.",
  func = function()
	spawn_item("data/entities/projectiles/bomb_holy.xml", 5, 10)
  end
})



insert_event({
  name = "Health up",
  desc = "Your max HP got increased!",
  func = function()
	local player = get_players()[1]
	
    local damagemodels = EntityGetComponent(player, "DamageModelComponent")
    if (damagemodels ~= nil) then
        for i, damagemodel in ipairs(damagemodels) do
            local max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp"))
            local cur_hp = tonumber(ComponentGetValue(damagemodel, "hp"))
            local new_cur = cur_hp + ((cur_hp / 100) * Random(5, 20))
			local new_max = max_hp + ((max_hp / 100) * Random(5, 20))
            ComponentSetValue(damagemodel, "max_hp", new_max)
            ComponentSetValue(damagemodel, "hp", new_cur)
        end
    end

  end
})



insert_event({
    name = "Lava pit",
    desc = "That is very hot.",
    func = function()
		local x, y = get_player_pos()
		local player = get_players()[1]
	  
		for i = 1, 5 do
			local blackhole = EntityLoad("data/entities/short_blackhole.xml", x, y + (i * 5))
			
		end
		local blackhole = EntityLoad("data/entities/lava_pit.xml", x, y)
    end
})




insert_event({
  name = "Legos",
  desc = "Watch your step!",
  func = function()
	for i = 1, 20 do
		local caltrop = spawn_item("mods/spellbound_bundle/files/spellbound/projectiles/giant_disc_bullet2.xml", 50, 120, 1000)
		local sprite = EntityGetComponent(caltrop, "SpriteComponent")
		--EntityRemoveComponent(caltrop, sprite)
		local random_lego = "data/gfx/lego"..tostring(Random(1,4))..".xml"
		EntityAddComponent(caltrop, "SpriteComponent", {
			image_file = random_lego
		})
		--ComponentSetValue(sprite, "image_file", "data/gfx/lego"..tostring(Random(1,4))..".xml")
	end
  end
})



insert_event({
  name = "Farts",
  desc = "You feel gassy.",
  func = function()
  	local player = get_players()[1]
    local game_effect = GetGameEffectLoadTo(player, "FARTS", true);
    if game_effect ~= nil then 
        ComponentSetValue(game_effect, "frames", 1800);
    end
  end
})



insert_event({
  name = "Strength",
  desc = "Your spells are temporarily 4 times as powerful.",
  func = function()
	local player = get_players()[1]
	for i = 1, 2 do
		local game_effect = GetGameEffectLoadTo(player, "DAMAGE_MULTIPLIER", true);
		if game_effect ~= nil then 
			ComponentSetValue(game_effect, "frames", "3600"); 
		end
	end
  end
})



insert_event({
    name = "Instant ocean",
    desc = "I hate water levels.",
    func = function()
		local x, y = get_player_pos()
	  
		EntityLoad("data/entities/projectiles/deck/sea_water.xml", x, y - 150)
    end
})




insert_event({
  name = "Plague",
  desc = "Rats everywhere!",
  func = function()
    local rats = Random(5, 10)
    local plague = Random(5, 10)

    for i = 1, rats do
        spawn_item("data/entities/animals/rat.xml", 50, 150, true)
    end
    for i = 1, plague do
        spawn_item("data/entities/misc/perks/plague_rats_rat.xml", 50, 150, true)
    end
  end
})



insert_event({
    name = "Poison pit",
    desc = "Ew, what is this stuff.",
    func = function()
		local x, y = get_player_pos()
		local player = get_players()[1]
	  
		for i = 1, 5 do
			local blackhole = EntityLoad("data/entities/short_blackhole.xml", x, y + (i * 5))
			
		end
		local blackhole = EntityLoad("data/entities/poison_pit.xml", x, y)
    end
})




insert_event({
  name = "Projectile attraction",
  desc = "You temporarily attract projectiles.",
  func = function()
	async(function()
		local player = get_player()
		local repulsion = EntityAddComponent( player, "LuaComponent", 
		{ 
			script_source_file = "data/entities/projectile_attraction.lua",
			execute_every_n_frame = "2",
		})
		local particles = EntityAddComponent( player, "ParticleEmitterComponent",
		{
			emitted_material_name="plasma_fading_pink",
			x_pos_offset_min="-40",
			x_pos_offset_max="40",
			y_pos_offset_min="-40",
			y_pos_offset_max="40",
			x_vel_min="-8",
			x_vel_max="8",
			y_vel_min="-8",
			y_vel_max="8",
			count_min="4",
			count_max="4",
			attractor_force="32",
			lifetime_min="0.1",
			lifetime_max="1.5",
			create_real_particles="0",
			emit_cosmetic_particles="1",
			fade_based_on_lifetime="1",
			draw_as_long="1",
			emission_interval_min_frames="2",
			emission_interval_max_frames="2",
			is_emitting="1",	
		})
        wait(2400)
		EntityRemoveComponent( player, repulsion)
		EntityRemoveComponent( player, particles)
    end)	
  end
})



insert_event({
    name = "Rain",
    desc = "What a rainy day.",
    func = function()
		local x, y = get_player_pos()
	  
		EntityLoad("data/entities/projectiles/deck/cloud_water.xml", x, y - 50)
    end
})




insert_event({
  name = "Black holes",
  desc = "Tear that world apart.",
  func = function()
	  for i = 1, 3 do
		spawn_item("data/entities/projectiles/deck/black_hole_big.xml", 100, 150)
	  end
  end
})



local effects = {
	"DRUNK",
	"CONFUSION",
	"MOVEMENT_FASTER_2X",
	"WORM_ATTRACTOR",
	"MANA_REGENERATION",
	"REGENERATION",
	"BERSERK",
	"INVISIBILITY",
	"ON_FIRE"
}
local names = {
	"You are drunk!",
	"You are confused!",
	"You are fast!",
	"You attract worms!",
	"You regenerate mana fast!",
	"You regenerate health!",
	"You feel strong!",
	"You are invisible!",
	"You are on fire!"
}	
local effect = Random(1, #effects)
insert_event({
  name = "Random effect",
  desc = names[effect],
  func = function()
    for _,player_entity in pairs( get_players() ) do
        local game_effect = GetGameEffectLoadTo( player_entity, effects[effect], false );
        if game_effect ~= nil then
            ComponentSetValue( game_effect, "frames", 1600 );
        end
    end
  end
})



insert_event({
    name = "Randomize wand",
    desc = "One of your wands has been randomized.",
    func = function()
		local inventory = get_inventory()

		if ( inventory ~= nil ) then
			local inventory_items = get_wands()
			
			if inventory_items ~= nil then
				local replaced_wand = inventory_items[Random(1,table.getn(inventory_items))]
				GameKillInventoryItem( get_player(), replaced_wand )
				local item_entity = EntityLoad( "data/entities/random_wand.xml" )
				EntityAddChild( inventory, item_entity )
			end	
		end		
    end
})




insert_event({
  name = "Random Perk",
  desc = "You got a free perk!",
  func = function()
    local perk = perk_list[math.random(1, #perk_list)]

    local x, y = get_player_pos()

    -- player might be dead
    if x ~= nil and y ~= nil then
        local perk_entity = perk_spawn(x, y - 8, perk.id)
        local players = get_players()
        if players == nil then return end
        for i, player in ipairs(players) do
            -- last argument set to false, so you dont kill others perks if triggered inside the shop
            perk_pickup(perk_entity, player, nil, true, false)
        end
    end
  end
})



insert_event({
    name = "Random Potion",
    desc = "Potion delivery!",
    func = function()
		local potion_material = ""
		if (Random(0, 100) <= 75) then
			if (Random(0, 100000) <= 50) then
				potion_material = "magic_liquid_hp_regeneration"
			elseif (Random(200, 100000) <= 250) then
				potion_material = "purifying_powder"
			else
				potion_material = random_from_array(potion_materials_magic)
			end
		else
			potion_material = random_from_array(potion_materials_standard)
		end
		local x, y = get_player_pos()
		-- just go ahead and assume cheatgui is installed
		local entity = EntityLoad("data/hax/potion_empty.xml", x, y)
		AddMaterialInventoryMaterial(entity, potion_material, 1000)
    end
})




insert_event({
  name = "Reflect melee",
  desc = "Temporarily reflect melee damage.",
  func = function()
    local player = get_player()
    local game_effect = GetGameEffectLoadTo(player, "MELEE_COUNTER", true);
    if game_effect ~= nil then 
        ComponentSetValue(game_effect, "caused_by_stains", 1);
        ComponentSetValue(game_effect, "frames",1200);
    end
  end
})



insert_event({
  name = "Shrooms",
  desc = "You are having a hell of a trip!",
  func = function()
	async(function()
		local player = get_player()
		local drugs = EntityGetComponent(player, "DrugEffectComponent")
		
		local drugs = EntityAddComponent( player, "DrugEffectComponent", 
		{ 
			--hallucinogen_amount = "10",
			stoned_amount = "6",
		})		
		
        wait(2400)
		ComponentSetValue(drugs, "stoned_amount", "0")
		EntityRemoveComponent(player, drugs)
    end)	
  end
})



insert_event({
  name = "Shuffle wand",
  desc = "One of your wands is now a shuffle wand.",
  func = function()
    local player = get_players()[1]
	
    local wands = get_wands()
    if wands == nil then return end
    local to_boost = table.getn(wands)

	local good_wands = {}
	
    for i = 1, to_boost do
        local ability = EntityGetAllComponents(wands[i])
        for _, c in ipairs(ability) do
            if ComponentGetTypeName(c) == "AbilityComponent" then
				if(tonumber(ComponentObjectGetValue(c, "gun_config", "shuffle_deck_when_empty")) == 0)then
					table.insert(good_wands, wands[i])
				end    
            end
        end
    end
	
	local chosen_wand = good_wands[Random(1, table.getn(good_wands))]
	ability = EntityGetAllComponents(chosen_wand)
    for _, c in ipairs(ability) do
		if ComponentGetTypeName(c) == "AbilityComponent" then
			ComponentObjectSetValue(c, "gun_config", "shuffle_deck_when_empty", tostring(1))
		end
	end
  end
})



insert_event({
  name = "Bomb the streamer",
  desc = "You better run!",
  func = function()
	for i = 1, 3 do
		spawn_item("data/entities/projectiles/bomb.xml", 5, 10)
	end
  end
})



insert_event({
  name = "Gotta go fast",
  desc = "You are temporarily sonic.",
  func = function()
	local player = get_players()[1]
	for i = 1, 2 do
		local game_effect = GetGameEffectLoadTo(player, "MOVEMENT_FASTER_2X", true);
		if game_effect ~= nil then 
			ComponentSetValue(game_effect, "frames", "1200"); 
		end
	end
  end
})



insert_event({
  name = "Thunder stones",
  desc = "Get away from the water!",
  func = function()
    for i = 1, 10 do
        spawn_item("data/entities/items/pickup/thunderstone.xml", 50, 250)
    end
  end
})



insert_event({
  name = "Unshuffle wand",
  desc = "One of your wands is now a non shuffle wand.",
  func = function()
    local player = get_players()[1]
	
    local wands = get_wands()
    if wands == nil then return end
    local to_boost = table.getn(wands)

	local good_wands = {}
	
    for i = 1, to_boost do
        local ability = EntityGetAllComponents(wands[i])
        for _, c in ipairs(ability) do
            if ComponentGetTypeName(c) == "AbilityComponent" then
				if(tonumber(ComponentObjectGetValue(c, "gun_config", "shuffle_deck_when_empty")) == 1)then
					table.insert(good_wands, wands[i])
				end    
            end
        end
    end
	
	local chosen_wand = good_wands[Random(1, table.getn(good_wands))]
	ability = EntityGetAllComponents(chosen_wand)
    for _, c in ipairs(ability) do
		if ComponentGetTypeName(c) == "AbilityComponent" then
			ComponentObjectSetValue(c, "gun_config", "shuffle_deck_when_empty", tostring(0))
		end
	end
  end
})



insert_event({
    name = "Upgrade wand",
    desc = "One of your wands has been upgraded.",
    func = function()
        local wands = get_wands()
        if wands == nil then return end
        local to_boost = wands[Random(1,table.getn(wands))]


        local ability = EntityGetAllComponents(to_boost)
        local boost_speed = Random(0, 1)
        local boost_recharge = Random(0, 1)
        local reduce_spread = Random(0, 1)
        local unshuffle = Random(0, 1)
        for _, c in ipairs(ability) do
            if ComponentGetTypeName(c) == "AbilityComponent" then
                local mana_max = tonumber(ComponentGetValue(c, "mana_max"))
                local mana_charge = tonumber(ComponentGetValue(c, "mana_charge_speed"))
                local deck_capacity = tonumber(ComponentObjectGetValue(c, "gun_config", "deck_capacity"))
                mana_max = mana_max + ((mana_max / 100) * Random(10, 20))
                mana_charge = mana_charge + ((mana_charge / 100) * Random(10, 20))
                deck_capacity = deck_capacity + Random(1, 3)
                ComponentSetValue(c, "mana_max", tostring(mana_max))
                ComponentSetValue(c, "mana_charge_speed", tostring(mana_charge))
                ComponentObjectSetValue(c, "gun_config", "deck_capacity", tostring(deck_capacity))
                if boost_recharge > 0 then
                    local cur_recharge = ComponentObjectGetValue(c, "gun_config", "reload_time") cur_recharge = cur_recharge - ((cur_recharge / 100) * Random(10, 20)) ComponentObjectSetValue(c, "gun_config", "reload_time", tostring(cur_recharge))
                end
                if boost_speed > 0 then
                    local cur_speed = ComponentObjectGetValue(c, "gunaction_config", "fire_rate_wait")
                    cur_speed = cur_speed - ((cur_speed / 100) * Random(10, 20))
                    ComponentObjectSetValue(c, "gunaction_config", "fire_rate_wait", tostring(cur_speed))
                end
                if reduce_spread > 0 then
                    local cur_spread = ComponentObjectGetValue(c, "gunaction_config", "spread_degrees")
                    cur_spread = cur_spread - ((cur_spread / 100) * Random(10, 20))
                    ComponentObjectSetValue(c, "gunaction_config", "spread_degrees", tostring(cur_spread))
                end
                if unshuffle > 0 then
                    ComponentObjectSetValue(c, "gun_config", "shuffle_deck_when_empty", tostring(0))
                end
            end
        end
    end
})




insert_event({
  name = "Whisky world",
  desc = "A alcoholic's dream!",
  func = function()
	spawn_item("data/entities/whisky.xml", 0, 0)
  end
})



insert_event({
  name = "Windy",
  desc = "Wind blows aways from you!",
  func = function()
	async(function()
		local player = get_player()
		local x, y = get_player_pos()
		local cid = EntityLoad( "data/entities/wind.xml", x, y )
		EntityAddChild( player, cid )
		wait(1800)
		EntityKill(cid)
	end)
  end
})



insert_event({
  name = "Worms Galore",
  desc = "Oh.. oh god...",
  func = function()
	  for i = 1, 10 do
		spawn_item("data/entities/animals/worm_tiny.xml", 100, 150)
	  end
  end
})



insert_event({
  name = "Zombie apocalypse",
  desc = "Waves of monsters.",
  func = function()
	async(function()
        local TEXT = {
            font="data/fonts/font_pixel_white.xml",
            string="10",
            offset_x="2",
            offset_y="26",
            alpha="0.50",
            scale_x="1",
            scale_y="1"
        }
        local timer = append_text(get_player(), TEXT)
        
        local tnt = Random(5, 9)
        local small_bombs = Random(10, 15)
        local bombs = Random(5, 10)

        for i=1, tonumber(TEXT.string) do
            wait(60)
            local num = tonumber(TEXT.string) - i
            ComponentSetValue( timer, "text", tostring(num) )
        end
        wait(60)
        EntityRemoveComponent(get_player(), timer)

        GameScreenshake( 200 )
		enemies = {"data/entities/animals/zombie_weak.xml","data/entities/animals/longleg.xml","data/entities/animals/worm.xml","data/entities/animals/shotgunner_weak.xml","data/entities/animals/miner_weak.xml"}
        for i = 1, small_bombs do
            spawn_item(enemies[Random(1,table.getn(enemies))], 60, 100, true)
        end

        TEXT.string = "10"
        timer = append_text(get_player(), TEXT)
        for i=1, tonumber(TEXT.string) do
            wait(60)
            local num = tonumber(TEXT.string) - i
            ComponentSetValue( timer, "text", tostring(num) )
        end
        wait(60)
        EntityRemoveComponent(get_player(), timer)

        GameScreenshake( 400 )
		pre_bosses = {"data/entities/animals/acidshooter_weak.xml","data/entities/animals/fireskull.xml","data/entities/animals/giantshooter_weak.xml","data/entities/animals/shotgunner_weak.xml"}

        for i = 1, bombs do
            spawn_item(pre_bosses[Random(1,table.getn(pre_bosses))], 60, 150, true)
        end

        TEXT.string = "10"
        timer = append_text(get_player(), TEXT)
        for i=1, tonumber(TEXT.string) do
            wait(60)
            local num = tonumber(TEXT.string) - i
            ComponentSetValue( timer, "text", tostring(num) )
        end
        wait(60)
        EntityRemoveComponent(get_player(), timer)
        GameScreenshake( 1000 )
		bosses = {"data/entities/animals/worm_big.xml","data/entities/animals/thundermage.xml","data/entities/animals/iceskull.xml","data/entities/animals/scavenger_grenade.xml"}
        for i = 1, 2 do
			spawn_item(bosses[Random(1,table.getn(bosses))], 80, 150, true)
		end
        TEXT.string = "10"
        timer = append_text(get_player(), TEXT)
        for i=1, tonumber(TEXT.string) do
            wait(60)
            local num = tonumber(TEXT.string) - i
            ComponentSetValue( timer, "text", tostring(num) )
        end
        wait(60)
        EntityRemoveComponent(get_player(), timer)
        GameScreenshake( 1000 )
		  for i = 1, 40 do
			spawn_item("data/entities/items/pickup/goldnugget.xml", 50, 100)
		  end
    end)
  end
})