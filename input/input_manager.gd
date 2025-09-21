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
var buttons: Array[InputButton]

func _ready() -> void:
	var keyboard: Controller = Controller.new(Controller.Type.KEYBOARD, 0)
	controllers.append(keyboard)
	new_controller.emit(keyboard)
	var joypads: Array[int] = Input.get_connected_joypads()
	for id: int in joypads:
		var controller: Controller = Controller.new(Controller.Type.GAMEPAD, id)
		controllers.append(controller)
		new_controller.emit(controller)
	
	for action: StringName in InputMap.get_actions():
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		var button: InputButton = InputButton.new(events)
		button.input_name = action
		buttons.append(button)

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
	assert(false, "Tried to get a button but that button does not exist: " + button_name)
	return null

## Returns true if the button exists in the input map.
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
