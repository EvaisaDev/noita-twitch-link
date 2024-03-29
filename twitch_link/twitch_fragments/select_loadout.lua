function select_loadout(loadout)
    local init_check_flag = "start_loadouts_init"
    if GameHasFlagRun( init_check_flag ) then
        return
    end
    GameAddFlagRun( init_check_flag )

    player_entity = get_players()[1]
	--[[local inventory = nil
	
	local player_child_entities = EntityGetAllChildren( player_entity )
	if ( player_child_entities ~= nil ) then
		for i,child_entity in ipairs( player_child_entities ) do
			local child_entity_name = EntityGetName( child_entity )
			
			if ( child_entity_name == "inventory_quick" ) then
				inventory = child_entity
			end

		end
	end
	if ( inventory ~= nil ) then
		local inventory_items = EntityGetAllChildren( inventory )
		
		-- remove default items
		if inventory_items ~= nil then
			for i,item_entity in ipairs( inventory_items ) do
				GameKillInventoryItem( player_entity, item_entity )
			end
		end
	end]]
	
	local characterPlatformingData = EntityGetFirstComponent(player_entity, "CharacterPlatformingComponent")
	ComponentSetMetaCustom(characterPlatformingData, "velocity_max_x", "52")
	ComponentSetMetaCustom(characterPlatformingData, "velocity_min_x", "-52")
	ComponentSetMetaCustom(characterPlatformingData, "velocity_max_y", "350")
	ComponentSetMetaCustom(characterPlatformingData, "velocity_min_y", "-200")	
	
    local x,y = EntityGetTransform( player_entity );
    SetRandomSeed( GameGetFrameNum(), x + y + player_entity + 718 );

    local chosen_loadout = loadout
    local loadout_data = CONTENT[chosen_loadout].options;

    -- Add a random spellcaster type to the loadout name
    local spellcaster_types = gkbrkn_localization.loadout_spellcaster_types;
    local spellcaster_types_rnd = math.random( 1, #spellcaster_types );
    local loadout_name = loadout_data.name;
    loadout_name = string.gsub( loadout_name, "TYPE", spellcaster_types[spellcaster_types_rnd] );
	
    handle_loadout( player_entity, loadout_data );

    if loadout_data.callback ~= nil then
        loadout_data.callback( player_entity, inventory, cape );
    end
end