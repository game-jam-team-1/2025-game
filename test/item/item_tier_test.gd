# GdUnit generated TestSuite
class_name ItemTierTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://item/item_tier.gd'

var item_tier: ItemTier

func before_test() -> void:
	item_tier = ItemTier.new(1)

func test_retreive_from_pool() -> void:
	var items: Array[ItemResource] = [ItemResource.new(1), ItemResource.new(1), ItemResource.new(2), ItemResource.new(4)]
	var out: Array[ItemResource] = item_tier.retreive_from_pool(items)
	assert_int(out.size()).is_equal(2)
	assert_int(item_tier.items.size()).is_equal(2)
	if is_failure(): return
	assert_int(out[0].tier).is_equal(2)
	assert_int(out[1].tier).is_equal(4)
	assert_int(item_tier.items[0].tier).is_equal(1)
	assert_int(item_tier.items[1].tier).is_equal(1)
