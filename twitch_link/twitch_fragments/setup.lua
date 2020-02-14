twitch_display_lines = {}
gui = gui or GuiCreate()
xpos = xpos or 80
ypos = ypos or 80
dofile_once( "mods/twitch_link/config.lua" )
randomOnNoVotes = random_on_no_votes
is_perk_vote = false
users = {}
spawned_users = {}
spawned_times = {}
spawned_users_boss = {}
spawned_times_boss = {}
event_timeout = {}
perk_count = 3
perk_id_table = {}
event_counter = {}
math.randomseed(os.time())
math.random()

function tablefind(tab,el)
	for index, value in ipairs(tab) do
		if value == el then
			return index
		end
	end
	return nil
end

local function tableshuffle(t)
    local rand = math.random 
    assert(t, "table.shuffle() expected a table, got nil")
    local iterations = #t
    local j
    
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

function tablehas(tab,el)
	for index, value in ipairs(tab) do
		if value == el then
			return true
		end
	end
	return false
end


function draw_twitch_display()
	if(perk_vote_enabled == "true")then
		local x, y = get_player_pos()

		local perks = EntityGetInRadiusWithTag( x, y, 100, "perk" )
		
		if(perks ~= nil)then
			if(table.getn(perks) > 2)then
				perk_id_table = {}
				for k,v in pairs(perks) do
					local components = EntityGetComponent( v, "VariableStorageComponent" )

					if( components ~= nil ) then
						for key,comp_id in pairs(components) do 
							local var_name = ComponentGetValue( comp_id, "name" )		
							if(var_name == "perk_id")then
								local perk_id = ComponentGetValue( comp_id, "value_string" )
								table.insert(perk_id_table, perk_id)
							end
						end
					end
					--[[local LuaComponents = EntityGetComponent( v, "LuaComponent")
					local ItemComponents = EntityGetComponent( v, "ItemComponent")
					for index, value in ipairs(LuaComponents)do
						EntityRemoveComponent( v, value )
					end
					for index, value in ipairs(ItemComponents)do
						EntityRemoveComponent( v, value )
					end				
					perk_count = table.getn(perks)
					GlobalsSetValue( "perk_count", table.getn(perks) )
					print(table.getn(perk_id_table))
					EntityRemoveTag(v, "perk")
					EntityAddTag(v, "dummy_perk")]]
					EntityKill(v)
				end	
				if GameHasFlagRun( "perk_vote" ) then
					return
				end
				GamePrint("Perks Detected!")
				GameAddFlagRun( "perk_vote" )				
			end
		end
	end
	if(elite_names == "true" and (GameGetFrameNum() > 8000))then
		if(users[1] ~= nil)then
			for k, v in ipairs(spawned_users) do
				if(os.difftime(os.time(),spawned_times[k]) > elite_name_timeout and elite_only_once == "false")then
					table.remove(spawned_users, k)
					table.remove(spawned_times, k)
				else
					local remove_user = tablefind(users,v)
					if(remove_user ~= nil)then
						table.remove(users, remove_user)
					end
				end
			end
			if(math.random(0,100) <= elite_chance)then
				local user = users[math.random(1, table.getn(users))]
			
				if(user ~= nil)then
				
					table.insert(spawned_users, user)
					table.insert(spawned_times, os.time())

					local x, y = get_player_pos()
					local elites = {}
					local the_elites = EntityGetInRadiusWithTag( x, y, 200, "gkbrkn_champions" )
					for k, v in pairs(the_elites) do
						--print(v)
						if(EntityHasTag(v, "has_nametag") == false)then
							table.insert(elites, v)
						end
					end
					if(elites[1] ~= nil)then
						local random_elite = elites[math.random(1, table.getn(elites))]
						--print(table.getn(elites))
						local TEXT = {
							font="data/fonts/font_pixel_white.xml",
							string="",
							offset_x="0",
							offset_y="26",
							alpha="0.80",
							scale_x="0.7",
							scale_y="0.7"
						}
						TEXT.string = user
						nametag = append_text(random_elite, TEXT)
						print(user.." has appeared in the world as a champion!")
						EntityAddTag( random_elite, "has_nametag")
					end
				end
			else
				local x, y = get_player_pos()
				local elites = {}
				local the_elites = EntityGetInRadiusWithTag( x, y, 200, "gkbrkn_champions" )
				for k, v in pairs(the_elites) do
					if(EntityHasTag(v, "has_nametag") == false)then
						table.insert(elites, v)
					end
				end
				local random_elite = elites[math.random(1, table.getn(elites))]		
				EntityAddTag( random_elite, "has_nametag")
			end
		end
	end
	if(miniboss_names == "true" and (GameGetFrameNum() > 8000))then
		if(users[1] ~= nil)then
			for k, v in ipairs(spawned_users_boss) do
				if(os.difftime(os.time(),spawned_times_boss[k]) > miniboss_name_timeout and miniboss_only_once == "false")then
					table.remove(spawned_users_boss, k)
					table.remove(spawned_times_boss, k)
				else
					local remove_user = tablefind(users,v)
					if(remove_user ~= nil)then
						table.remove(users, remove_user)
					end
				end
			end
			if(math.random(0,100) <= miniboss_chance)then
				local user = users[math.random(1, table.getn(users))]
			
				if(user ~= nil)then
				
					table.insert(spawned_users_boss, user)
					table.insert(spawned_times_boss, os.time())

					local x, y = get_player_pos()
					local elites = {}
					local the_elites = EntityGetInRadiusWithTag( x, y, 200, "gkbrkn_mini_boss" )
					for k, v in pairs(the_elites) do
						--print(v)
						if(EntityHasTag(v, "has_nametag") == false)then
							table.insert(elites, v)
						end
					end
					if(elites[1] ~= nil)then
						local random_elite = elites[math.random(1, table.getn(elites))]
						--print(table.getn(elites))
						local TEXT = {
							font="data/fonts/font_pixel_white.xml",
							string="",
							offset_x="0",
							offset_y="26",
							alpha="0.80",
							scale_x="0.7",
							scale_y="0.7"
						}
						TEXT.string = user
						nametag = append_text(random_elite, TEXT)
						print(user.." has appeared in the world as a mini boss!")
						EntityAddTag( random_elite, "has_nametag")
					end
				end
			else
				local x, y = get_player_pos()
				local elites = {}
				local the_elites = EntityGetInRadiusWithTag( x, y, 200, "gkbrkn_mini_boss" )
				for k, v in pairs(the_elites) do
					if(EntityHasTag(v, "has_nametag") == false)then
						table.insert(elites, v)
					end
				end
				local random_elite = elites[math.random(1, table.getn(elites))]		
				EntityAddTag( random_elite, "has_nametag")
			end
		end
	end	
  GuiStartFrame( gui )
  GuiLayoutBeginVertical( gui, xpos, ypos )
  for idx, line in ipairs(twitch_display_lines) do
    GuiText(gui, 0, 0, line)
  end
  GuiLayoutEnd( gui )
