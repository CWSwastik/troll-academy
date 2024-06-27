class_name Interactable
extends RigidBody3D

func disable():
	self.visible = false
	$CollisionShape3D.disabled = true
	
func enable():
	self.visible = true
	$CollisionShape3D.disabled = false

