extends RayCast3D
@onready var prompt = $Prompt

signal item_pick

func _ready():
	add_exception(owner)
	
func _physics_process(delta):
	prompt.text = ""
	prompt.visible = false
	if is_colliding():
		var detected = get_collider()
		
		if detected is Interactable and detected.visible:
			prompt.text = "Press [E] to pick up " + detected.item_name
			prompt.visible = true
			if Input.is_action_pressed("interact"):
				item_pick.emit(detected)
