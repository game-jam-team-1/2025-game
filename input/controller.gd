class_name Controller
extends Object
## Controller is the abstraction for the gamepad/keyboard associated with a player.

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

## Check if a input event should be applied on this controller.
func is_input_this_controller(event: InputEvent) -> bool:
	if (event is InputEventKey || event is InputEventMouseButton) && type == Type.KEYBOARD:
		return true
	if (event is InputEventJoypadMotion || event is InputEventJoypadButton) && type == Type.GAMEPAD && event.device == device_id:
		return true
	return false
