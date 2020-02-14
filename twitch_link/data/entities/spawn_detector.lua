dofile_once( "data/scripts/lib/utilities.lua" )

local theEntity = GetUpdatedEntityID()

local x, y = EntityGetTransform( theEntity )

local detectors = EntityGetInRadiusWithTag( -662, y + 250, 50, "player_detector" )
if(detectors == nil)then
	EntityLoad("data/entities/player_detector.xml", -662, y + 250)
end