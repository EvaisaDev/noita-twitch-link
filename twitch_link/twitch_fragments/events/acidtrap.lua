



insert_event({
    name = "Acid trap",
    desc = "This looks dangerous!",
    func = function()
		local x, y = get_player_pos()

		EntityLoad("data/entities/acid_trap.xml", x, y - 130)
    end
})
