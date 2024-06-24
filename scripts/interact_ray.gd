extends RayCast3D
@onready var prompt = $Prompt

signal item_pick

func _ready():
	add_exception(owner)
	
func _physics_process(delta):
	prompt.text = ""
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable and detected.visible:
			prompt.text = "Press [E] to pick up " + detected.item_name
			
			if Input.is_action_pressed("interact"):
				item_pick.emit(detected)
