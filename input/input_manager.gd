class_name SingletonInputManager
extends Node
## Manages input and supports couch multiplayer.
##
## To use InputManager, register a device (-1 for keyboard) with a player using
## [method register_controller]. That method will return the [class Controller]
## that you can use for inputs. To not reparent the controller.

## Emits if a button is pressed.
signal button_pressed(event_name: String, controller: Controller)

## Emits if a button is released.
signal button_released(event_name: String, controller: Controller)

## Emitted when a new controller is connected.
signal new_controller(controller: Controller)

## An array of all the current controllers. A controller is not neccesarily associated with a player.
var controllers: Array[Controller]

## An array of buttons, these have names that will be used in all of the functions.
var buttons: Array[InputButton]

func _ready() -> void:
	InputMap.load_from_project_settings()
	for action: StringName in InputMap.get_actions():
		if action.begins_with("ui"):
			continue
		var events: Array[InputEvent] = InputMap.action_get_events(action)
		var button: InputButton = InputButton.new(events)
		button.input_name = action
		buttons.append(button)
	
	add_controller(Controller.Type.KEYBOARD, -1)
	var joypads: Array[int] = Input.get_connected_joypads()
	for id: int in joypads:
		add_controller(Controller.Type.GAMEPAD, id)

func _process(_delta: float) -> void:
	for controller: Controller in controllers:
		controller.pre_inputs()
	
	var joypads: Array[int] = Input.get_connected_joypads()
	for id: int in joypads:
		var has_controller_with_id: bool = false
		for controller: Controller in controllers:
			if controller.device_id == id:
				has_controller_with_id = true
				break
		
		if !has_controller_with_id:
			add_controller(Controller.Type.GAMEPAD, id)

func _input(event: InputEvent) -> void:
	for controller: Controller in controllers:
		controller.apply_input(event)

## Private, a button was just pressed on a controller.
func _button_just_pressed(button: String, controller: Controller) -> void:
	button_pressed.emit(button, controller)

## Private, a button was just released on a controller.
func _button_just_released(button: String, controller: Controller) -> void:
	button_released.emit(button, controller)

## Registers a controller with the device_id to a player_id, then returns the controller.
func register_controller(device_id: int, player_id: int) -> Controller:
	var controller: Controller = get_controller_from_device(device_id)
	if controller == null:
		return null
	controller.player_id = player_id
	return controller

## Unregister a controller with the player_id. That controller will now have an
## id of -1.
func unregister_controller(player_id: int) -> void:
	var controller: Controller = get_controller_from_player(player_id)
	if controller == null:
		return
	controller.player_id = -1

## Adds a controller with this type and controller ID.
func add_controller(type: Controller.Type, id: int) -> void:
	var controller: Controller = Controller.new(type, id)
	add_custom_controller(controller)

## Adds a custom controller object.
func add_custom_controller(controller: Controller) -> void:
	var duplicated: Array[InputButton] = []
	for button in buttons:
		duplicated.append(button.duplicate(true))
	controller.buttons = duplicated
	controllers.append(controller)
	controller.button_pressed.connect(_button_just_pressed.bind(controller))
	controller.button_released.connect(_button_just_released.bind(controller))
	add_child(controller)
	new_controller.emit(controller)

## Gets the controller with the player id, or returns null.
func get_controller_from_player(player: int) -> Controller:
	for controller: Controller in controllers:
		if controller.player_id == player:
			return controller
	return null

## Gets a [class Controller] from a physical device. (-1 is keyboard).
func get_controller_from_device(device: int) -> Controller:
	for controller: Controller in controllers:
		if controller.device_id == device:
			return controller
	return null

## Check if a button is pressed on the player. It is better to get the controller
## and always check on that.
func is_button_pressed(button_name: String, player: int) -> bool:
	var controller: Controller = get_controller_from_player(player)
	if controller == null:
		return false
	return controller.is_button_pressed(button_name)

## Check if a button is released on the player. It is better to get the controller
## and always check on that.
func is_button_released(button_name: String, player: int) -> bool:
	return !is_button_pressed(button_name, player)

func get_available_devices() -> Array[int]:
	var out: Array[int] = []
	for controller in controllers:
		if controller.player_id == -1:
			out.append(controller.device_id)
	return out

func get_registered_controllers() -> Array[Controller]:
	var out: Array[Controller] = []
	for controller in controllers:
		if controller.player_id != -1:
			out.append(controller)
	return out
