extends Node

var quests = {
	1: {
		"name": "Whoopee Trouble",
		"desc": "Troll someone with a Whoopee Cushion",
		"logo": "res://assets/ItemLogos/whoopee_cushion.png"
	},
	2: {
		"name": "Wet and Wild",
		"desc": "Spill water and make someone fall down",
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
		"desc": "Glue items to desks in the classroom",
		"logo": "res://assets/ItemLogos/glue.png"
	},
	6: {
		"name": "Mouse Mayhem",
		"desc": "Tape over the bottom of all the computer mice",
		"logo": "res://assets/ItemLogos/mouse.png"
	},

}

var completed_quests: Array[int] = []
var active_quest_id = randi_range(1, 4)

var current_quest:
	get:
		return quests[active_quest_id]

func quest_complete(id: int):
	if id in completed_quests:
		return
	completed_quests.append(id)
	for i in len(quests):
		if i+1 not in completed_quests:
			active_quest_id = i+1
			break

	print(completed_quests, active_quest_id)
	
