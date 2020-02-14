



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