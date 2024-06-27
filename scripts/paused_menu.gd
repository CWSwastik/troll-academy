extends Control

var _is_paused: bool = false:
	set = set_paused
	
func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		_is_paused = not _is_paused
		
func set_paused(value: bool) -> void:
	_is_paused = value
	if _is_paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	get_tree().paused = _is_paused
	visible = _is_paused
	
	
func _on_resume_button_pressed():
	_is_paused = false


func _on_settings_button_pressed():
	get_tree().change_scene_to_file("res://scenes/settings_page.tscn")


func _on_quit_button_pressed():
	get_tree().quit()
