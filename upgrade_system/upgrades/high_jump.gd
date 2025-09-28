# high_jump.gd
extends Upgrade


func _init() -> void:
	name = "High Jump"
	description = "Makes you jump higher"

func apply_upgrade(player: Player) -> void:
	player.movement.jump_force += 500
