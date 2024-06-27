extends Interactable

const item_name = "Whoopie Cushion"
var deflated = false

signal whoopie_troll_sucess

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
		
		body.velocity.y += 20
		if body.name == "Teacher" or body.name == "NPC":
			print(body.name)
			whoopie_troll_sucess.emit()


func inflate():
	deflated = false
	

