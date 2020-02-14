



insert_event({
  name = "Enemy bombers",
  desc = "Nearby enemies have bombs attached to them.",
  func = function()
    for _,player_entity in pairs( get_players() ) do
        local x, y = EntityGetTransform( player_entity );
        for _,entity in pairs( EntityGetInRadiusWithTag( x, y, 2000, "enemy" ) or {} ) do
            local x, y = EntityGetTransform( entity );
			if(EntityHasTag(entity, "drone_friendly"))then 
				return 
			end
           	local duckbomb = EntityLoad("data/entities/duckbomb.xml", x, y)
			EntityAddChild( entity, duckbomb )
        end
    end
  end
})