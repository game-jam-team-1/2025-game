class_name Tier3Dash
extends Upgrade


func _init() -> void:
	id = "tier3_dash"
	tier = 3
	unlock_ids = []
	
	display_name = "Dash III"
	display_description = "Allows you to dash by pressing zzz"

func apply_upgrade(player: Player) -> void:
	pass
