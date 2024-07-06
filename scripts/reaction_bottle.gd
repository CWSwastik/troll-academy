extends StaticBody3D


var active = false

func start_reaction():
	active = true
	$Hiss.play()
	await get_tree().create_timer(10.0).timeout
	$Hiss.stop()
	explode()
	
	
	
func explode():
	$Explosion.play()
	await get_tree().create_timer(1.0).timeout
	self.visible = false
	await $Explosion.finished
	queue_free()
	Global.quest_complete(6)
