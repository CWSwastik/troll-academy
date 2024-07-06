extends StaticBody3D


func hack():
	Global.quest_complete(4)
	AudioServer.set_bus_volume_db(1, linear_to_db(0.2))
	$AudioStreamPlayer.play()
	await $AudioStreamPlayer.finished
	AudioServer.set_bus_volume_db(1, linear_to_db(1))	
