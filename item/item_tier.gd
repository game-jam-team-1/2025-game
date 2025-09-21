class_name ItemTier
extends Resource
## Tier of items, generated

## The tier.
@export var tier: int 

## Items on this tier, make sure to duplicate.
@export var items: Array[ItemResource]

func _init(new_tier: int) -> void:
	tier = new_tier

## Removes items of this tier from pool and returns the array without those.
func retreive_from_pool(pool: Array[ItemResource]) -> Array[ItemResource]:
	var to_remove: Array[int]
	for i: int in range(pool.size()):
		var this: ItemResource = pool[i]
		if this.tier == tier:
			to_remove.append(i)
			items.append(this)
	to_remove.sort()
	to_remove.reverse()
	for index in to_remove:
		pool.pop_at(index)
	return pool
