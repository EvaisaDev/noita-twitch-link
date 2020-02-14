local config_table = {
 miniboss_names = true,
 miniboss_chance = 100,
 elite_chance = 50,
 event_vote_interval = 10,
 perk_vote_enabled = false,
 elite_only_once = false,
 vote_lasting_events = {
 },
 disabled_events = {
 },
 miniboss_name_timeout = 60,
 random_on_no_votes = true,
 event_vote_timeout_rounds = 3,
 elite_name_timeout = 60,
 twitch_username = "evaisie",
 event_vote_priority = true,
 miniboss_only_once = false,
 loadout_vote = true,
 loadout_time = 30,
 elite_names = true,
 vote_time = 10,
}
------------------------ Twitch Config ------------------------

twitch_username = config_table.twitch_username -- Your twitch channel name.


------------------------- Vote Config -------------------------

vote_time = config_table.vote_time -- The time your viewers get to vote.
event_vote_interval = config_table.event_vote_interval -- The time in seconds between random event votes.
event_vote_timeout_rounds = config_table.event_vote_timeout_rounds -- How many rounds until a event is allowed to show up again after appearing in a vote.
event_vote_priority = tostring(config_table.event_vote_priority) -- Prioritize events that have been picked less than other events. Will prevent some events not getting picked at all.
loadout_vote = tostring(config_table.loadout_vote) -- Viewers get to vote for your loadout, change to "false" to disable.
loadout_time = config_table.loadout_time -- How long do viewers get to vote for the loadout.
random_on_no_votes = tostring(config_table.random_on_no_votes) -- When no one votes pick a random vote, change to "false" to disable.
perk_vote_enabled = tostring(config_table.perk_vote_enabled) -- Allow viewers to vote for perks at the holy mountain.


-------------------- Champion Nametag Config -----------------------

elite_names = tostring(config_table.elite_names) -- Randomly name Goki's champions after chat members.
elite_only_once = tostring(config_table.elite_only_once) -- Only allow chat members to show up once per run as a elite.
elite_name_timeout = config_table.elite_name_timeout -- How many seconds until chat member can show up again. Set to -1 to disable timeout.
elite_chance = config_table.elite_chance -- Percentage chance that a elite will have a nametag.


------------------- Mini Boss Nametag Config ------------------

miniboss_names = tostring(config_table.miniboss_names) -- Randomly name Goki's minibosses after chat members.
miniboss_only_once = tostring(config_table.miniboss_only_once) -- Only allow chat members to show up once per run as a miniboss.
miniboss_name_timeout = config_table.miniboss_name_timeout -- How many seconds until chat member can show up again. Set to -1 to disable timeout.
miniboss_chance = config_table.miniboss_chance -- Percentage chance that a miniboss will have a nametag.
