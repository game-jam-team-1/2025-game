class_name ItemResource
extends Resource

## Tier should be from 1 upwards.
@export var tier: int

## Scene of this weapon.
@export var scene: PackedScene

func _init(new_tier: int = 0) -> void:
	tier = new_tier
