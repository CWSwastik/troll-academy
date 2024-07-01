extends Node3D


func _physics_process(delta):
	position.y -= 0.00001
	if position.y <= 0:
		queue_free()

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		if body is Teacher:
			Global.quest_complete(2)
			
			body.stumbling = true
			
			
