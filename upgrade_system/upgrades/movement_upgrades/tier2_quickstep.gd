class_name Tier2Quickstep
extends Upgrade


func _init() -> void:
	id = "tier2_quickstep"
	tier = 2
	unlock_ids = ["teir3_dash"]
	
	display_name = "Quickstep II"
	display_description = "Makes you move even faster"

func apply_upgrade(player: Player) -> void:
	player.movement.walk_speed += 50
