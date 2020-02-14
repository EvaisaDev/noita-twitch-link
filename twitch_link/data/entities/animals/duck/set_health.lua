dofile_once("data/scripts/lib/utilities.lua")

local entity_id    = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local player = get_players()[1]

local duckHealthComponent = EntityGetComponent(entity_id, "DamageModelComponent")
local playerHealthComponent = EntityGetComponent(player, "DamageModelComponent")

if(duckHealthComponent[1] ~= nil and playerHealthComponent[1] ~= nil)then
	local player_hp = ComponentGetValue(playerHealthComponent, "max_hp")
	
	ComponentSetValue(duckHealthComponent, "max_hp", tostring(20+tonumber(player_hp)))
end