dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform( entity_id )

local duck = EntityLoad("data/entities/animals/duck/duck.xml", x, y)
--[[local dx, dy = EntityGetTransform(duck)
local duckbomb = EntityLoad("data/entities/duckbomb.xml", dx, dy)
EntityAddChild( duck, duckbomb )]]