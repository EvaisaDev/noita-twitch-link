



insert_event({
  name = "Health up",
  desc = "Your max HP got increased!",
  func = function()
	local player = get_players()[1]
	
    local damagemodels = EntityGetComponent(player, "DamageModelComponent")
    if (damagemodels ~= nil) then
        for i, damagemodel in ipairs(damagemodels) do
            local max_hp = tonumber(ComponentGetValue(damagemodel, "max_hp"))
            local cur_hp = tonumber(ComponentGetValue(damagemodel, "hp"))
            local new_cur = cur_hp + ((cur_hp / 100) * math.random(5, 20))
			local new_max = max_hp + ((max_hp / 100) * math.random(5, 20))
            ComponentSetValue(damagemodel, "max_hp", new_max)
            ComponentSetValue(damagemodel, "hp", new_cur)
        end
    end

  end
})