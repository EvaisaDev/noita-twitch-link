



insert_event({
  name = "More gold",
  desc = "Gold pickups are temporarily worth alot more.",
  func = function()
	local player = get_players()[1]
	for i = 1, 3 do
		local game_effect = GetGameEffectLoadTo(player, "EXTRA_MONEY", true);
		if game_effect ~= nil then 
			ComponentSetValue(game_effect, "frames", "3600"); 
		end
	end
  end
})