



insert_event({
  name = "Blindness",
  desc = "It sure got dark in here!",
  func = function()
    for _,player_entity in pairs( get_players() ) do
        local game_effect = GetGameEffectLoadTo( player_entity, "BLINDNESS", false );
        if game_effect ~= nil then
            ComponentSetValue( game_effect, "frames", 900 );
        end
    end
  end
})