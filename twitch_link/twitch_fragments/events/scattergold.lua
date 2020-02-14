



insert_event({
  name = "Scatter Gold",
  desc = "Your gold has been scattered.",
  func = function()
	  local player = get_player()
	  local wallet = EntityGetFirstComponent(player, "WalletComponent")
	  if(wallet ~= nil)then
		  local money = tonumber(ComponentGetValueInt(wallet, "money"))
		  ComponentSetValue(wallet, "money", 0)
		  local count = math.floor(money / 5)
		  
		  for i = 1, count do
			spawn_item("data/entities/goldnugget.xml", 50, 150)
		  end
	  end
  end
})