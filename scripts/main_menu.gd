extends Control


func _on_start_button_pressed():
	if Global.intro_played:
		get_tree().change_scene_to_file("res://scenes/world.tscn")
	else:
		Global.intro_played = true
		get_tree().change_scene_to_file("res://scenes/intro.tscn")

func _on_options_button_pressed():
	pass # Replace with function body.


func _on_credits_button_pressed():
	pass # Replace with function body.


func _on_quit_button_pressed():
	get_tree().quit()
