class_name Teacher
extends CharacterBody3D

const SPEED = 3

var chasing := false
var player_in_los := true
var narrow_escape := false
var stumbling = false
var getting_up = false
var cur_patrol_dest := 0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var patrol_locations: Array[Marker3D] = []

@onready var player = $"../Player"
@onready var dest = patrol_locations[0]
@onready var animation_player = $Visuals/AnimationPlayer
@onready var nav = $NavigationAgent3D
@onready var emote = $Visuals/Emote

func _physics_process(delta):
	
	var dist_to_dest = (patrol_locations[cur_patrol_dest].global_position - global_position).length()
	if dist_to_dest < 2:
		if randi_range(0, 500) == 5:
			cur_patrol_dest = (cur_patrol_dest + 1) % len(patrol_locations)
		
	#if Time.get_time_dict_from_system()["second"] % 12 == 0:
		#dest = player.global_position + Vector3(rwandi_range(-50, 50), 0, randi_range(-50, 50))
	dest = patrol_locations[cur_patrol_dest].global_position
	
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
		var player_has_suspicious_item = len(player.inventory) > 0 and player.inventory[0].suspicious
		if not chasing:
			if player_standing_high and not $GetDownAudio.playing:
				$GetDownAudio.play()
				chasing = true
				
			if player_has_suspicious_item and not $PocketsAudio.playing:
				$PocketsAudio.play()
				chasing = true
		
		if player_standing_high:
			$Panel/ProgressBar.value += 0.75
			Global.game_over_reason = "You were detained for suspicious activities"
		elif player_has_suspicious_item:
			print("Sus", $Panel/ProgressBar.value)
			Global.game_over_reason = "You were detained for having a suspicious item"
			$Panel/ProgressBar.value += (100-$Panel/ProgressBar.value)/1000
		elif chasing:
			chasing = not chasing
			if narrow_escape:
				AudioPlayer.narrow_escape()
	else:
		$Panel/ProgressBar.value -= 0.05
		$Panel/ProgressBar.value = clamp($Panel/ProgressBar.value, 0, 100)
			
	if $Panel/ProgressBar.value > 99:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		return 
	
	if $Panel/ProgressBar.value > 70:
		narrow_escape = true
	elif $Panel/ProgressBar.value < 5 and narrow_escape:
		narrow_escape = false
		
	if chasing and (player.global_position - global_position).length() < 4:
		if player.inventory:
			get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
	
	#if randi_range(-500, 500) == 0:
		#chasing = not chasing	
	
	var speed = SPEED
	
	if getting_up:
		$Visuals/Node.position.z = 0
		
		if animation_player.current_animation != "GettingUp":
			animation_player.play("GettingUp")	
	elif stumbling:

		$Visuals/Node.position.z = lerp($Visuals/Node.position.z, 160.0, 0.075)
		
		if animation_player.current_animation != "Stumble":
			$Visuals/Node.position.y += 12
			animation_player.play("Stumble")
			await get_tree().create_timer(1.2).timeout
			
			$"../FallDown".play()
			await get_tree().create_timer(1).timeout
			$WaterAudio.play()
	elif not is_on_floor():
		if animation_player.current_animation != "Falling":
			animation_player.play("Falling")
	elif chasing:
		speed *= 2.5
		if animation_player.current_animation != "Run":
			animation_player.play("Run")	
	elif dist_to_dest > 2:
		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")
	else:
		if animation_player.current_animation != "Idle":
			animation_player.play("Idle")
			
		return
			
	if stumbling or getting_up:
		return 		
		
	
		
	nav.target_position = dest
	var res = (nav.get_next_path_position() - global_position).normalized() * speed
	nav.set_velocity(res)

	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Look where velocity is
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), delta * 5.0)
	move_and_slide()


func _on_player_inventory_update(inventory):
	if player_in_los:
		$Panel/ProgressBar.value += 99
		Global.game_over_reason = "You were detained for having a suspicious item"

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z 



func _on_animation_player_animation_finished(anim_name):

	if anim_name == "Stumble":
		stumbling = false
		getting_up = true
	if anim_name == "GettingUp":
		getting_up = false
		$Visuals/Node.position.y -= 12
