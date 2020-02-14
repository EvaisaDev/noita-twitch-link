



insert_event({
  name = "Gotta go fast",
  desc = "You are temporarily sonic.",
  func = function()
	local player = get_players()[1]
	for i = 1, 2 do
		local game_effect = GetGameEffectLoadTo(player, "MOVEMENT_FASTER_2X", true);
		if game_effect ~= nil then 
			ComponentSetValue(game_effect, "frames", "1200"); 
		end
	end
  end
})