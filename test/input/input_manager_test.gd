# GdUnit generated TestSuite
class_name SingletonInputManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://input/input_manager.gd'

var singleton: SingletonInputManager
var button_1: InputButton
var button_2: InputButton

func before_test() -> void:
	singleton = SingletonInputManager.new()
	singleton._ready()

func test_add_controller() -> void:
	singleton.add_controller(Controller.Type.GAMEPAD, 3)
	assert_int(singleton.controllers.size()).is_greater(0)
	if is_failure(): return
	assert_int(singleton.controllers[-1].type).is_equal(Controller.Type.GAMEPAD)
	assert_int(singleton.controllers[-1].device_id).is_equal(3)

func after_test() -> void:
	singleton.free()
