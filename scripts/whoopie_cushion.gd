extends Interactable

const item_name = "Whoopie Cushion"
const icon_path = "res://assets/ItemLogos/whoopee_cushion.png"
const is_usable = false

var deflated = false


func _on_area_3d_body_entered(body):
	if not self.visible:
		return
	
	if body is CharacterBody3D and not deflated:
		$AudioStreamPlayer3D.play()
		deflated = true
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector3(scale.x, 0.1, scale.z), 0.5)
		tween.tween_property(self, "scale", scale, 1)
		tween.tween_callback(inflate)
		
		body.velocity.y += 15
		if body.name == "Teacher" or body.name.begins_with("NPC"):
			print(body.name)
			Global.quest_complete(1)


func inflate():
	deflated = false
	

