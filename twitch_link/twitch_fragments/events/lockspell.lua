



function is_wand_always_cast_valid( wand )
    local children = EntityGetAllChildren( wand ) or {};
    for i,v in ipairs( children ) do
        local components = EntityGetAllComponents( v );
        local has_a_valid_spell = false;
        for _,component in pairs(components) do
            if ComponentGetValue( component, "permanently_attached" ) == "0" and ComponentGetValue( component, "is_frozen" ) == "0" then
                has_a_valid_spell = true;
                break;
            end
        end
        if has_a_valid_spell then
            return true;
        end
    end
    return false;
end

insert_event({
  name = "Lock spell",
  desc = "One of your spells was locked to a wand.",
  func = function()
  	local player = get_player()
	local children = EntityGetAllChildren( player );
	for key,child in pairs( children ) do
		if EntityGetName( child ) == "inventory_quick" then
			wands = EntityGetChildrenWithTag( child, "wand" );
			break;
		end
	end
	if #wands > 0 then
		local filtered_wands = {};
		for _,wand in pairs(wands) do
			if is_wand_always_cast_valid( wand ) then
				table.insert( filtered_wands, wand );
			end
		end
		if #filtered_wands > 0 then
			wands = filtered_wands;
			local inventory2 = EntityGetFirstComponent( player, "Inventory2Component" );
			local active_item = tonumber( ComponentGetValue( inventory2, "mActiveItem" ) );
			if base_wand == nil then
				base_wand =  random_from_array( wands );
			end
		end
	end
	if base_wand ~= nil then
		local children = EntityGetAllChildren( base_wand );
		local ability_component = WandGetAbilityComponent( base_wand );
			if ability_component ~= nil then
			local deck_capacity = tonumber( ComponentObjectGetValue( ability_component, "gun_config", "deck_capacity" ) );
			ComponentObjectSetValue( ability_component, "gun_config", "deck_capacity", tostring( deck_capacity + 1 ) );
		end

		local actions = {};
		for i,v in ipairs( children ) do
			local components = EntityGetAllComponents( v );
			for _,component in pairs(components) do
				if ComponentGetValue( component, "permanently_attached" ) == "0" and ComponentGetValue( component, "is_frozen" ) == "0" then
					table.insert( actions, component );
				end
			end
		end
		if #actions > 0 then
			local to_attach = random_from_array( actions );
			if to_attach ~= nil then
				ComponentSetValue( to_attach, "is_frozen", "1" );
			end
		end
	end
  end
})