extends StaticBody3D


func hack():
	Global.quest_complete(4)
	$AudioStreamPlayer.play()
