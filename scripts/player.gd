extends CharacterBody3D


const SPEED = 4.0
const JUMP_VELOCITY = 6


@export var SENS_HORIZONTAL := 0.1
@export var SENS_VERTICAL := 0.1

@onready var camera_mount = $CameraMount
@onready var animation_player = $Visuals/Character/AnimationPlayer
@onready var prompt = $CameraMount/InteractRay/Prompt

signal inventory_update(inventory)

var inventory: Array[RigidBody3D] = []

var bottle_use_count = 5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENS_HORIZONTAL))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * SENS_VERTICAL))
		camera_mount.rotation.x = clamp(
			camera_mount.rotation.x, -0.5, 0.35
		)


func _physics_process(delta):
	# Add the gravity.

	var change = Input.get_axis("look_down", "look_up") * 20
	camera_mount.rotate_x(deg_to_rad(-change* SENS_VERTICAL))
	camera_mount.rotation.x = clamp(
		camera_mount.rotation.x, -0.5, 0.35
	)

	change = Input.get_axis("look_left", "look_right") * 20		
	rotate_y(deg_to_rad(-change * SENS_HORIZONTAL))		

	if len(inventory) > 0:
		prompt.visible = true
		prompt.text = "Tip: Place the item by pressing [X]"
		if Input.is_action_just_pressed("place"):
			var item = inventory.pop_front()
			# Get the forward direction of the camera
			var forward = - camera_mount.global_transform.basis.z.normalized()
			
			# Set the item's position in front of the player
			item.global_position = $Visuals.global_position + forward * 2.2 + Vector3(0, 2, 0)
			item.linear_velocity = Vector3(0,0,0)
			item.rotation = Vector3(0,0,0)
			item.enable()
			print("Placed " + item.item_name)
			inventory_update.emit(inventory)
			
		elif inventory[0].is_usable:
			if inventory[0].item_name == "Water Bottle":
				prompt.text = "Tip: The item can be used by pressing [Q]"
			elif inventory[0].item_name == "Laxatives" and $CameraMount/InteractRay.is_colliding():
				if $CameraMount/InteractRay.get_collider() is Cookie:
					prompt.text = "Press [Q] to use Laxatives on this cookie"
				
			if Input.is_action_pressed("use"):
				match inventory[0].item_name:
					"Water Bottle":
						var item = inventory.pop_front()
						inventory_update.emit(inventory)
						
						if bottle_use_count < 1:
							item.queue_free()
						else:
							inventory.append(item)
							bottle_use_count -= 1
						inventory_update.emit(inventory)
							
						var scene = preload("res://scenes/items/water_puddle.tscn")
						var instance = scene.instantiate()
						$"../Items".add_child(instance)
						var forward = - camera_mount.global_transform.basis.z.normalized()
						instance.global_position = $Visuals.global_position + forward * 2 + Vector3(0, 0.95, 0)
					"Laxatives":
						if not $CameraMount/InteractRay.is_colliding():
							prompt.text = "Please find an eatable item first!"
						else:
							var obj = $CameraMount/InteractRay.get_collider()
							if not obj is Cookie:
								prompt.text = "This isn't an eatable item!"
							else:
								obj.add_laxatives()
	else:					
		prompt.visible = false

	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		var s = SPEED
		if Input.is_action_pressed("sprint"):
			s *= 2.5
		velocity.x = direction.x * s
		velocity.z = direction.z * s

	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if not is_on_floor():
		if animation_player.current_animation != "Jump0":
			animation_player.play("Jump0")
	elif direction:
		if Input.is_action_pressed("sprint"):
			if animation_player.current_animation != "Running0":
				animation_player.play("Running0")
		else:
			if animation_player.current_animation != "Walking0":
				animation_player.play("Walking0")	
	else:
		if Input.is_action_just_pressed("punch"):
			animation_player.play("PunchCombo0")
		elif animation_player.current_animation != "Idle0" and animation_player.current_animation != "PunchCombo0":
			animation_player.play("Idle0")	
	
	# SFX
	if is_on_floor() and Input.is_action_pressed("sprint"):
		if not $RunningSFX.playing:
			$RunningSFX.play()
	else:
		$RunningSFX.stop()
	
	move_and_slide()


func _on_interact_ray_item_pick(item):
	print("Picked up" + item.item_name)
	inventory.append(item)
	item.disable()
	inventory_update.emit(inventory)
	print(inventory, len(inventory))
