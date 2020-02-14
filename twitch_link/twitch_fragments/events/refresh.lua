



insert_event({
    name = "Spell refresh",
    desc = "Your spells have been refreshed!",
    func = function()
		local x, y = get_player_pos()
		EntityLoad("data/entities/particles/image_emitters/spell_refresh_effect.xml", x, y)
		
		GameRegenItemActionsInPlayer( get_player() )
    end
})