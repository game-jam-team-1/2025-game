# GdUnit generated TestSuite
class_name SingletonItemsManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://item/items_manager.gd'

var singleton: SingletonItemsManager

func before_test() -> void:
	singleton = SingletonItemsManager.new()

func test_ready() -> void:
	var items: Array[ItemResource] = [ItemResource.new(1), ItemResource.new(1), ItemResource.new(2), ItemResource.new(4)]
	singleton.item_pool = items
	singleton._ready()
	assert_int(singleton.tiers.size()).is_equal(4)
	if is_failure(): return
	assert_int(singleton.tiers[0].items.size()).is_equal(2)
	assert_int(singleton.tiers[1].items.size()).is_equal(1)
	assert_int(singleton.tiers[2].items.size()).is_equal(0)
	assert_int(singleton.tiers[3].items.size()).is_equal(1)
	if is_failure(): return
	assert_int(singleton.tiers[0].items[0].tier).is_equal(1)
	assert_int(singleton.tiers[1].items[0].tier).is_equal(2)
	assert_int(singleton.tiers[3].items[0].tier).is_equal(4)

func after_test() -> void:
	singleton.free()
