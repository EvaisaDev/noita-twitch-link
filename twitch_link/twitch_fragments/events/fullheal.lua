



insert_event({
  name = "Full heal",
  desc = "You got your health back!",
  func = function()
	local player = get_players()[1]
	local max_hp = 0
	local healing = 0
	
	local x, y = EntityGetTransform( player )

	local damagemodels = EntityGetComponent( player, "DamageModelComponent" )
	if( damagemodels ~= nil ) then
		for i,damagemodel in ipairs(damagemodels) do
			max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) )
			local hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
			
			healing = max_hp - hp
			
			ComponentSetValue( damagemodel, "hp", max_hp)
		end
	end

	EntityLoad("data/entities/particles/image_emitters/heart_fullhp_effect.xml", x, y-12)
	EntityLoad("data/entities/particles/heart_out.xml", x, y-8)
	--GameTriggerMusicEvent( "music/temple/enter", true, x, y )

  end
})