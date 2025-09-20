class_name InputButton
extends Resource

enum ButtonState {
	NOT_THIS, ## If the event was not this button.
	PRESSED, ## If the button was pressed last frame and this frame.
	RELASED, ## If the button was released last frame and this frame.
	JUST_PRESSED, ## If the button was released last frame and pressed this frame.
	JUST_RELEASED, ## If the button was pressed last frame and released this frame.
	ANALOGUE, ## If this input is analogue and so cannot be pressed.
}

## Internal button state.
var _state: ButtonState = ButtonState.RELASED

## Internal button state axis.
var _axis: float = 0

## Name of this input, that gets passed to controllers.
@export var input_name: String

## Events that will trigger this InputButton.
@export var valid_events: Array[InputEvent] 

## Analogue inputs will be changed to be only 1 or 0.
@export var analogue_to_pressed: bool = false

## Check if two events have the same code.
static func check_events_equal(check_event: InputEvent, our_event: InputEvent) -> bool:
	if our_event is InputEventKey && check_event is InputEventKey:
		var our_as_key: InputEventKey = our_event as InputEventKey
		var check_as_key: InputEventKey = check_event as InputEventKey
		if our_as_key.keycode == check_as_key.keycode:
			return true
	if our_event is InputEventMouseButton && check_event is InputEventMouseButton:
		var our_as_mb: InputEventMouseButton = our_event as InputEventMouseButton
		var check_as_mb: InputEventMouseButton = check_event as InputEventMouseButton
		if our_as_mb.button_index == check_as_mb.button_index:
			return true
	if our_event is InputEventJoypadButton && check_event is InputEventJoypadButton:
		var our_as_button: InputEventJoypadButton = our_event as InputEventJoypadButton
		var check_as_button: InputEventJoypadButton = check_event as InputEventJoypadButton
		if our_as_button.button_index == check_as_button.button_index:
			return true
	if our_event is InputEventJoypadMotion && check_event is InputEventJoypadMotion:
		var our_as_motion: InputEventJoypadMotion = our_event as InputEventJoypadMotion
		var check_as_motion: InputEventJoypadMotion = check_event as InputEventJoypadMotion
		if our_as_motion.axis == check_as_motion.axis:
			return true
	return false

## Check if an [class InputEvent] is on this button.
func is_event_this(check_event: InputEvent) -> bool:
	for our_event: InputEvent in valid_events:
		if check_events_equal(check_event, our_event):
			return true
	return false

func get_state_with_input(input: InputEvent) -> ButtonState:
	if !is_event_this(input):
		return ButtonState.NOT_THIS
	if input is InputEventJoypadMotion && !analogue_to_pressed:
		var as_motion: InputEventJoypadMotion = input as InputEventJoypadMotion
		_axis = as_motion.axis_value
		return ButtonState.ANALOGUE
	if _state == ButtonState.RELASED && input.is_pressed():
		_axis = 1.0
		_state = ButtonState.PRESSED
		return ButtonState.JUST_PRESSED
	if _state == ButtonState.PRESSED && input.is_released():
		_axis = 0.0
		_state = ButtonState.RELASED
		return ButtonState.JUST_RELEASED
	return _state

func is_pressed() -> bool:
	return _state == ButtonState.PRESSED

func is_released() -> bool:
	return _state == ButtonState.PRESSED

func get_axis() -> float:
	return _axis
