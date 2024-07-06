extends RayCast3D
@onready var prompt = $Prompt
@onready var player = $"../.."

signal item_pick(item)

func _ready():
	add_exception(owner)
	
func _physics_process(delta):
	if is_colliding():
		var detected = get_collider()
		#  print(detected)
		if detected is Interactable and detected.visible and player.inventory.is_empty():
			if detected.name == "Notebook" and not detected.pickable:
				return
				
			prompt.text = "Press [E] to pick up " + detected.item_name
			prompt.visible = true
			if Input.is_action_pressed("interact"):
				item_pick.emit(detected)
				AudioPlayer.useful_item_pick()
		elif detected.name == "PAMic":
			if not player.inventory.is_empty() and player.inventory[0].item_name == "USB":			
				prompt.text = "Press [Q] to hack the PA system"
				prompt.visible = true
				if Input.is_action_pressed("use"):
					detected.hack()
					
			else:
				prompt.text = "You need a USB to hack the PA system"
				prompt.visible = true				
		elif detected.name == "Notebook":
			if player.inventory[0].item_name == "Glue Bottle":
				prompt.text = "Press [Q] to glue this notebook"
				prompt.visible = true
				if Input.is_action_pressed("use"):
					detected.glue()				
		elif detected.name == "ReactionBottle":
			if not player.inventory.is_empty() and player.inventory[0].item_name == "Soap":
				prompt.text = "Press [Q] to add soap to the bottle"
				prompt.visible = true
				if Input.is_action_pressed("use"):
					detected.start_reaction()
			else:
				prompt.text = "You need soap to start the reaction"
				prompt.visible = true				
