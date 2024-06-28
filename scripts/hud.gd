extends Control

@onready var inv_texture_rect = $Inventory/Item/TextureRect

func _on_player_inventory_update(inventory):
	inv_texture_rect.visible = len(inventory) > 0
	if inventory:
		inv_texture_rect.texture = load(inventory[0].icon_path)

var prev_completed_quest = null

func _process(delta):
	if len(Global.completed_quests) < 1:
		return
		
	if Global.completed_quests[-1] != prev_completed_quest:
		$QuestBox/QuestTitle.text = Global.current_quest["name"]
		$QuestBox/QuestDesc.text = Global.current_quest["desc"]
		$QuestBox/Item/TextureRect.texture = load(Global.current_quest["logo"])
		
		# Old quest got completed
		$Notification/QuestTitle.text = Global.quests[Global.completed_quests[-1]]["name"]
		$Notification.visible = true
		await get_tree().create_timer(5.0).timeout
		$Notification.visible = false
			

	
	prev_completed_quest = Global.completed_quests[-1]
	
	
