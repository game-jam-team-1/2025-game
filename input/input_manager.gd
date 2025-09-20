class_name SingletonInputManager
extends Node
## Manages input and supports couch multiplayer.

## Emits if a button is pressed.
signal button_pressed(event_name: String, player_id: int, event: InputEvent)

## Emits if a button is released.
signal button_released(event_name: String, player_id: int, event: InputEvent)

## Emitted when a new controller is connected.
signal new_controller(controller: Controller)

## An array of all the current controllers. A controller is not neccesarily associated with a player.
var controllers: Array[Controller]

## An array of buttons, these have names that will be used in all of the functions.
@export var buttons: Array[InputButton]

func _ready() -> void:
	var keyboard: Controller = Controller.new(Controller.Type.KEYBOARD, 0)
	controllers.append(keyboard)
	new_controller.emit(keyboard)
	var joypads: Array[int] = Input.get_connected_joypads()
	for id: int in joypads:
		var controller: Controller = Controller.new(Controller.Type.GAMEPAD, id)
		controllers.append(controller)
		new_controller.emit(controller)

func _process(_delta: float) -> void:
	var joypads: Array[int] = Input.get_connected_joypads()
	for id: int in joypads:
		var has_controller_with_id: bool = false
		for controller: Controller in controllers:
			if controller.device_id == id:
				has_controller_with_id = true
				break
		
		if !has_controller_with_id:
			var controller: Controller = Controller.new(Controller.Type.GAMEPAD, id)
			controllers.append(controller)
			new_controller.emit(controller)

func _input(event: InputEvent) -> void:
	for controller: Controller in controllers:
		if controller.is_input_this_controller(event):
			_handle_input_with_controller(event, controller)

## Internal, handles an event on a specific controller.
func _handle_input_with_controller(event: InputEvent, controller: Controller) -> void:
	for button in buttons:
		var state: InputButton.ButtonState = button.get_state_with_input(event)
		if state == InputButton.ButtonState.NOT_THIS:
			continue
		if state == InputButton.ButtonState.JUST_PRESSED:
			button_pressed.emit(button.input_name, controller.player_id, event)
		if state == InputButton.ButtonState.JUST_RELEASED:
			button_released.emit(button.input_name, controller.player_id, event)

## Gets the [class InputButton] associated with the name.
func get_button(button_name: String) -> InputButton:
	for button in buttons:
		if button.input_name == button_name:
			return button
	assert(false, "Tried to ask if a button was pressed but that button does not exist.")
	return null

## Gets the axis between two buttons (between -1 and 1)
func get_button_axis(left: String, right: String) -> float:
	return get_button(right).get_axis() - get_button(left).get_axis()

## Checks if a button is pressed currently.
func is_button_pressed(button_name: String) -> bool:
	return get_button(button_name).is_pressed()

## Checks if a button is released currently.
func is_button_released(button_name: String) -> bool:
	return !is_button_pressed(button_name)

## Controller is the abstraction for the gamepad/keyboard associated with a player.
class Controller:
	enum Type {
		KEYBOARD = 0,
		GAMEPAD = 1,
	}
	
	var type: Type ## Whether this is a keyboard or a gamepad controller.
	var device_id: int ## If this is a gamepad controller, the id of that controller.
	var player_id: int = -1 ## This is -1 if the controller has no player.
	
	func _init(set_type: Type, set_controller_id: int) -> void:
		type = set_type
		device_id = set_controller_id
	
	func is_input_this_controller(event: InputEvent) -> bool:
		var event_is_action: bool = false
		for action: StringName in InputMap.get_actions():
			if InputMap.event_is_action(event, action):
				event_is_action = true
				break
		if !event_is_action:
			return false
		
		if (event is InputEventKey || event is InputEventMouseButton) && type == Type.KEYBOARD:
			return true
		if (event is InputEventJoypadMotion || event is InputEventJoypadButton) && type == Type.GAMEPAD && event.device == device_id:
			return true
		return false
