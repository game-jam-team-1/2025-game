class_name Tier1Quickstep
extends Upgrade

func _init() -> void:
	id = "tier1_quickstep"
	tier = 1
	unlock_ids = ["teir2_high_jump", "teir2_quickstep"]
	
	display_name = "Quickstep I"
	display_description = "Makes you move faster"

func apply_upgrade(player: Player) -> void:
	player.movement.walk_speed += 50
