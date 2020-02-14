



insert_event({
  name = "Shrooms",
  desc = "You are having a hell of a trip!",
  func = function()
	async(function()
		local player = get_player()
		local drugs = EntityGetComponent(player, "DrugEffectComponent")
		
		local drugs = EntityAddComponent( player, "DrugEffectComponent", 
		{ 
			--hallucinogen_amount = "10",
			stoned_amount = "6",
		})		
		
        wait(2400)
		ComponentSetValue(drugs, "stoned_amount", "0")
		EntityRemoveComponent(player, drugs)
    end)	
  end
})