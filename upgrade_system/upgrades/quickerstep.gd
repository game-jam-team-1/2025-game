# quickerstep.gd
extends Upgrade


func _init() -> void:
	name = "Quickerstep"
	description = "Makes you move even faster"

func apply_upgrade(player: Player) -> void:
	player.movement.walk_speed += 100
