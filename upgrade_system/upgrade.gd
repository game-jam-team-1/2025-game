@abstract
class_name Upgrade
extends Resource

@export var name: String
@export_multiline var description: String

## Array of upgrades this upgrade unlocks when applied
@export var unlocks: Array[Upgrade]

@abstract
func apply_upgrade(player: Player) -> void
