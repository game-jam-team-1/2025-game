class_name PlayerUpgradeManager
extends Node

var player: Player
var upgrades: Array[Upgrade]

## Pool of upgrades that can appear upon leveling up
var upgrade_pool: Array[Upgrade]

## Shuffles and returns the first n upgrades in the upgrade pool
func roll_upgrades(amount: int) -> Array[Upgrade]:
	upgrade_pool.shuffle()
	return upgrade_pool.slice(0, amount)

## Applies the upgrade, removes it from the pool, and adds the proper unlocks to the pool
func apply_upgrade(upgrade: Upgrade) -> void:
	upgrades.append(upgrade)
	upgrade_pool.erase(upgrade)
	upgrade_pool.append_array(upgrade.unlocks)
