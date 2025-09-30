class_name PlayerUpgradeManager
extends Node

var player: Player

## Upgrades that the player has gotten
var owned_upgrades: Array[Upgrade] = []

## Pool of upgrades that can appear when you level up
var choosable_upgrades: Array[Upgrade] = []


func _ready() -> void:
	choosable_upgrades = get_beginning_upgrades()


## Get the upgrades the player can choose from the beginning
func get_beginning_upgrades() -> Array[Upgrade]:
	var beginning_upgrades: Array[Upgrade] = []
	
	for upgrade: Upgrade in UpgradeBank.upgrades_array:
		if upgrade.tier == 1:
			beginning_upgrades.append(upgrade)
	
	return beginning_upgrades


## Shuffles and returns the first n upgrades in the upgrade pool
func roll_choosable_upgrades(amount: int) -> Array[Upgrade]:
	choosable_upgrades.shuffle()
	return choosable_upgrades.slice(0, amount)


## Applies the upgrade, removes it from the choosable array,
## and adds the proper unlocks to the pool
func apply_upgrade(upgrade: Upgrade) -> void:
	upgrade.apply_upgrade(player) # Apply to player
	
	owned_upgrades.append(upgrade)
	choosable_upgrades.erase(upgrade)
	
	for id: String in upgrade.unlock_ids:
		var unlocked_upgrade: Upgrade = UpgradeBank.upgrades_by_id[id]
		choosable_upgrades.append(unlocked_upgrade)
