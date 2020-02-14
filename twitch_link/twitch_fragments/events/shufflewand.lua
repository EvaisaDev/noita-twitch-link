



insert_event({
  name = "Shuffle wand",
  desc = "One of your wands is now a shuffle wand.",
  func = function()
    local player = get_players()[1]
	
    local wands = get_wands()
    if wands == nil then return end
    local to_boost = table.getn(wands)

	local good_wands = {}
	
    for i = 1, to_boost do
        local ability = EntityGetAllComponents(wands[i])
        for _, c in ipairs(ability) do
            if ComponentGetTypeName(c) == "AbilityComponent" then
				if(tonumber(ComponentObjectGetValue(c, "gun_config", "shuffle_deck_when_empty")) == 0)then
					table.insert(good_wands, wands[i])
				end    
            end
        end
    end
	
	local chosen_wand = good_wands[math.random(1, table.getn(good_wands))]
	ability = EntityGetAllComponents(chosen_wand)
    for _, c in ipairs(ability) do
		if ComponentGetTypeName(c) == "AbilityComponent" then
			ComponentObjectSetValue(c, "gun_config", "shuffle_deck_when_empty", tostring(1))
		end
	end
  end
})