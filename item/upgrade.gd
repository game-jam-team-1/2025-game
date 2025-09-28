class_name Upgrade
extends Resource

## Unique identifier
@export var upgrade_id: String
@export var description: String

## Array of upgrades this upgrade unlocks when applied
@export var unlocks: Array[Upgrade]

func apply_upgrade(player: Player) -> void:
	pass
