# GdUnit generated TestSuite
class_name ControllerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://input/controller.gd'

func test_is_input_this_controller() -> void:
	var controller: Controller = Controller.new(Controller.Type.KEYBOARD, 1)
	var key: InputEventKey = InputEventKey.new()
	var mouse: InputEventMouseButton = InputEventMouseButton.new()
	var joypad: InputEventJoypadButton = InputEventJoypadButton.new()
	var analogue: InputEventJoypadMotion = InputEventJoypadMotion.new()
	joypad.device = 1
	analogue.device = 1
	assert_bool(controller.is_input_this_controller(key)).is_true()
	assert_bool(controller.is_input_this_controller(mouse)).is_true()
	assert_bool(controller.is_input_this_controller(joypad)).is_false()
	assert_bool(controller.is_input_this_controller(analogue)).is_false()
	controller.type = Controller.Type.GAMEPAD
	assert_bool(controller.is_input_this_controller(key)).is_false()
	assert_bool(controller.is_input_this_controller(mouse)).is_false()
	assert_bool(controller.is_input_this_controller(joypad)).is_true()
	assert_bool(controller.is_input_this_controller(analogue)).is_true()
	joypad.device = 2
	analogue.device = 2
	assert_bool(controller.is_input_this_controller(joypad)).is_false()
	assert_bool(controller.is_input_this_controller(analogue)).is_false()
	
