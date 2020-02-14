



insert_event({
    name = "Upgrade wand",
    desc = "One of your wands has been upgraded.",
    func = function()
        local wands = get_wands()
        if wands == nil then return end
        local to_boost = wands[math.random(1,table.getn(wands))]


        local ability = EntityGetAllComponents(to_boost)
        local boost_speed = math.random(0, 1)
        local boost_recharge = math.random(0, 1)
        local reduce_spread = math.random(0, 1)
        local unshuffle = math.random(0, 1)
        for _, c in ipairs(ability) do
            if ComponentGetTypeName(c) == "AbilityComponent" then
                local mana_max = tonumber(ComponentGetValue(c, "mana_max"))
                local mana_charge = tonumber(ComponentGetValue(c, "mana_charge_speed"))
                local deck_capacity = tonumber(ComponentObjectGetValue(c, "gun_config", "deck_capacity"))
                mana_max = mana_max + ((mana_max / 100) * math.random(10, 20))
                mana_charge = mana_charge + ((mana_charge / 100) * math.random(10, 20))
                deck_capacity = deck_capacity + math.random(1, 3)
                ComponentSetValue(c, "mana_max", tostring(mana_max))
                ComponentSetValue(c, "mana_charge_speed", tostring(mana_charge))
                ComponentObjectSetValue(c, "gun_config", "deck_capacity", tostring(deck_capacity))
                if boost_recharge > 0 then
                    local cur_recharge = ComponentObjectGetValue(c, "gun_config", "reload_time") cur_recharge = cur_recharge - ((cur_recharge / 100) * math.random(10, 20)) ComponentObjectSetValue(c, "gun_config", "reload_time", tostring(cur_recharge))
                end
                if boost_speed > 0 then
                    local cur_speed = ComponentObjectGetValue(c, "gunaction_config", "fire_rate_wait")
                    cur_speed = cur_speed - ((cur_speed / 100) * math.random(10, 20))
                    ComponentObjectSetValue(c, "gunaction_config", "fire_rate_wait", tostring(cur_speed))
                end
                if reduce_spread > 0 then
                    local cur_spread = ComponentObjectGetValue(c, "gunaction_config", "spread_degrees")
                    cur_spread = cur_spread - ((cur_spread / 100) * math.random(10, 20))
                    ComponentObjectSetValue(c, "gunaction_config", "spread_degrees", tostring(cur_spread))
                end
                if unshuffle > 0 then
                    ComponentObjectSetValue(c, "gun_config", "shuffle_deck_when_empty", tostring(0))
                end
            end
        end
    end
})
