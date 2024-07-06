extends Node

var quests = {
	1: {
		"name": "Whoopee Trouble",
		"desc": "Troll someone with a Whoopee Cushion",
		"logo": "res://assets/ItemLogos/whoopee_cushion.png"
	},
	2: {
		"name": "Wet and Wild",
		"desc": "Spill water and make a teacher fall down",
		"logo": "res://assets/ItemLogos/water_bottle.png"
	},
	3: {
		"name": "Cookie Catastrophe",
		"desc": "Mix laxatives in a cookie",
		"logo": "res://assets/ItemLogos/laxatives.png"
	},
	4: {
		"name": "Broadcast Bandit",
		"desc": "Hack the PA system to play a meme song",
		"logo": "res://assets/ItemLogos/loudspeaker.png"
	},
	5: {
		"name": "Sticky Situation",
		"desc": "Glue notebooks to desks in the classroom",
		"logo": "res://assets/ItemLogos/glue.png"
	},
	6: {
		"name": "Bubbles of Boom",
		"desc": "Create an explosion in the chemistry lab",
		"logo": "res://assets/ItemLogos/explosion.png"
	},

}

var completed_quests: Array[int] = []
var active_quest_id = randi_range(1, 4)

var intro_played = false
var game_over_reason = ""

var current_quest:
	get:
		return quests[active_quest_id]

func quest_complete(id: int):
	if id in completed_quests:
		return
		
	get_tree().get_first_node_in_group("sfx").play()
	completed_quests.append(id)
	var new = false
	for i in len(quests):
		if i+1 not in completed_quests:
			active_quest_id = i+1
			new = true
			break
			
	await get_tree().create_timer(1.0).timeout
	if not new:
		# Game Won
		get_tree().change_scene_to_file("res://scenes/game_won.tscn")
	else:
		print(completed_quests, active_quest_id)
		
		AudioPlayer.nice_job()
