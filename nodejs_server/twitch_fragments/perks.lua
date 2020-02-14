dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/perks/perk_list.lua" )
dofile_once( "data/scripts/perks/perk.lua" )
dofile_once( "data/utils.lua" )

local function get_localized_name(s, default)
  if s:sub(1,1) ~= "$" then return s end
  local rep = GameTextGet(s)
  if rep and rep ~= "" then return rep else return default or s end
end
is_perk_vote = true
for idx, perk in ipairs(perk_list) do
	local name = get_localized_name(perk.ui_name, perk.id)
	local description = get_localized_name(perk.ui_description, "")
	insert_event({
	  name = name,
	  desc = description,
	  func = function()
		player_entity = get_players()[1]
		local x, y = EntityGetTransform( player_entity )

		local perk_entity = perk_spawn( x, y, perk.id )
		if ( perk_entity ~= nil ) then
			perk_pickup( perk_entity, player_entity, EntityGetName( perk_entity ), false, false )
			--GamePrintImportant( GameTextGet( "$log_pickedup_perk", GameTextGetTranslatedOrNot( perk.ui_name ) ), perk.ui_description ) -- delete this line to remove in-game notification
		end
		if GameHasFlagRun( "perk_vote" ) then
			GameRemoveFlagRun( "perk_vote" )
		end
	  end
	})
end