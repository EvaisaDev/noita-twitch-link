



insert_event({
  name = "Invert controls",
  desc = "You look very confused.",
  func = function()
	local player = get_players()[1]
	local game_effect = GetGameEffectLoadTo(player, "CONFUSION", true);
    if game_effect ~= nil then 
		ComponentSetValue(game_effect, "frames", "1200"); 
	end
  end
})