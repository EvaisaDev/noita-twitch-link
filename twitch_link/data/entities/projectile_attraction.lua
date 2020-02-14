dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

SetRandomSeed( GameGetFrameNum(), x + y + entity_id )

local projectiles = EntityGetWithTag( "projectile" )
local direction_random = math.rad( Random( -30, 30 ) )

if ( #projectiles > 0 ) then
	for i,projectile_id in ipairs(projectiles) do	
		local px, py = EntityGetTransform( projectile_id )
		
		local distance = math.abs( x - px ) + math.abs( y - py )
		local distance_full = 50
		
		if ( distance < distance_full * 1.25 ) then
			distance = get_distance( px, py, x, y )
			direction = get_direction( px, py, x, y )
	
			if ( distance < distance_full ) then
				local velocitycomponents = EntityGetComponent( projectile_id, "VelocityComponent" )
				
				local gravity_percent = math.max(( distance_full - distance ) / distance_full, 0.01)
				local gravity_coeff = -96
				
				if ( velocitycomponents ~= nil ) then
					edit_component( projectile_id, "VelocityComponent", function(comp,vars)
						local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity", vel_x, vel_y)
						
						local offset_x = math.cos( direction + direction_random ) * ( gravity_coeff * gravity_percent )
						local offset_y = 0 - math.sin( direction + direction_random ) * ( gravity_coeff * gravity_percent )

						vel_x = vel_x + offset_x
						vel_y = vel_y + offset_y

						ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
					end)
				end
			end
		end
	end
end