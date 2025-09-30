@abstract
class_name Upgrade
extends Resource


## Unique identifier (used in dictionary key)
@export var id: String

## How many upgrades it takes to get to this one
@export var tier: int

## The ids of the upgrades that will unlock after
## choosing this upgrade
@export var unlock_ids: Array[String]


## Name used in UI
@export var display_name: String

## Description used in UI
@export_multiline var display_description: String


@abstract
func apply_upgrade(player: Player) -> void
