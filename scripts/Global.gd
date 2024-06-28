extends Node

var quests = {
	1: {
		"name": "Whoopie Trouble",
		"desc": "Troll someone with a Whoopie Cushion",
		"logo": "res://assets/ItemLogos/whoopee_cushion.png"
	},
	2: {
		"name": "Splash",
		"desc": "Spill Water and make someone fall down",
		"logo": "res://assets/ItemLogos/water_bottle.png"
	},
	3: {
		"name": "Laxatives ;)",
		"desc": "Mix laxatives in cupcakes",
		"logo": "res://assets/ItemLogos/laxatives.png"		
	}
}

var completed_quests: Array[int] = []
var active_quest_id = 1

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
	
