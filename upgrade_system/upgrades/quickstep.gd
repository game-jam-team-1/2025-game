# quickstep.gd
extends Upgrade


func _init() -> void:
	name = "Quickstep"
	description = "Makes you move faster"
	

func apply_upgrade(player: Player) -> void:
	player.movement.walk_speed += 50
