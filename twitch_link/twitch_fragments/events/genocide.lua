



insert_event({
  name = "Genocide",
  desc = "Kill all enemies",
  func = function()
	local enemies = EntityGetWithTag( "enemy" )
	for k, enemy in pairs(enemies) do 
		local x, y = EntityGetTransform(enemy)
		if(EntityHasTag(enemy, "drone_friendly"))then
			
		else
			EntityLoad("data/entities/murdershot.xml", x, y)
		end
	end
  end
})