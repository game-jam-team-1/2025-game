# GdUnit generated TestSuite
class_name ControllerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://input/controller.gd'

var controller: Controller
var button_1: InputButton
var button_2: InputButton

func before_test() -> void:
	controller = Controller.new(Controller.Type.KEYBOARD, 1)
	var singleton: SingletonInputManager = SingletonInputManager.new()
	singleton._ready()
	singleton.add_custom_controller(controller)
	singleton.remove_child(controller)
	singleton.free()

func test_get_button() -> void:
	assert_str(controller.get_button("ui_accept").input_name).is_equal("ui_accept")

func test_is_input_this_controller() -> void:
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

func test_get_button_axis() -> void:
	button_1 = InputButton.new()
	button_1.input_name = "button_1"
	button_2 = InputButton.new()
	button_2.input_name = "button_2"
	controller.buttons.append_array([button_1, button_2])
	button_1._axis = 1
	assert_float(controller.get_button_axis("button_1", "button_2")).is_equal_approx(-1.0, 0.01)
	button_2._axis = 1
	assert_float(controller.get_button_axis("button_1", "button_2")).is_equal_approx(0.0, 0.01)
	button_1._axis = 0
	assert_float(controller.get_button_axis("button_1", "button_2")).is_equal_approx(1.0, 0.01)
	button_2._axis = 0
	assert_float(controller.get_button_axis("button_1", "button_2")).is_equal_approx(0.0, 0.01)

func test_is_button_pressed() -> void:
	button_1 = InputButton.new()
	button_1.input_name = "button"
	controller.buttons.append(button_1)
	assert_bool(controller.is_button_released("button")).is_true()
	assert_bool(controller.is_button_pressed("button")).is_false()
	button_1._state = InputButton.ButtonState.PRESSED
	assert_bool(controller.is_button_pressed("button")).is_true()
	assert_bool(controller.is_button_released("button")).is_false()

func after_test() -> void:
	controller.free()
