extends Control

@onready var inv_texture_rect = $Inventory/Item/TextureRect

func _on_player_inventory_update(inventory):
	inv_texture_rect.visible = len(inventory) > 0
		


func _on_whoopie_cushion_whoopie_troll_sucess():
	$Notification.visible = true
	$QuestBox.visible = false
