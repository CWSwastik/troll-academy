extends CharacterBody3D

const SPEED = 2.5

var chasing = false
@onready var dest = global_position
@onready var player = $"../Player"
@onready var animation_player = $Visuals/AnimationPlayer
@onready var nav = $NavigationAgent3D

func _physics_process(delta):
	if Time.get_time_dict_from_system()["second"] % 12 == 0:
		dest = player.global_position + Vector3(randi_range(-50, 50), 0, randi_range(-50, 50))
	
	if chasing:
		dest = player.global_position
		
	if randi_range(-500, 500) == 0:
		chasing = not chasing	
	
	var speed = SPEED
	if chasing:
		speed *= 2.5
		if animation_player.current_animation != "Running":
			animation_player.play("Running")	
	else:
		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")
				
	nav.target_position = dest
	velocity = (nav.get_next_path_position() - global_position).normalized() * speed
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y = -1
	# print(velocity)
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), delta * 5.0)
	move_and_slide()
