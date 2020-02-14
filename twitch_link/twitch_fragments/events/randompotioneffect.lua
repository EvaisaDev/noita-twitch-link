



local potion_materials = {
	"water",
	"blood",
	"alcohol",
	"oil",
	"slime",
	"radioactive_liquid",
	"poison",
	"liquid_fire",
	"magic_liquid_movement_faster",
	"magic_liquid_worm_attractor",
	"magic_liquid_protection_all",
	"magic_liquid_mana_regeneration",
	"magic_liquid_teleportation",
	"magic_liquid_hp_regeneration",
	"magic_liquid_hp_regeneration_unstable",
	"magic_liquid_berserk",
	"magic_liquid_charm",
	"magic_liquid_invisibility"	
};

local potion_names = {
	"water",
	"blood",
	"whisky",
	"oil",
	"slime",
	"toxic sludge",
	"poison",
	"liquid fire",
	"Acceleratium",
	"Worm Pheromone",
	"Ambrosia",
	"Concentrated Mana",
	"Teleportatium",
	"Healthium",
	"Lively Concoction",
	"Berserkium",
	"Pheromone",
	"Invisibilium"
};

local index = math.random(1, table.getn(potion_materials))
insert_event({
  name = "Random Dowse",
  desc = "You got dowsed in "..potion_names[index].."!",
  func = function()
	local player = get_player()
	local liquid = EntityCreateNew();
	local x, y = get_player_pos();
	local material = potion_materials[index];
	EntitySetTransform(liquid, x, y - 10, 0, 1, 1);
	EntityAddComponent(liquid, "LuaComponent", {
		script_source_file="data/entities/followplayerother.lua",
		execute_on_added="1",
		execute_every_n_frame="1",
		execute_times="-1",
	})
	EntityAddComponent(liquid, "ParticleEmitterComponent", {
		emitted_material_name=material,
		create_real_particles="1",
		lifetime_min="8",
		lifetime_max="15",
		count_min="1",
		count_max="1",
		render_on_grid="1",
		fade_based_on_lifetime="1",
		cosmetic_force_create="0",
		airflow_force="0.251",
		airflow_time="1.01",
		airflow_scale="0.05",
		emission_interval_min_frames="1",
		emission_interval_max_frames="1",
		emit_cosmetic_particles="0",
		image_animation_file="data/gfx/circle_10.png",
		image_animation_speed="1",
		image_animation_loop="0",
		image_animation_raytrace_from_center="1",
		collide_with_gas_and_fire="0",
		set_magic_creation="1",
		is_emitting="1",
	});
	EntityAddComponent(liquid, "LifetimeComponent", {
		lifetime="120",
	});	
  end
})