end

function set_countdown(timeleft)
  twitch_display_lines = {"Next vote: " .. timeleft .. "s"}
end

outcomes = {}
function clear_outcomes()
  outcomes = {}
end

function clear_display()
  twitch_display_lines = {}
end

function set_perk_vote()
  is_perk_vote = true
end

function add_outcome(outcome)
    table.insert(outcomes, outcome)
end

function insert_event(outcome)
	if GameHasFlagRun( "perk_vote" ) then
		if(outcome.perk ~= nil)then
			--perk_id
			--print("perk count: "..tostring(table.getn(perk_id_table)))
			--for i = 1, table.getn(perk_id_table) do
				--local v = perk_id_table[i]
				--print(tostring(v))
				--print(tostring(outcome.perk_id))
				--if(v == outcome.perk_id)then
			print(" ["..tostring(table.getn(outcome_generators) + 1).."] "..outcome.name.." has been added to the event list.")  
			table.insert(outcome_generators, outcome)
			
				--end
			--end
		end
	elseif(outcome.loadout ~= nil)then
		print(" ["..tostring(table.getn(outcome_generators) + 1).."] "..outcome.name.." has been added to the event list.")  
		table.insert(outcome_generators, outcome)	
	else	
		print(" ["..tostring(table.getn(outcome_generators) + 1).."] "..outcome.name.." has been added to the event list.")  
		table.insert(outcome_generators, outcome)	
		event_counter[outcome.name] = 1
	end
  --[[
  table.insert(outcome_generators, function()
    return outcome
  end)  
  ]]
