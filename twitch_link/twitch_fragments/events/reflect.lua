



insert_event({
  name = "Reflect melee",
  desc = "Temporarily reflect melee damage.",
  func = function()
    local player = get_player()
    local game_effect = GetGameEffectLoadTo(player, "MELEE_COUNTER", true);
    if game_effect ~= nil then 
        ComponentSetValue(game_effect, "caused_by_stains", 1);
        ComponentSetValue(game_effect, "frames",1200);
    end
  end
})