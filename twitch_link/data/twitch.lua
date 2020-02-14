local HOST_URL = "ws://localhost:53225"

if not async then
  dofile( "data/coroutines.lua" )
  --dofile( "data/scripts/lib/coroutines.lua" )
end

dofile_once( "mods/twitch_link/config.lua" )
dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once("data/scripts/perks/perk.lua")
dofile_once("data/scripts/perks/perk_list.lua")
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/lib/localization.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/config.lua" );
dofile_once( "mods/gkbrkn_noita/files/gkbrkn/misc/loadouts/helper.lua" );

local time = require'mods.twitch_link.data.time'
-- this empty table is used as a special value that will suppress
-- printing any kind of "RES>" value (normally "[no value]" would print)
local UNPRINTABLE_RESULT = {}

-- (from http://lua-users.org/wiki/SplitJoin)
local strfind = string.find
local tinsert = table.insert
local strsub = string.sub
local function strsplit(text, delimiter)
  local list = {}
  local pos = 1
  if strfind("", delimiter, 1) then -- this would result in endless loops
    error("Delimiter matches empty string!")
  end
  while 1 do
    local first, last = strfind(text, delimiter, pos)
    if first then -- found?
      tinsert(list, strsub(text, pos, first-1))
      pos = last+1
    else
      tinsert(list, strsub(text, pos))
      break
    end
  end
  return list
end

if not pollws then
  print("Attempting to link pollws.dll through FFI")
  local ffi = ffi or _G.ffi or require("ffi")
  ffi.cdef[[
  struct pollsocket* pollws_open(const char* url);
  void pollws_close(struct pollsocket* ctx);
  int pollws_status(struct pollsocket* ctx);
  void pollws_send(struct pollsocket* ctx, const char* msg);
  int pollws_poll(struct pollsocket* ctx);
  unsigned int pollws_get(struct pollsocket* ctx, char* dest, unsigned int dest_size);
  unsigned int pollws_pop(struct pollsocket* ctx, char* dest, unsigned int dest_size);
  ]]
  print("CDEF was OK")
  pollws = ffi.load("mods\\twitch_link\\data\\pollws.dll")
  print("FFI was OK")

  function open_socket(url, scratch_size)
    -- might as well have a comfortable megabyte of space
    if not scratch_size then scratch_size = 1000000 end
    local res = {
      _socket = pollws.pollws_open(url),
      _scratch = ffi.new("int8_t[?]", scratch_size),
      _scratch_size = scratch_size
    }
    function res:set_scratch_size(scratch_size)
      self._scratch = ffi.new("int8_t[?]", scratch_size)
      self._scratch_size = scratch_size
    end
    function res:poll()
      if not self._socket then return end
      local msg_size = pollws.pollws_pop(self._socket, self._scratch, self._scratch_size)
      if msg_size > 0 then
        local smsg = ffi.string(self._scratch, msg_size)
        return smsg
      else
        return nil
      end
    end
    function res:send(msg)
      if not self._socket then return end
      pollws.pollws_send(self._socket, msg)
    end
    function res:close()
      pollws.pollws_close(self._socket)
      self._socket = nil
    end
    return res
  end
end

local main_socket = nil

local function reconnect(url)
  main_socket = open_socket(url or HOST_URL)
  main_socket:poll()
end

reconnect()

local printing_to_socket = false

local function set_scratch_size(scratch_size)
  if not scratch_size then error("Scratch size cannot be nil") end
  main_socket:set_scratch_size(scratch_size)
end

local function socket_send(msg)
  main_socket:send(msg)
end

local function socket_print(str)
  local msg = ">" .. str
  main_socket:send(msg)
end

function cprint(...)
  local m = table.concat({...}, " ")
  if printing_to_socket then
    socket_print(m)
  else
    print(m)
  end
end

local function set_print_to_socket(p)
  printing_to_socket = p
end

local function cprint_table(t)
  local s = {}
  for k, v in pairs(t) do
    table.insert(s, k .. ": " .. type(v))
  end
  cprint(table.concat(s, "\n"))
end

local console_env = nil

local function reload_utils()
  local env_utils, err = loadfile("data/utils.lua")
  if type(env_utils) ~= "function" then
    cprint("Error loading utils: " .. tostring(err))
    return
  end
  setfenv(env_utils, console_env)
  local happy, err = pcall(env_utils)
  if not happy then
    cprint("Error executing utils: " .. tostring(err))
  end
  cprint("Utils loaded.")
end

local _persistent_funcs = {}

local function add_persistent_func(name, f)
  _persistent_funcs[name] = f
end

local function remove_persistent_func(name)
  _persistent_funcs[name] = nil
end

local function run_persistent_funcs()
  for fname, f in pairs(_persistent_funcs) do
    local happy, err = pcall(f, fname)
    if not happy then cprint(err) end
  end
end

local function _dofile(fn)
  local s = loadfile(fn)
  if type(s) == 'string' then
    -- work around Noita's broken loadfile that returns error
    -- message as first argument rather than as second
    error(fn .. ": " .. s)
  end
  setfenv(s, console_env)
  return s()
end

local _help_info = nil
local function reload_help(fn)
  fn = fn or "tools_modding/lua_api_documentation.txt"
  local f, err = io.open(fn)
  if not f then error("Couldn't open " .. fn) end
  local res = f:read("*a")
  f:close()
  if not res then error("Couldn't read " .. fn) end
  _help_info = {}
  res = res:gsub("\r", "") -- get rid of horrible carriage returns
  local lines = strsplit(res, "\n")
  for _, line in ipairs(lines) do
    local paren_idx = line:find("%(")
    if paren_idx then
      local funcname = line:sub(1, paren_idx-1)
      _help_info[funcname] = line
    end
  end
end

local function help_str(funcname)
  if not _help_info then reload_help() end
  return _help_info[funcname]
end

local function help(funcname)
  cprint(help_str(funcname) or (funcname .. "-> [no help available]"))
  return UNPRINTABLE_RESULT
end

local function _strinfo(v)
  if v == nil then return "nil" end
  local vtype = type(v)
  if vtype == "number" then
    return ("%0.4f"):format(v)
  elseif vtype == "string" then
    return '"' .. v .. '"'
  elseif vtype == "boolean" then
    return tostring(v)
  else
    return ("[%s] %s"):format(vtype, tostring(v))
  end
end

local function strinfo(...)
  local frags = {}
  local nargs = select('#', ...)
  if nargs == 0 then
    return "[no value]"
  end
  if nargs == 1 and select(1, ...) == UNPRINTABLE_RESULT then
    return UNPRINTABLE_RESULT
  end
  for idx = 1, nargs do
    frags[idx] = _strinfo(select(idx, ...))
  end
  return table.concat(frags, ", ")
end

local function info(...)
  cprint(strinfo(...))
  return UNPRINTABLE_RESULT
end

local function complete(s)
  local opts = {}

  local parts = strsplit(s, "%.") -- strsplit takes a pattern, so have to escape "."
  local cur = console_env
  local prefix = ""
  for idx = 1, (#parts) - 1 do
    cur = cur[parts[idx]]
    if not cur then return UNPRINTABLE_RESULT end
    prefix = prefix .. parts[idx] .. "."
  end
  if type(cur) ~= "table" then return UNPRINTABLE_RESULT end
  local lastpart = parts[#parts]
  if not lastpart then return UNPRINTABLE_RESULT end
  for k, _ in pairs(cur) do
    if k:find(lastpart) == 1 then
      table.insert(opts, k)
    end
  end
  if #opts > 0 then
    table.sort(opts)
    cprint("COM>" .. prefix .. " " .. table.concat(opts, ","))
  end
  return UNPRINTABLE_RESULT
end

local function new_console_env()
  console_env = {}
  for k, v in pairs(getfenv()) do
    console_env[k] = v
  end
  console_env.reconnect = reconnect
  console_env.complete = complete
  console_env.new_console_env = new_console_env
  console_env.set_print_to_socket = set_print_to_socket
  console_env.print = cprint
  console_env.print_table = cprint_table
  console_env.socket_print = socket_print
  console_env.socket_send = socket_send
  console_env.rawprint = print
  console_env.reload_utils = reload_utils
  console_env.add_persistent_func = add_persistent_func
  console_env.set_persistent_func = add_persistent_func -- alias
  console_env.remove_persistent_func = remove_persistent_func
  console_env.strinfo = strinfo
  console_env.info = info
  console_env.dofile = _dofile
  console_env.reload_help = reload_help
  console_env.help_str = help_str
  console_env.help = help
  console_env.UNPRINTABLE_RESULT = UNPRINTABLE_RESULT
  
  reload_utils()
end
new_console_env()

local function _collect(happy, ...)
  if happy then
    return happy, strinfo(...)
  else
    return happy, ...
  end
end

local function do_command(msg)
  local f, err = nil, nil
  if not msg:find("\n") then
    -- if this is a single line, try putting "return " in front
    -- (convenience to allow us to inspect values)
    f, err = loadstring("return " .. msg)
  end
  if not f then -- multiline, or not an expression
    f, err = loadstring(msg)
    if not f then
      cprint("ERR> Parse error: " .. tostring(err))
      return
    end
  end
  setfenv(f, console_env)
  local happy, retval = _collect(pcall(f))
  if happy then
    if retval ~= UNPRINTABLE_RESULT then
      cprint("RES> " .. tostring(retval))
    end
  else
    cprint("ERR> " .. tostring(retval))
  end
end

local count = 0

_ws_main = function()
  local msg = main_socket:poll()
  if msg then
		do_command(msg)
  end
 

  count = count + 1
  
  local loadout = "false"
  local perk_vote = "false"
  
  local cancel_vote = "false"
  
	local init_check_flag = "start_loadouts_init"
	if GameHasFlagRun( init_check_flag ) then
		  loadout = "true"
	end

	if GameHasFlagRun( "perk_vote" ) and not GameHasFlagRun( "skip_vote" ) then
		--cancel_vote = "true"
	--	perk_vote = "true"
		if not GameHasFlagRun( "perk_vote2" ) then
			local perkcount = tonumber(GlobalsGetValue( "TEMPLE_PERK_COUNT", "3" ))
			GameAddFlagRun( "perk_vote2" )
			GamePrint("starting perk vote")
			main_socket:send('{"kind": "perk_vote", "perk_count": "'..perkcount..'"}')
		end
	end
	

	if GameHasFlagRun( "reroll_vote" ) then
		--cancel_vote = "true"
	--	perk_vote = "true"
		GameRemoveFlagRun("reroll_vote")
		GamePrint("Rerolling perk vote")
		local perkcount = tonumber(GlobalsGetValue( "TEMPLE_PERK_COUNT", "3" ))
		main_socket:send('{"kind": "perk_vote", "perk_count": "'..perkcount..'"}')
	end
		
	
	if GameHasFlagRun( "skip_vote" ) then
		GameRemoveFlagRun( "skip_vote" )
		GameRemoveFlagRun( "perk_vote" )
		GameRemoveFlagRun( "perk_vote2" )
		local perkcount = 3;
		--cancel_vote = "false"
		--perk_vote = "false"
		main_socket:send('{"kind": "voteskip", "perk_count": "'..perkcount..'", "votetime": "'..vote_time..'", "random_vote_time": "'..event_vote_interval..'"}')
	end
	

  if(loadout == "false")then
	player_entity = get_players()[1];
	local characterPlatformingData = EntityGetFirstComponent(player_entity, "CharacterPlatformingComponent")
	ComponentSetValue(characterPlatformingData, "velocity_max_x", "0")
	ComponentSetValue(characterPlatformingData, "velocity_min_x", "0")
	ComponentSetValue(characterPlatformingData, "velocity_max_y", "350")
	ComponentSetValue(characterPlatformingData, "velocity_min_y", "0")
  end
   player = get_players()[1];
	if(player ~= nil)then
	  if count % 60 == 0 then
		local current_time = tostring(time.time());
		local perkcount = 3;
		main_socket:send('{"kind": "heartbeat", "perk_count": "'..perkcount..'", "source": "noita", "time": "'..current_time..'", "loadout_time": "'..loadout_time..'", "user": "'..twitch_username..'", "loadout_vote": "'..loadout_vote..'", "perk_vote": "'..perk_vote..'", "cancel_vote": "'..cancel_vote..'", "votetime": "'..vote_time..'", "random_vote_time": "'..event_vote_interval..'", "loadout": "'..loadout..'"}')
	  end
	 end 
  run_persistent_funcs()
  wake_up_waiting_threads(1) -- from coroutines.lua

end