end

function clear_events()
	for k in pairs (outcome_generators) do
		outcome_generators[k] = nil
	end
end

function get_player()
	local player = get_players()[1]
	return player
end

function add_user(username)
	print(tostring(username).." has been added to viewer list!")
	table.insert(users, username)
end

local function urand(mag)
  return math.floor((math.random()*2.0 - 1.0)*mag)
end

function get_wands()
    local childs = EntityGetAllChildren(get_player())
    local inven = nil
    if childs ~= nil then
        for _, child in ipairs(childs) do
            if EntityGetName(child) == "inventory_quick" then
                inven = child
            end
        end
    end
    local wands = {}
    if inven ~= nil then
        local items = EntityGetAllChildren(inven)
        for _, child_item in ipairs(items) do
            if EntityHasTag(child_item, "wand") then
                wands[_] = child_item
            end
        end
    end

    return wands or nil
end

function get_wand_spells(id)
    local childs = EntityGetAllChildren(id)
    local inven = {}
    if childs ~= nil then
        for _, child in ipairs(childs) do
            if EntityHasTag(child, "card_action") then
                inven[_] = child
            end
        end
    end
    return inven or nil
end
function
 append_text(entity, text)
	text.offset_x = string.len(text.string)*1.9
    local component = EntityAddComponent( entity, "SpriteComponent", {
        _tags = "enabled_in_world",
        image_file = text.font or "data/fonts/font_pixel_white.xml",
        emissive = "1",
        is_text_sprite = "1",
        offset_x = text.offset_x or "0",
        offset_y = text.offset_y or "0",
        alpha = text.alpha or "1",
        update_transform = "1",
        update_transform_rotation = "0",
        text = text.string or "",
        has_special_scale = "1",
        special_scale_x = text.scale_x or "1",
        special_scale_y = text.scale_y or "1",
        z_index = "-9000"
    } )
    return component
end

-- 0 to not limit axis, -1 to limit to negative values, 1 to limit to positive values
local function generate_value_in_range(max_range, min_range, limit_axis)
  local range = (max_range or 0) - (min_range or 0)
  if (limit_axis or 0) == 0 then
    limit_axis = math.random(0, 1) == 0 and 1 or -1
  end

  return (math.random(0, range) + (min_range or 0)) * limit_axis
end

function twiddle_health(f)
    local damagemodels = EntityGetComponent(get_player(), "DamageModelComponent")
    if (damagemodels ~= nil) then
        for i, damagemodel in ipairs(damagemodels) do
            local max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp"))
            local cur_hp = tonumber(ComponentGetValue(damagemodel, "hp"))
            local new_cur, new_max = f(cur_hp, max_hp)
            ComponentSetValue(damagemodel, "max_hp", new_max)
            ComponentSetValue(damagemodel, "hp", new_cur)
        end
    end
end

function get_inventory()
	local player_child_entities = EntityGetAllChildren( get_player() )
	if ( player_child_entities ~= nil ) then
		for i,child_entity in ipairs( player_child_entities ) do
			local child_entity_name = EntityGetName( child_entity )
			
			if ( child_entity_name == "inventory_quick" ) then
				return child_entity
			end
		end
	end
	return nil
