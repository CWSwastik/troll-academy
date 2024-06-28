extends Node3D


func _on_area_3d_body_entered(body):
	if body is CharacterBody3D:
		if body is Teacher or body is NPC:
			Global.quest_complete(2)
