extends CharacterBody3D


const SPEED = 4.0
const JUMP_VELOCITY = 5.75


@export var SENS_HORIZONTAL := 0.1
@export var SENS_VERTICAL := 0.1
@onready var camera_mount = $CameraMount
@onready var animation_player = $Visuals/Character/AnimationPlayer

var inventory: Array = []


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENS_HORIZONTAL))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * SENS_VERTICAL))
		camera_mount.rotation.x = clamp(
			camera_mount.rotation.x, -0.5, 0.4
		)
		

func _physics_process(delta):
	# Add the gravity.
	if Input.is_action_just_pressed("place") and len(inventory) > 0:
		var item = inventory.pop_front()
		item.global_position = $Visuals.global_position + Vector3(0, 1 + camera_mount.rotation.x, 2)
		item.enable()
		print("Placed " + item.item_name)
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
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
		if animation_player.current_animation != "Idle0":
			animation_player.play("Idle0")	
	move_and_slide()


func _on_interact_ray_item_pick(item):
	print("Picked up" + item.item_name)
	inventory.append(item)
	item.disable()

	print(inventory, len(inventory))
