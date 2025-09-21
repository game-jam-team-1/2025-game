# GdUnit generated TestSuite
class_name SingletonInputManagerTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source: String = 'res://input/input_manager.gd'

@onready var scene: PackedScene = preload("uid://dxc2ul7nekin5")

var singleton: SingletonInputManager
var button_1: InputButton
var button_2: InputButton

func before_test() -> void:
	singleton = scene.instantiate()

func test_get_button() -> void:
	assert_str(singleton.get_button("space").input_name).is_equal("space")

func test_get_button_axis() -> void:
	button_1 = InputButton.new()
	button_1.input_name = "button_1"
	button_2 = InputButton.new()
	button_2.input_name = "button_2"
	singleton.buttons.append_array([button_1, button_2])
	button_1._axis = 1
	assert_float(singleton.get_button_axis("button_1", "button_2")).is_equal_approx(-1.0, 0.01)
	button_2._axis = 1
	assert_float(singleton.get_button_axis("button_1", "button_2")).is_equal_approx(0.0, 0.01)
	button_1._axis = 0
	assert_float(singleton.get_button_axis("button_1", "button_2")).is_equal_approx(1.0, 0.01)
	button_2._axis = 0
	assert_float(singleton.get_button_axis("button_1", "button_2")).is_equal_approx(0.0, 0.01)

func after_test() -> void:
	singleton.free()
