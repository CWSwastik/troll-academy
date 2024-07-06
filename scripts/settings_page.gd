extends Control

signal back_button_pressed


func _on_volume_value_changed(value):
	
	AudioServer.set_bus_volume_db(0, linear_to_db(value))


func _on_mute_toggled(toggled_on):
	AudioServer.set_bus_mute(0, toggled_on)


func _on_back_button_pressed():
	back_button_pressed.emit()
