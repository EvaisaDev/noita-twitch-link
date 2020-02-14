



insert_event({
  name = "Farts",
  desc = "You feel gassy.",
  func = function()
  	local player = get_players()[1]
    local game_effect = GetGameEffectLoadTo(player, "FARTS", true);
    if game_effect ~= nil then 
        ComponentSetValue(game_effect, "frames", 1800);
    end
  end
})