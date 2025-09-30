class_name Controller
extends Node
## Controller is the abstraction for the gamepad/keyboard associated with a player.

## A button was pressed on this controller.
signal button_pressed(button_name: String)

## A button was released on this controller.
signal button_released(button_name: String)

enum Type {
	KEYBOARD = 0,
	GAMEPAD = 1,
}

var type: Type ## Whether this is a keyboard or a gamepad controller.
var device_id: int ## If this is a gamepad controller, the id of that controller.
var player_id: int = -1 ## This is -1 if the controller has no player.

## An array of buttons, these have names that will be used in all of the functions.
var buttons: Array[InputButton]

## Do not access this directly. Array of buttons that were just pressed.
var _just_pressed_array: Array[String]

## Do not access this directly. Array of buttons that were just released.
var _just_released_array: Array[String]

func _init(set_type: Type, set_controller_id: int) -> void:
	type = set_type
	device_id = set_controller_id

## Check if a input event should be applied on this controller.
func is_input_this_controller(event: InputEvent) -> bool:
	if (event is InputEventKey || event is InputEventMouseButton) && type == Type.KEYBOARD:
		return true
	if (event is InputEventJoypadMotion || event is InputEventJoypadButton) && type == Type.GAMEPAD && event.device == device_id:
		return true
	return false

func pre_inputs() -> void:
	_just_pressed_array = []
	_just_released_array = []

## Attempt to apply an input to this controller. Typically you would not call
## this.
func apply_input(event: InputEvent) -> void:
	if !is_input_this_controller(event):
		return
	for button in buttons:
		var state: InputButton.ButtonState = button.get_state_with_input(event)
		if state == InputButton.ButtonState.NOT_THIS:
			continue
		if state == InputButton.ButtonState.JUST_PRESSED:
			button_pressed.emit(button.input_name)
			_just_pressed_array.append(button.input_name)
		if state == InputButton.ButtonState.JUST_RELEASED:
			button_released.emit(button.input_name)
			_just_released_array.append(button.input_name)

## Gets the [class InputButton] associated with the name.
func get_button(button_name: String) -> InputButton:
	for button in buttons:
		if button.input_name == button_name:
			return button
	assert(false, "Tried to get a button but that button does not exist: " + button_name)
	return null

## Returns true if the button exists in the controller's input map.
func has_button(button_name: String) -> bool:
	for button in buttons:
		if button.input_name == button_name:
			return true
	return false

## Gets the axis between two buttons (between -1 and 1)
func get_button_axis(left: String, right: String) -> float:
	return clamp(get_button(right).get_axis() - get_button(left).get_axis(), -1.0, 1.0)

## Checks if a button is pressed currently.
func is_button_pressed(button_name: String) -> bool:
	return get_button(button_name).is_pressed()

## Checks if a button is released currently.
func is_button_released(button_name: String) -> bool:
	return !is_button_pressed(button_name)

## Checks if a button was just pressed.
func is_button_just_pressed(button_name: String) -> bool:
	return _just_pressed_array.has(button_name)

## Checks if a button was just released.
func is_button_just_released(button_name: String) -> bool:
	return _just_released_array.has(button_name)
