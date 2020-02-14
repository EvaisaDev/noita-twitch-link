
local spellcaster_types = { "wizard", "warlock", "witch", "mage", "druid", "magician", "shaman", "magus", "sorcerer", "lich" }

local loadouts = {};
--print(tostring("yes"))

for id,loadout in pairs( LOADOUTS ) do
	if CONTENT[loadout].enabled() then
		if CONTENT[loadout].options.condition_callback == nil or CONTENT[loadout].options.condition_callback( player_entity ) == true then
			table.insert( loadouts, loadout );
		end
	end
end
if #loadouts > 0 then
	for idx, loadout in pairs(loadouts) do
		local name = ""
		if(string.match(CONTENT[loadout].options.name, "TYPE"))then
			name = string.lower(CONTENT[loadout].options.name:gsub("TYPE", spellcaster_types[Random( 1, #spellcaster_types )])):gsub("^%l", string.upper):gsub("A ",""):gsub("^%l", string.upper)
		else
			name = string.lower(CONTENT[loadout].options.name.." "..spellcaster_types[Random( 1, #spellcaster_types )]):gsub("^%l", string.upper):gsub("A ",""):gsub("^%l", string.upper)
		end

		local description = ""
		insert_event({
		  name = name,
		  desc = description,
		  func = function()
			select_loadout(loadout)
		  end
		})
	end
end
