extends Control

@onready var texture_rect = $Inventory/Item/TextureRect

func _on_player_inventory_update(inventory):
	texture_rect.visible = len(inventory) > 0
		
