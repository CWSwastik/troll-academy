extends Interactable

const item_name = "Notebook"
const icon_path = "res://assets/ItemLogos/book_green.png"
const is_usable = false
const suspicious = false
var pickable = true


func glue():
	Global.quest_complete(5)
	pickable = false
	
