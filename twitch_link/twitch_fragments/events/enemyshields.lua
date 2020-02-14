



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