end


function spawn_item_in_range(path, min_x_range, max_x_range, min_y_range, max_y_range, limit_x_axis, limit_y_axis, spawn_blackhole)
  local x, y = get_player_pos()
  local dx = generate_value_in_range(max_x_range, min_x_range, limit_x_axis)
  local dy = generate_value_in_range(max_y_range, min_y_range, limit_y_axis)
  
  return EntityLoad(path, x + dx, y + dy)
end
--[[
function spawn_item(path, min_range, max_range, spawn_blackhole)
  local x, y = get_player_pos()
  
  local angle = math.random()*math.pi*2;
  
  local dx = math.cos(angle)*math.random(min_range, max_range);
  local dy = math.sin(angle)*math.random(min_range, max_range);
  
  if(spawn_blackhole)then
	EntityLoad("data/entities/short_blackhole.xml", x + dx, y + dy)
  end
  
  return EntityLoad(path, x + dx, y + dy)
end
]]



function spawn_item(entity_path, min_range, max_range, black_hole, ignore_bad_spawns)
	ignore_bad_spawns = ignore_bad_spawns or false
	black_hole = black_hole or false
	if(not ignore_bad_spawns)then
        local x, y = get_player_pos()
		
		local spawn_points = {}
		
		local count = 0
		
		for i = 1, 100 do
		
			local angle = math.random()*math.pi*2;
		  
			local dx = x + (math.cos(angle)*math.random(min_range, max_range));
			local dy = y + (math.sin(angle)*math.random(min_range, max_range));		
			
			local rhit, rx, ry = Raytrace(dx - 2, dy - 2, dx + 2, dy + 2)
			
			
			
			if(rhit) then 
				--DEBUG_MARK( dx, dy, "bad_spawn_point",0, 0, 1 )
			else

				table.insert(spawn_points, {
					x = dx,
					y = dy,
				})
			end
		end

		local spawn_index = math.random(1, table.getn(spawn_points))
		
		local spawn_x = spawn_points[spawn_index].x
		local spawn_y = spawn_points[spawn_index].y
		
		if(spawn_x == nil)then
			local angle = math.random()*math.pi*2;
		  
			local dx = x + (math.cos(angle)*math.random(min_range, max_range));
			local dy = y + (math.sin(angle)*math.random(min_range, max_range));		
			
			EntityLoad("data/entities/short_blackhole.xml", dx, dy)
			
			return EntityLoad(entity_path, dx, dy)
		else
			if black_hole then
				EntityLoad("data/entities/short_blackhole.xml", spawn_x, spawn_y)
			end
			
			return EntityLoad(entity_path, spawn_x, spawn_y)
		end
	else
		local x, y = get_player_pos()
		  
		local angle = math.random()*math.pi*2;
		  
		local dx = math.cos(angle)*math.random(min_range, max_range);
		local dy = math.sin(angle)*math.random(min_range, max_range);
		  
		if(black_hole)then
			EntityLoad("data/entities/short_blackhole.xml", x + dx, y + dy)
		end
		  
		return EntityLoad(entity_path, x + dx, y + dy)	
	end
end

--[[
function spawn_item(entity_path, min_dist, max_dist, black_hole, from_above, callback)
    async(function()
        local x, y = get_player_pos()
        y = y + 110
        local dx = generate_value_in_range(max_dist, min_dist, 0)
		
        local dummy = EntityLoad("data/entities/dummy.xml", x + dx, y)
        wait(20)
        local dummy_x, dummy_y = EntityGetTransform(dummy)

        EntityKill(dummy)
        if from_above then
            local rhit, rx, ry = Raytrace(dummy_x, dummy_y - 30, dummy_x,
                                          dummy_y - 190)
            if rhit then
                dummy_y = ry + 20
            else
                dummy_y = dummy_y - 170
            end
        end
        if black_hole then
            EntityLoad("data/entities/short_blackhole.xml", dummy_x,
                       dummy_y)
        end
        local eid = EntityLoad(entity_path, dummy_x, dummy_y)
        if callback then callback(eid); end
    end)
end
]]
--[[
function spawn_item(path, min_range, max_range, spawn_blackhole)
  return spawn_item_in_range(path, min_range, max_range, min_range, max_range, 0, 0, spawn_blackhole)
end
]]

