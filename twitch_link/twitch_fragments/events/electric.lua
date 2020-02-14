



insert_event({
  name = "Stun",
  desc = "You have been stunned",
  func = function()
    local player = get_player()
    local game_effect = GetGameEffectLoadTo( player, "ELECTROCUTION", true );
    if game_effect ~= nil then ComponentSetValue( game_effect, "frames", 120 ); end
  end
})