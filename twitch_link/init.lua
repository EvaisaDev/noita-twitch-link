local ffi = require("ffi")
ffi.cdef[[
  void* GetProcAddress(void* hModule, const char* lpProcName);
  void* GetModuleHandleA(const char* lpModuleName);
]]
local ntdll = ffi.C.GetModuleHandleA("ntdll.dll")
local wine_func_addr = ffi.C.GetProcAddress(ntdll, "wine_get_version")
local is_wine = wine_func_addr ~= nil

if is_wine then
  os.execute("set pathext=%pathext%;. & Z:\\bin\\chmod +x mods/twitch_link/twitch-main-linux")
  os.execute("set pathext=%pathext%;. & mods\\twitch_link\\twitch-main-linux")
else
  os.execute("start mods\\twitch_link\\twitch-main-win.exe")
end
--[[
JSON = (loadfile "mods/twitch_link/JSON.lua")() -- one-time load of the routines

function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0

    local tmp = string.rep(" ", depth)

    if name then tmp = tmp .. name .. " = " end

    if type(val) == "table" then
        tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

        for k, v in pairs(val) do
            tmp =  tmp .. serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
        end

        tmp = tmp .. string.rep(" ", depth) .. "}"
    elseif type(val) == "number" then
        tmp = tmp .. tostring(val)
    elseif type(val) == "string" then
        tmp = tmp .. string.format("%q", val)
    elseif type(val) == "boolean" then
        tmp = tmp .. (val and "true" or "false")
    else
        tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
    end

    return tmp
end

function readAll(file)
    local f = assert(io.open(file, "rb"))
    local content = f:read("*all")
    f:close()
    return content
end

local lua_value = JSON:decode(readAll("mods/twitch_link/config.json")) -- decode example

local string_table = serializeTable(lua_value)


local out = io.open('mods/twitch_link/config.base.lua', 'r')

-- Fetch all lines and add them to a table
local lines = {}
for line in out:lines() do
    table.insert(lines, line)
end

out:close()

table.insert(lines, 1, "local config_table = "..string_table)

local out = io.open('mods/twitch_link/config.lua', 'w')
for _, line in ipairs(lines) do
    out:write(line.."\n")
end
out:close()

]]
function OnModPreInit()
	-- Nothing to do but this function has to exist
end

function OnModInit()
	-- Nothing to do but this function has to exist
end

function OnModPostInit()
	-- Nothing to do but this function has to exist
end

function OnWorldPreUpdate()
	-- Nothing to do but this function has to exist
end

function OnWorldPostUpdate() 
	if _ws_main then _ws_main() end
end

function OnPlayerSpawned( player_entity )
	dofile("data/twitch.lua")
	dofile("mods/twitch_link/config.lua")     
	if(loadout_vote == "false")then
		local init_check_flag = "start_loadouts_init"
		if GameHasFlagRun( init_check_flag ) then
			return
		end
		GameAddFlagRun( init_check_flag )
	end
	
	local init_check_flag = "remove_items_start_loadout"
	if GameHasFlagRun( init_check_flag ) then
		return
	end
	GameAddFlagRun( init_check_flag )	
	
	local player_entity = get_players()[1]
	
	if(loadout_vote == "true")then
	
		local inventory = nil
		
		local player_child_entities = EntityGetAllChildren( player_entity )
		if ( player_child_entities ~= nil ) then
			for i,child_entity in ipairs( player_child_entities ) do
				local child_entity_name = EntityGetName( child_entity )
				
				if ( child_entity_name == "inventory_quick" ) then
					inventory = child_entity
				end
			end
		end
		
		-- set inventory contents
		if ( inventory ~= nil ) then
			local inventory_items = EntityGetAllChildren( inventory )
			
			-- remove default items
			if inventory_items ~= nil then
				for i,item_entity in ipairs( inventory_items ) do
					GameKillInventoryItem( player_entity, item_entity )
				end
			end
		end
	end
end
ModLuaFileAppend( "data/scripts/gun/gun_extra_modifiers.lua", "data/entities/extra_modifiers.lua")
ModLuaFileAppend( "data/scripts/perks/perk.lua", "data/perk_override.lua")
--ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/twitch_link/files/scripts/gun/gun_actions_more_loadouts.lua")