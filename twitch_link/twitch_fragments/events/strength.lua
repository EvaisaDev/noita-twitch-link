



insert_event({
  name = "Strength",
  desc = "Your spells are temporarily 4 times as powerful.",
  func = function()
	local player = get_players()[1]
	for i = 1, 2 do
		local game_effect = GetGameEffectLoadTo(player, "DAMAGE_MULTIPLIER", true);
		if game_effect ~= nil then 
			ComponentSetValue(game_effect, "frames", "3600"); 
		end
	end
  end
})