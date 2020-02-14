dofile( "mods/twitch_link/files/loadouts.lua" )
dofile( "data/scripts/perks/perk.lua" )
dofile( "data/scripts/lib/utilities.lua" )

function select_loadout(loadout)
	local init_check_flag = "start_loadouts_init"
	if GameHasFlagRun( init_check_flag ) then
		return
	end
	GameAddFlagRun( init_check_flag )

	player_entity = get_players()[1]
	
	local characterPlatformingData = EntityGetFirstComponent(player_entity, "CharacterPlatformingComponent")
	ComponentSetMetaCustom(characterPlatformingData, "velocity_max_x", "52")
	ComponentSetMetaCustom(characterPlatformingData, "velocity_min_x", "-52")
	ComponentSetMetaCustom(characterPlatformingData, "velocity_max_y", "350")
	ComponentSetMetaCustom(characterPlatformingData, "velocity_min_y", "-200")
	-- ---
	local x,y = EntityGetTransform( player_entity )
	SetRandomSeed( x + 344, y - 523 )

	local loadout_rnd = loadout
	local loadout_choice = loadout_list[loadout_rnd]

	local loadout_name = loadout_choice.name

	-- Add a random spellcaster type to the loadout name
	local spellcaster_types = { "wizard", "warlock", "witch", "mage", "druid", "magician", "shaman", "magus", "sorcerer", "lich" }
	local spellcaster_types_rnd = Random( 1, #spellcaster_types )
	loadout_name = string.gsub( loadout_name, "TYPE", spellcaster_types[spellcaster_types_rnd] )

	local inventory = nil
	local cape = nil
	local player_arm = nil

	local loadout_cape_color = loadout_choice.cape_color
	local loadout_cape_color_edge = loadout_choice.cape_color_edge

	-- find the quick inventory, player cape and arm
	local player_child_entities = EntityGetAllChildren( player_entity )
	if ( player_child_entities ~= nil ) then
		for i,child_entity in ipairs( player_child_entities ) do
			local child_entity_name = EntityGetName( child_entity )
			
			if ( child_entity_name == "inventory_quick" ) then
				inventory = child_entity
			end
			
			if ( child_entity_name == "cape" ) then
				cape = child_entity
			end
			
			if ( child_entity_name == "arm_r" ) then
				player_arm = child_entity
			end
		end
	end

	-- set player cape colour (since we're changing multiple variables, we'll use the edit_component() utility)
	edit_component( cape, "VerletPhysicsComponent", function(comp,vars) 
		vars.cloth_color = loadout_cape_color
		vars.cloth_color_edge = loadout_cape_color_edge
	end)


	-- set inventory contents
	if ( inventory ~= nil ) then
		local inventory_items = EntityGetAllChildren( inventory )
		
		-- remove default items
		if inventory_items ~= nil then
			for i,item_entity in ipairs( inventory_items ) do
				GameKillInventoryItem( player_entity, item_entity )
			end
		end

		-- add loadout items
		local loadout_items = loadout_choice.items
		for item_id,loadout_item in ipairs( loadout_items ) do
			if ( tostring( type( loadout_item ) ) ~= "table" ) then
				local item_entity = EntityLoad( loadout_item )
				EntityAddChild( inventory, item_entity )
			else
				local amount = loadout_item.amount or 1
				
				for i=1,amount do
					local item_option = ""
					
					if ( loadout_item.options ~= nil ) then
						local item_options = loadout_item.options
						local item_options_rnd = Random( 1, #item_options )
						
						item_option = item_options[item_options_rnd]
					else
						item_option = loadout_item[1]
					end
					
					local item_entity = EntityLoad( item_option )
					if item_entity then
						EntityAddChild( inventory, item_entity )
					end
				end
			end
		end
	end

	-- spawn two perks
	if ( loadout_choice.perks ~= nil ) then
		for i,perk_name in ipairs( loadout_choice.perks ) do
			local perk_entity = perk_spawn( x, y, perk_name )
			if ( perk_entity ~= nil ) then
				perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false )
			end
		end	
	end
end