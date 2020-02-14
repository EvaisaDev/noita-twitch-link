



insert_event({
  name = "Lots of mana",
  desc = "You temporarily regenerate mana extremely quickly.",
  func = function()
	local player = get_players()[1]
	for i = 1, 5 do
		local game_effect = GetGameEffectLoadTo(player, "MANA_REGENERATION", true);
		if game_effect ~= nil then 
			ComponentSetValue(game_effect, "frames", "3600"); 
		end
	end
  end
})