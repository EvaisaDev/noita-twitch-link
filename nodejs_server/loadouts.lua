dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/perks/perk.lua")
dofile("data/scripts/perks/perk_list.lua")

local spellcaster_types = { "wizard", "warlock", "witch", "mage", "druid", "magician", "shaman", "magus", "sorcerer", "lich" }

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Grease "..spellcaster_types[spellcaster_types_rnd],
  desc = "You are very oily.",
  func = function()
	select_loadout(1)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Toxic "..spellcaster_types[spellcaster_types_rnd],
  desc = "What a poisonous personality.",
  func = function()
	select_loadout(2)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Vampire "..spellcaster_types[spellcaster_types_rnd],
  desc = "Lets get that blood.",
  func = function()
	select_loadout(3)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Frost "..spellcaster_types[spellcaster_types_rnd],
  desc = "My heart is cold as ice.",
  func = function()
	select_loadout(4)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Bomb "..spellcaster_types[spellcaster_types_rnd],
  desc = "Explosion!!",
  func = function()
	select_loadout(5)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Melting "..spellcaster_types[spellcaster_types_rnd],
  desc = "Melt the planet!",
  func = function()
	select_loadout(6)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Blade "..spellcaster_types[spellcaster_types_rnd],
  desc = "I like pointy knives.",
  func = function()
	select_loadout(7)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Relic "..spellcaster_types[spellcaster_types_rnd],
  desc = "Ancient power.",
  func = function()
	select_loadout(8)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Necro "..spellcaster_types[spellcaster_types_rnd],
  desc = "Resurrect the dead.",
  func = function()
	select_loadout(9)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Berserker "..spellcaster_types[spellcaster_types_rnd],
  desc = "I strong, I kill.",
  func = function()
	select_loadout(10)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Combustion "..spellcaster_types[spellcaster_types_rnd],
  desc = "Explosion!!",
  func = function()
	select_loadout(11)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Hydromancy "..spellcaster_types[spellcaster_types_rnd],
  desc = "You control the water.",
  func = function()
	select_loadout(12)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Blood "..spellcaster_types[spellcaster_types_rnd],
  desc = "My enemies will bleed.",
  func = function()
	select_loadout(13)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Gravity "..spellcaster_types[spellcaster_types_rnd],
  desc = "Gravi-tea is my favourite drink.",
  func = function()
	select_loadout(14)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Geomancer "..spellcaster_types[spellcaster_types_rnd],
  desc = "You control the earth.",
  func = function()
	select_loadout(15)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Chaos "..spellcaster_types[spellcaster_types_rnd],
  desc = "Total chaos.",
  func = function()
	select_loadout(16)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Common "..spellcaster_types[spellcaster_types_rnd],
  desc = "Just your everyday magician.",
  func = function()
	select_loadout(17)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Summoner "..spellcaster_types[spellcaster_types_rnd],
  desc = "Worm, I choose you!",
  func = function()
	select_loadout(18)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Fire "..spellcaster_types[spellcaster_types_rnd],
  desc = "Burn baby burn.",
  func = function()
	select_loadout(19)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Slime "..spellcaster_types[spellcaster_types_rnd],
  desc = "Ooo slimey.",
  func = function()
	select_loadout(20)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Thunder "..spellcaster_types[spellcaster_types_rnd],
  desc = "I smite thou.",
  func = function()
	select_loadout(21)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Light "..spellcaster_types[spellcaster_types_rnd],
  desc = "So.. Bright...",
  func = function()
	select_loadout(22)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Desert "..spellcaster_types[spellcaster_types_rnd],
  desc = "Uhh, I like cacti?",
  func = function()
	select_loadout(23)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Speed "..spellcaster_types[spellcaster_types_rnd],
  desc = "Gotta go fast!",
  func = function()
	select_loadout(24)
  end
})

local spellcaster_types_rnd = Random( 1, #spellcaster_types )
insert_event({
  name = "Eldritch "..spellcaster_types[spellcaster_types_rnd],
  desc = "Create horrors.",
  func = function()
	select_loadout(25)
  end
})