function debug_print_table( table_to_print, table_depth, parent_table )
	local table_depth_ = table_depth or 1
	local parent_table_ = parent_table or "TABLE"
	local result = parent_table_ .. ": "
	
	if (table_depth_ > 1) then
		for i=1,table_depth_ - 1 do
			result = result .. " - "
		end
	end
	
	local subtables = {}
	
	if (table_to_print ~= nil) and (tostring(type(table_to_print)) == "table") then
		for i,v in pairs(table_to_print) do
			result = result .. tostring(i) .. "(" .. tostring(v) .. "), "
			
			if (tostring(type(v)) == "table") then
				table.insert(subtables, {i, v})
			end
		end
	end
	
	print( result )
	
	for i,v in ipairs( subtables ) do
		debug_print_table( v[2], table_depth_ + 1, "subtable " .. v[1] )
	end
end

function tablecheck(tab,el)
	for index, value in pairs(tab) do
		if value == el then
			return index
		end
	end
	return nil
end


function lowest_keyval_pairs(n, tab)
    local lowest_keys = {}
    local lowest_vals = {}

    for k, v in pairs(tab) do
        if #lowest_vals < n then
            table.insert(lowest_keys, k)
            table.insert(lowest_vals, v)
        else
            local replace_largest = false
            local largest_idx = 1
            local largest_val = lowest_vals[1]
            for li, lv in ipairs(lowest_vals) do
                if lv > largest_val then
                    largest_idx = li
                    largest_val = lowest_vals[li]
                end
                if v < lv then
                    replace_largest = true
                end
            end
            if replace_largest then
                lowest_keys[largest_idx] = k
                lowest_vals[largest_idx] = v
            end
        end
    end

    return lowest_keys, lowest_vals
end



outcome_generators = {}


function draw_outcomes(n)
  local candidates = {}
  local good_generators = {}

  for idx, generator in ipairs(outcome_generators) do
	if(event_timeout[generator.name] ~= nil)then
		if(event_timeout[generator.name] > 0)then
			event_timeout[generator.name] = event_timeout[generator.name] - 1
		else
			event_timeout[generator.name] = nil
			print(generator.name.." has been readded to the event list.")
			table.insert(good_generators, generator)
		end
	else	
		table.insert(good_generators, generator)
	end
  end
	local super_generators = {}
	tableshuffle(event_counter)
    local low_keys, low_vals = lowest_keyval_pairs(6, event_counter)
	if(good_generators[1] ~= nil)then
		tableshuffle(good_generators)
		for k, v in pairs(good_generators)do
			if(tablehas(low_keys,v.name))then
				table.insert(super_generators, v)
				print("Candidate = "..v.name)
			end
		end  
	end

	for i, v in ipairs(low_keys) do
		print(tostring(v) .. " = " .. tostring(low_vals[i]))
	end
	
	
  for i = 1, n do
	if(good_generators[1] ~= nil)then
		tableshuffle(good_generators)
		if(low_keys[3] ~= nil and good_generators[1].loadout == nil and good_generators[1].perk == nil and event_vote_priority == "true")then
			print("Got low keys")

						
			local index = math.random(1,table.getn(super_generators))
			local candidate = super_generators[index]
			print("Super generator count = "..table.getn(super_generators))
			table.remove(super_generators, index)
			if(candidate.loadout == nil and candidate.perk == nil)then
				event_counter[candidate.name] = event_counter[candidate.name] + 1
			end
			event_timeout[candidate.name] = event_vote_timeout_rounds
			table.insert(candidates, candidate)
	
		else
			local index = math.random(1,table.getn(good_generators))
			local candidate = good_generators[index]
			print("Good generator count = "..table.getn(good_generators))
			table.remove(good_generators, index)
			if(candidate.loadout == nil and candidate.perk == nil)then
				event_counter[candidate.name] = event_counter[candidate.name] + 1
			end
			event_timeout[candidate.name] = event_vote_timeout_rounds
			table.insert(candidates, candidate)
		end
	else
		for idx, generator in ipairs(outcome_generators) do
			table.insert(good_generators, generator)
		end
		
		local index = math.random(1,table.getn(good_generators))
		local candidate = good_generators[index]
		table.remove(good_generators, index)
		if(candidate.loadout == nil and candidate.perk == nil)then
			event_counter[candidate.name] = event_counter[candidate.name] + 1
		end
		event_timeout[candidate.name] = event_vote_timeout_rounds
		table.insert(candidates, candidate)
	end
  end  
  
  clear_outcomes()
  for idx = 1, n do
	if(candidates[idx] ~= nil)then
		add_outcome(candidates[idx])
	end
  end
