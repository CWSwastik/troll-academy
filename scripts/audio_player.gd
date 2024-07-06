extends Node

func _ready():
	$BGM.play()

func button_click():
	$ButtonClick.play()

func bruh():
	$Bruh.play()
	
func useful_item_pick():
	var i = randi_range(1, 2)
	match i:
		1:
			$Metic/Jackpot.play()
		2:
			$Metic/Handy.play()
			
func nice_job():
	var i = randi_range(1, 2)
	match i:
		1:
			$Metic/Hillarious.play()
		2:
			$Metic/NiceJob.play()	

func narrow_escape():
	var i = randi_range(1, 2)
	match i:
		1:
			$Metic/Phew.play()
		2:
			$Metic/Close.play()

func game_won():
	$Won.play()
