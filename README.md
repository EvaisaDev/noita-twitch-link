**This mod adds extended twitch integration for noita. 
If you want your noita experience to be a democracy rather than a dictatorship then this is the mod for you!
Your viewers get to decide your fate and get help you or work against you. (We all know they will work against you so be prepared.)**

**[Warning, this mod requires Goki's things to function it can be downloaded from steam workshop or at the link below!]**
https://github.com/gokiburikin/gkbrkn_noita/releases


# Features

The mod includes:
* Loadout votes (Your viewers decide what loadout you start your game with)
* Perk vote (Your viewers decide what perks you get at holy mountains)
* Random event votes (Your viewers vote for random events during your runs)
* Goki champion names (Champions from Goki's things have a chance to be names after a viewer)
* Goki miniboss names (Minibosses from Goki's things have a chance to be named after a viewer)
* A config file to turn these off or adjust values.



# Installation
Grab a release copy from the releases page:
https://github.com/EvaisaGiac/noita-twitch-link/releases

To install the mod and set it up just extract the zip into your mods folder.
After that open **mods/twitch_link/config.lua** and configure the mod to your liking.

This mod requires extra permissions to work because otherwise it cannot run the relay server that links it to twitch.
Because of this you must enable unsafe mods in the noita mod menu.
You can find the toggle on the right side of the screen.

If the fact that the mod requires extra permissions scares you, the nodejs server the mod uses is packed into a executable using pkg for easy installation however it is completely open source so if you want to take a look at the source code to make sure there is no malicious code feel free:
https://github.com/EvaisaGiac/noita-twitch-link

If you want to disable any events that you do not like all you have to do is navigate to:
**mods/twitch_link/twitch_fragments/events/** 
and just remove the files corresponding to the disliked events.

That's about it, just enable the mod in your mods menu and you are good to go!
