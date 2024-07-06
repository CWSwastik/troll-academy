extends Control

@onready var label = $Panel/Label

signal back_button_pressed

func _ready():
	var children = label.get_children()
	var i = 1
	for qb in children:
		

		var quest = Global.quests[i]
		qb.get_node("Item").get_node("TextureRect").texture = load(quest["logo"])
		qb.get_node("QuestTitle").text = quest["name"]
		qb.get_node("QuestDesc").text = quest["desc"]
		
		if i in Global.completed_quests:
			qb.get_node("QuestTitle").text += " (Done)"
		
		i += 1


func _on_back_button_pressed():
	back_button_pressed.emit()
