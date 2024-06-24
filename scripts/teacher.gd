extends CharacterBody3D

const SPEED = 2.5

const chasing = false
@onready var dest = global_position
@onready var player = $"../Player"
@onready var animation_player = $Visuals/AnimationPlayer

func _physics_process(delta):
	if Time.get_time_dict_from_system()["second"] % 12 == 0:
		dest = player.global_position + Vector3(randi_range(-50, 50), 0, randi_range(-50, 50))
	
	var speed = SPEED
	if chasing:
		speed *= 1.75
		if animation_player.current_animation != "Running":
			animation_player.play("Running")	
	else:
		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")
				
	velocity = (dest - global_position).normalized() * speed
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y = -1
	# print(velocity)
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), delta * 5.0)
	move_and_slide()
