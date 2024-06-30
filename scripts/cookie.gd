class_name Cookie
extends RigidBody3D

@onready var pills = $Sketchfab_Scene/Sketchfab_model/Indigestive_biscuit_fbx/RootNode/Pills_004

func add_laxatives():
	pills.visible = true
	Global.quest_complete(3)
