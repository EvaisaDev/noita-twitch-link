



insert_event({
  name = "Shield",
  desc = "You have a temporary energy shield.",
  func = function()
	async(function()
		local player = get_player()
		local x, y = get_player_pos()
		local cid = EntityLoad( "data/entities/misc/perks/shield.xml", x, y )
		EntityAddChild( player, cid )
		wait(2400)
		EntityKill(cid)
	end)
  end
})