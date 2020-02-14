twitch_display_lines = {}
gui = gui or GuiCreate()
xpos = xpos or 80
ypos = ypos or 80
dofile_once( "mods/twitch_link/config.lua" )
randomOnNoVotes = random_on_no_votes
is_perk_vote = false
math.randomseed(os.time())

function draw_twitch_display()
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

function add_outcome(outcome)
  table.insert(outcomes, outcome)
end

function insert_event(outcome)
  table.insert(outcome_generators, function()
    return outcome
  end)
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
    limit_axis = Random(0, 1) == 0 and 1 or -1
  end

  return (Random(0, range) + (min_range or 0)) * limit_axis
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

function spawn_item(path, min_range, max_range, spawn_blackhole)
  local x, y = get_player_pos()
  
  local angle = Random()*math.pi*2;
  
  local dx = math.cos(angle)*Random(min_range, max_range);
  local dy = math.sin(angle)*Random(min_range, max_range);
  
  if(spawn_blackhole)then
	EntityLoad("data/entities/short_blackhole.xml", x + dx, y + dy)
  end
  
  return EntityLoad(path, x + dx, y + dy)
end



--[[
function spawn_item(path, min_range, max_range, spawn_blackhole)
  return spawn_item_in_range(path, min_range, max_range, min_range, max_range, 0, 0, spawn_blackhole)
end
]]
outcome_generators = {}


function draw_outcomes(n)
  local candidates = {}
  for idx, generator in ipairs(outcome_generators) do
    candidates[idx] = {math.random(), generator}
  end
  table.sort(candidates, function(a, b) return a[1] < b[1] end)
  clear_outcomes()
  for idx = 1, n do
    add_outcome(candidates[idx][2]())
  end
end

function clear_display_remove_flag()
	if GameHasFlagRun( "cancel_vote" ) then
		clear_outcomes()
		clear_display()
		GameRemoveFlagRun( "cancel_vote" )
	end
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
		local init_check_flag = "skip_vote"
		if GameHasFlagRun( init_check_flag ) then
			return
		end
		GameAddFlagRun( init_check_flag )
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
  for idx, outcome in ipairs(outcomes) do
    if outcome.votes > best_outcome.votes then
      best_outcome = outcome
    end
  end
  if best_outcome.votes > 0 then
    GamePrintImportant(best_outcome.name, best_outcome.desc or "you voted for this")
    best_outcome:func()
  elseif (randomOnNoVotes == "true") then
    local random_outcome = outcomes[math.random(1, 3)]
    GamePrintImportant("Nobody voted!", "Random option choosen: " .. random_outcome.name)
    random_outcome:func()
  else
    GamePrintImportant("Nobody voted!", "Remember to vote!")
  end
  clear_outcomes()
  clear_display()
end

add_persistent_func("twitch_gui", draw_twitch_display)