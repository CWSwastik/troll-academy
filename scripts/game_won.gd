extends Control

func _ready():
	AudioPlayer.game_won()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE



func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_quit_button_pressed():
	get_tree().quit()