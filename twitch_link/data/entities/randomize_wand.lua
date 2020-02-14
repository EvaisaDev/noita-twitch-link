dofile_once("data/entities/gun_procedural.lua")

if(Random(1,2) == 1)then
	generate_gun( Random(10, 100), Random(1, 3), false )
else
	generate_gun( Random(10, 100), Random(1, 3), true )
end