class_name SingletonItemsManager
extends Node
## Stores all of the weapons and can randomly get weapons for each tier.

## All of the items that can be instantiated. Make sure to duplicate if accessing
## on of these resources.
@export var item_pool: Array[ItemResource]

## All of the tiers of items, ordered by index 0 -> 1, 2 -> 3, etc.
@export var tiers: Array[ItemTier]

func _ready() -> void:
	var tier_num: int = 1
	var copied_pool: Array[ItemResource] = item_pool
	while !copied_pool.is_empty():
		var tier: ItemTier = ItemTier.new()
		tier.tier = tier_num
		copied_pool = tier.retreive_from_pool(copied_pool)
		tier_num += 1

## Gets a random item from any tier.
func get_random_item() -> ItemResource:
	return item_pool.pick_random().duplicate_deep()

## Gets a random item from a specific tier.
func get_random_at_tier(tier: int) -> ItemResource:
	return tiers[tier - 1].items.pick_random().duplicate_deep()
