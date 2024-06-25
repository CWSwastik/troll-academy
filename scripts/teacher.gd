extends CharacterBody3D

const SPEED = 2.5

var chasing = false
var player_in_los = true

@onready var player = $"../Player"
@onready var dest = player.global_position
@onready var animation_player = $Visuals/AnimationPlayer
@onready var nav = $NavigationAgent3D
@onready var emote = $Visuals/Emote

func _physics_process(delta):
	if Time.get_time_dict_from_system()["second"] % 12 == 0:
		dest = player.global_position + Vector3(randi_range(-50, 50), 0, randi_range(-50, 50))
	
	emote.visible = false
	if chasing:
		dest = player.global_position
		emote.visible = true
	
	# Figure out if Player is in Line of Sight
	var space = get_viewport().world_3d.direct_space_state	
	var params = PhysicsRayQueryParameters3D.create(
		global_position + Vector3(0, 4, 0), 
		player.global_position + Vector3(0, 3, 0),
		4294967295,
		[self, player]
	)
	var results = space.intersect_ray(params)
	player_in_los = true
	if results:
		player_in_los = false
	
	$Panel.visible = $Panel/ProgressBar.value != 0
		
	if player_in_los:
		var player_standing_high = player.global_position.y > 2 and player.velocity.y == 0
		var player_has_suspicious_item = len(player.inventory) > 0
		if not chasing:
			if player_standing_high and not $GetDownAudio.playing:
				$GetDownAudio.play()
				chasing = true
				
			if player_has_suspicious_item and not $PocketsAudio.playing:
				$PocketsAudio.play()
				chasing = true
		
		if player_standing_high:
			$Panel/ProgressBar.value += 0.75
		elif player_has_suspicious_item:
			print("Sus", $Panel/ProgressBar.value)
			
			$Panel/ProgressBar.value += (100-$Panel/ProgressBar.value)/1000
		elif chasing:
			chasing = not chasing
	else:
		$Panel/ProgressBar.value -= 0.05
		$Panel/ProgressBar.value = clamp($Panel/ProgressBar.value, 0, 100)
			
	if $Panel/ProgressBar.value > 99:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		return 
		
	if chasing and (player.global_position - global_position).length() < 4:
		if player.inventory:
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
	
	#if randi_range(-500, 500) == 0:
		#chasing = not chasing	
	
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
	
	
	# Look at the player
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), delta * 5.0)
	move_and_slide()


func _on_player_inventory_update(inventory):
	if player_in_los:
		$Panel/ProgressBar.value += 99
