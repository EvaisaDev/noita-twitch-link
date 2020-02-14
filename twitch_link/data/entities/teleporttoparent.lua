dofile_once( "data/scripts/lib/utilities.lua" )

local theEntity = GetUpdatedEntityID()

local parent = EntityGetParent( theEntity )

local x, y = EntityGetTransform( parent )

EntitySetTransform(theEntity, x, y)

