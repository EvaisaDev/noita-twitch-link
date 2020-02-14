


dofile( "data/scripts/gun/gun_enums.lua")
dofile( "data/scripts/gun/procedural/gun_action_utils.lua")
insert_event({
    name = "Always Cast",
    desc = "One of your wands got a random always cast.",
    func = function()
        local wands = get_wands()
        if wands == nil then return end
        local wand = wands[math.random(1,table.getn(wands))]

		local player = get_player()
		local x, y = EntityGetTransform(player)
		
		AddGunActionPermanent( wand, GetRandomAction( x, y, 6, 666))
		

        local ability = EntityGetAllComponents(wand)
        for _, c in ipairs(ability) do
            if ComponentGetTypeName(c) == "AbilityComponent" then
                local deck_capacity = tonumber(ComponentObjectGetValue(c, "gun_config", "deck_capacity"))
				deck_capacity = deck_capacity + 1
                ComponentObjectSetValue(c, "gun_config", "deck_capacity", tostring(deck_capacity))
            end
        end		
    end
})
