class_name Interactable
extends Node3D

const item_name = "Whoopie Cushion"
var deflated = false

func disable():
	self.visible = false
	$CollisionShape3D.disabled = true
	
func enable():
	self.visible = true
	$CollisionShape3D.disabled = false


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


func inflate():
	deflated = false
	

