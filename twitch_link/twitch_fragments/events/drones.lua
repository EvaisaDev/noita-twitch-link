



insert_event({
  name = "Drone party",
  desc = "Have some drones!",
  func = function()
	drones = {"mods/risk_of_drones/files/dronemod/evaisa/spells/entities/attack_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/basic_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/missile_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/flame_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/health_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/equipment_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/laser_drone.xml","mods/risk_of_drones/files/dronemod/evaisa/spells/entities/health_drone2.xml" }       
	for i = 1, 3 do
		spawn_item(drones[math.random(1,table.getn(drones))], 5, 5, false, true)
	end
  end
})