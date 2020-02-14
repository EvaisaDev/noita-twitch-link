dofile_once( "data/scripts/lib/utilities.lua" )

local theEntity = GetUpdatedEntityID()

local x, y = EntityGetTransform( theEntity )

local players = EntityGetInRadiusWithTag( x, y, 50, "player_unit" )

if(players ~= nil)then
	if GameHasFlagRun( "perk_vote" ) then
		return
	end
	GamePrint("Player Detected!")
	GameAddFlagRun( "perk_vote" )
	EntityKill( theEntity )
end
