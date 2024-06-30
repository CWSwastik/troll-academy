class_name NPC
extends CharacterBody3D

const SPEED = 2.5

var chasing = false
var cur_visit_dest := randi_range(0, len(visit_locations) - 1)

@export var location_markets: Node3D

@onready var visit_locations: Array[Node] = location_markets.get_children()

@onready var dest = visit_locations[cur_visit_dest].global_position
@onready var animation_player = $Visuals/AnimationPlayer
@onready var nav = $NavigationAgent3D


var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	if (visit_locations[cur_visit_dest].global_position - global_position).length() < 2:
		cur_visit_dest = (cur_visit_dest + randi_range(1, 3)) % len(visit_locations)
	
	dest = visit_locations[cur_visit_dest].global_position
	
	if randi_range(-500, 500) == 0:
		chasing = not chasing
				 
	var speed = SPEED
	if chasing:
		speed *= 1.75
		if animation_player.current_animation != "Run":
			animation_player.play("Run")	
	else:
		if animation_player.current_animation != "Walk":
			animation_player.play("Walk")
				
	nav.target_position = dest
	var res = (nav.get_next_path_position() - global_position).normalized() * speed
	
	nav.set_velocity(res)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), delta * 5.0)
	move_and_slide()


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z 
	
