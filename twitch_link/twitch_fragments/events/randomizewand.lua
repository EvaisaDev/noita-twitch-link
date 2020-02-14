



insert_event({
    name = "Randomize wand",
    desc = "One of your wands has been randomized.",
    func = function()
		local inventory = get_inventory()

		if ( inventory ~= nil ) then
			local inventory_items = get_wands()
			
			if inventory_items ~= nil then
				local replaced_wand = inventory_items[math.random(1,table.getn(inventory_items))]
				GameKillInventoryItem( get_player(), replaced_wand )
				local item_entity = EntityLoad( "data/entities/random_wand.xml" )
				EntityAddChild( inventory, item_entity )
			end	
		end		
    end
})
