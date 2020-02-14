dofile_once( "data/scripts/lib/utilities.lua" )

local theEntity = GetUpdatedEntityID()

local x, y = EntityGetTransform( theEntity )

local barrel = EntityLoad("data/entities/bomb.xml", x, y)
