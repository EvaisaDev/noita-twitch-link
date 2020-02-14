dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/perk_list.lua" )
dofile_once( "mods/twitch_link/config.lua" )

local get_perk_flag_name = function( perk_id )
	return "PERK_" .. perk_id
end

old_perk_spawn = perk_spawn
function perk_spawn( x, y, perk_id )
	if(perk_vote_enabled == "true")then
		local perk_data = get_perk_with_id( perk_list, perk_id )
		if ( perk_data == nil ) then
			print_error( "spawn_perk( perk_id ) called with'" .. perk_id .. "' - no perk with such id exists." )
			return
		end

		print( "spawn_perk " .. tostring( perk_id ) .. " " .. tostring( x ) .. " " .. tostring( y ) )

		---
		local entity_id = EntityLoad( "data/entities/items/pickup/perk.xml", x, y )
		if ( entity_id == nil ) then
			return
		end

		EntityAddComponent( entity_id, "UIInfoComponent", 
		{ 
			name = perk_data.ui_name,
		} )

		EntityAddComponent( entity_id, "SpriteOffsetAnimatorComponent", 
		{ 
		  sprite_id="-1" ,
		  x_amount="0" ,
		  x_phase="0" ,
		  x_phase_offset="0" ,
		  x_speed="0" ,
		  y_amount="2" ,
		  y_speed="3",
		} )

		EntityAddComponent( entity_id, "VariableStorageComponent", 
		{ 
			name = "perk_id",
			value_string = perk_data.id,
		} )

		return entity_id
	else
		return old_perk_spawn( x, y, perk_id )
	end
end

old_perk_spawn_many = perk_spawn_many
function perk_spawn_many( x, y )
	if(perk_vote_enabled == "true")then
		local perk_count = 3
		
		local count = perk_count
		local width = 60
		local item_width = width / count

		local perks = perk_get_spawn_order()

		for i=1,count do
			local next_perk_index = tonumber( GlobalsGetValue( "TEMPLE_NEXT_PERK_INDEX", "1" ) )
			local perk_data = get_perk_with_id( perk_list, perks[next_perk_index] )
			
			next_perk_index = next_perk_index + 1
			if next_perk_index > #perks then
				next_perk_index = 1
			end
			GlobalsSetValue( "TEMPLE_NEXT_PERK_INDEX", tostring(next_perk_index) )

			GameAddFlagRun( get_perk_flag_name(perk_data.id) )
			perk_spawn( x + (i-0.5)*item_width, y, perks[next_perk_index] )
		end
	else
		old_perk_spawn_many( x, y )
	end
end

local old_reroll_perks = perk_reroll_perks
function perk_reroll_perks()
	if(perk_vote_enabled == "true")then
		if(GameHasFlagRun("perk_vote"))then
			local perk_reroll_count = tonumber( GlobalsGetValue( "TEMPLE_PERK_REROLL_COUNT", "0" ) )
			perk_reroll_count = perk_reroll_count + 1
			GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", tostring( perk_reroll_count ) )
			--GameAddFlagRun( "skip_vote" )
			--GameAddFlagRun( "perk_vote" )	
			GameAddFlagRun( "reroll_vote" )
		end
	else
		old_reroll_perks()
	end
end