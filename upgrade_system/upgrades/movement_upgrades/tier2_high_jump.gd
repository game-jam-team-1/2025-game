class_name Tier2HighJump
extends Upgrade


func _init() -> void:
	id = "tier2_high_jump"
	tier = 2
	unlock_ids = ["teir3_dash"]
	
	display_name = "High Jump II"
	display_description = "Makes you jump higher"

func apply_upgrade(player: Player) -> void:
	player.movement.jump_force += 500
