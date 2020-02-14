



insert_event({
  name = "Random Perk",
  desc = "You got a free perk!",
  func = function()
    local perk = perk_list[math.random(1, #perk_list)]

    local x, y = get_player_pos()

    -- player might be dead
    if x ~= nil and y ~= nil then
        local perk_entity = perk_spawn(x, y - 8, perk.id)
        local players = get_players()
        if players == nil then return end
        for i, player in ipairs(players) do
            -- last argument set to false, so you dont kill others perks if triggered inside the shop
            perk_pickup(perk_entity, player, nil, true, false)
        end
    end
  end
})