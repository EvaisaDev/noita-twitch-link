------------------------ Twitch Config ------------------------

twitch_username = "username" -- Your twitch channel name.


------------------------- Vote Config -------------------------

vote_time = 60 -- The time your viewers get to vote.
event_vote_interval = 120 -- The time in seconds between random event votes.
event_vote_timeout_rounds = 4 -- How many rounds until a event is allowed to show up again after appearing in a vote.
event_vote_priority = "true" -- Prioritize events that have been picked less than other events. Will prevent some events not getting picked at all. (Potentially buggy)
loadout_vote = "true" -- Viewers get to vote for your loadout, change to "false" to disable.
loadout_time = 60 -- How long do viewers get to vote for the loadout.
random_on_no_votes = "true" -- When no one votes pick a random vote, change to "false" to disable.
perk_vote_enabled = "true" -- Allow viewers to vote for perks at the holy mountain.


-------------------- Champion Nametag Config -----------------------

elite_names = "true" -- Randomly name Goki's champions after chat members.
elite_only_once = "false" -- Only allow chat members to show up once per run as a elite.
elite_name_timeout = 60 -- How many seconds until chat member can show up again. Set to -1 to disable timeout.
elite_chance = 50 -- Percentage chance that a elite will have a nametag.


------------------- Mini Boss Nametag Config ------------------

miniboss_names = "true" -- Randomly name Goki's minibosses after chat members.
miniboss_only_once = "false" -- Only allow chat members to show up once per run as a miniboss.
miniboss_name_timeout = 60 -- How many seconds until chat member can show up again. Set to -1 to disable timeout.
miniboss_chance = 100 -- Percentage chance that a miniboss will have a nametag.
