# GdUnit generated TestSuite
class_name InputButtonTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://input/input_button.gd'

var button: InputButton
var key: InputEventKey
var mouse: InputEventMouseButton
var joy: InputEventJoypadMotion

func before_test() -> void:
	key = InputEventKey.new()
	key.keycode = Key.KEY_SPACE
	mouse = InputEventMouseButton.new()
	mouse.button_index = MOUSE_BUTTON_LEFT
	joy = InputEventJoypadMotion.new()
	joy.axis = JOY_AXIS_LEFT_X
	button = InputButton.new([key, mouse, joy])

func test_check_events_equal() -> void:
	var key_1: InputEventKey = InputEventKey.new()
	var key_2: InputEventKey = InputEventKey.new()
	key_1.keycode = Key.KEY_SPACE
	key_2.keycode = Key.KEY_SPACE
	key_1.device = 2
	key_2.pressed = true
	assert_bool(InputButton.check_events_equal(key_1, key_2)).is_true()
	key_2.keycode = Key.KEY_BACKSLASH
	assert_bool(InputButton.check_events_equal(key_1, key_2)).is_false()
	var mouse_1: InputEventMouseButton = InputEventMouseButton.new()
	var mouse_2: InputEventMouseButton = InputEventMouseButton.new()
	mouse_1.button_index = MOUSE_BUTTON_LEFT
	mouse_2.button_index = MOUSE_BUTTON_LEFT
	mouse_1.pressed = true
	mouse_2.device = 2
	assert_bool(InputButton.check_events_equal(mouse_1, mouse_2)).is_true()
	mouse_2.button_index = MOUSE_BUTTON_RIGHT
	assert_bool(InputButton.check_events_equal(mouse_1, mouse_2)).is_false()
	var button_1: InputEventJoypadButton = InputEventJoypadButton.new()
	var button_2: InputEventJoypadButton = InputEventJoypadButton.new()
	button_1.button_index = JOY_BUTTON_A
	button_2.button_index = JOY_BUTTON_A
	button_1.pressed = true
	button_2.device = 2
	assert_bool(InputButton.check_events_equal(button_1, button_2)).is_true()
	button_2.button_index = JOY_BUTTON_B
	assert_bool(InputButton.check_events_equal(button_1, button_2)).is_false()
	var motion_1: InputEventJoypadMotion = InputEventJoypadMotion.new()
	var motion_2: InputEventJoypadMotion = InputEventJoypadMotion.new()
	motion_1.axis = JOY_AXIS_LEFT_X
	motion_2.axis = JOY_AXIS_LEFT_X
	motion_1.axis_value = -1
	motion_2.axis_value = 1
	motion_1.device = 2
	assert_bool(InputButton.check_events_equal(motion_1, motion_2)).is_true()
	motion_2.axis = JOY_AXIS_LEFT_Y
	assert_bool(InputButton.check_events_equal(motion_1, motion_2)).is_false()

func test_is_event_equal() -> void:
	assert_bool(button.is_event_this(key)).is_true()
	assert_bool(button.is_event_this(mouse)).is_true()
	assert_bool(button.is_event_this(InputEventKey.new())).is_false()

func test_state() -> void:
	assert_int(button.get_state_with_input(InputEventKey.new())).is_equal(InputButton.ButtonState.NOT_THIS)
	key.pressed = true
	assert_int(button.get_state_with_input(key)).is_equal(InputButton.ButtonState.JUST_PRESSED)
	assert_bool(button.is_pressed()).is_true()
	assert_bool(button.is_released()).is_false()
	assert_float(button.get_axis()).is_equal_approx(1.0, 0.01)
	assert_int(button.get_state_with_input(key)).is_equal(InputButton.ButtonState.PRESSED)
	key.pressed = false
	assert_int(button.get_state_with_input(key)).is_equal(InputButton.ButtonState.JUST_RELEASED)
	assert_bool(button.is_pressed()).is_false()
	assert_bool(button.is_released()).is_true()
	assert_int(button.get_state_with_input(key)).is_equal(InputButton.ButtonState.RELEASED)
	assert_float(button.get_axis()).is_equal_approx(0.0, 0.01)
	joy.axis_value = 0.5
	assert_int(button.get_state_with_input(joy)).is_equal(InputButton.ButtonState.ANALOGUE)
	assert_float(button.get_axis()).is_equal_approx(joy.axis_value, 0.01)
	button.analogue_to_pressed = true
	joy.axis_value = 1.0
	assert_int(button.get_state_with_input(joy)).is_equal(InputButton.ButtonState.JUST_PRESSED)
	assert_bool(button.is_pressed()).is_true()
	assert_bool(button.is_released()).is_false()
	assert_int(button.get_state_with_input(joy)).is_equal(InputButton.ButtonState.PRESSED)
	assert_float(button.get_axis()).is_equal_approx(1.0, 0.01)
	joy.axis_value = 0.0
	assert_int(button.get_state_with_input(joy)).is_equal(InputButton.ButtonState.JUST_RELEASED)
	assert_bool(button.is_pressed()).is_false()
	assert_bool(button.is_released()).is_true()
	assert_int(button.get_state_with_input(joy)).is_equal(InputButton.ButtonState.RELEASED)
	assert_float(button.get_axis()).is_equal_approx(0.0, 0.01)
