extends Node3D

@onready var video_stream_player = $SubViewport/SubViewportContainer/VideoStreamPlayer

func _ready():
	video_stream_player.play()
	await get_tree().create_timer(3.31).timeout
	$Control/Panel.visible = true
	var text = "Greetings! I am Metic, your new partner in crime. Your school, full of humans and aliens, is waaay too serious. It's our job to shake things up! Explore the school, find your targets, and pull off harmless.... harmful... pranks to earn points. The more outrageous, the better. But beware of teachers, they're always on the lookout. Good luck!"
	for i in text:
		$Control/Panel/MarginContainer/Label.text += i
		await get_tree().create_timer(0.0662).timeout
	
	await get_tree().create_timer(0.15).timeout
	$Control/Panel/MarginContainer/Label.text = "Loading..."

func _process(delta):
	var duration = video_stream_player.stream_position
	if duration > 28.5:
		get_tree().change_scene_to_file("res://scenes/world.tscn")
	  
	
func _on_animation_player_animation_finished(anim_name):
	pass
	
	
