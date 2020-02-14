



insert_event({
  name = "Teleport streamer",
  desc = "You got teleported!",
  func = function()
    for _,player_entity in pairs( get_players() ) do
        local game_effect = GetGameEffectLoadTo( player_entity, "TELEPORTATION", false );
        if game_effect ~= nil then
            ComponentSetValue( game_effect, "frames", 60 );
        end
    end
  end
})