end

function clear_display_remove_flag()
	clear_outcomes()
	clear_display()
end

function update_outcome_display(vote_time_left)

  twitch_display_lines = {"Voting ends: " .. vote_time_left}
  local init_check_flag = "start_loadouts_init"
  if(not GameHasFlagRun( init_check_flag ))then
	twitch_display_lines = {"Pick a loadout: " .. vote_time_left}
  end
  local init_check_flag = "perk_vote"
  if(GameHasFlagRun( init_check_flag ))then
	twitch_display_lines = {"Pick a perk: " .. vote_time_left}
  else
	if(is_perk_vote)then
		clear_outcomes()
		clear_display()	
		is_perk_vote = false
		return
	end
  end
  for idx, outcome in ipairs(outcomes) do
    table.insert(
      twitch_display_lines,
      ("%d> %s (%d)"):format(idx, outcome.name, outcome.votes) 
    )
  end
end

function set_votes(outcome_votes)
  for idx, outcome in ipairs(outcomes) do
    outcome.votes = outcome_votes[idx] or 0
  end
end

function do_winner()
  local best_outcome = outcomes[1]
  local highest_number = 0
  local possible_outcomes = {}
  if(get_player ~= nil)then
	  for idx, outcome in ipairs(outcomes) do
		if outcome.votes > highest_number then
			highest_number = outcome.votes
		end
	  end
	  for idx, outcome in ipairs(outcomes) do
		if outcome.votes == highest_number then
			table.insert(possible_outcomes, outcome)
		end
	  end  
	  best_outcome = possible_outcomes[math.random(1,table.getn(possible_outcomes))];
	  
	  if best_outcome.votes > 0 then
		GamePrintImportant(best_outcome.name, best_outcome.desc or "you voted for this")
		best_outcome:func()
	  elseif (randomOnNoVotes == "true") then
		local random_outcome = outcomes[math.random(1, table.getn(outcomes))]
		GamePrintImportant(random_outcome.name, random_outcome.desc or "this was randomly picked.")
		random_outcome:func()
	  else
		GamePrintImportant("Nobody voted!", "Remember to vote!")
	  end
  else  
	  GamePrintImportant("Player entity is missing!", "Presumably dead!")
  end
	if GameHasFlagRun( "perk_vote" ) then
		local chance = tonumber( GlobalsGetValue( "TEMPLE_PERK_DESTROY_CHANCE", "100" ) )
		if(math.random(1, 100) > chance)then
			GameAddFlagRun( "reroll_vote" )
		else
			GameAddFlagRun( "skip_vote" )
		end
	end
  clear_outcomes()
  clear_display()
end

add_persistent_func("twitch_gui", draw_twitch_display)