class_name PlayerManager
extends Node
## Creates players at initialization based on controllers.

@export var generate_unregistered: bool = false
@export var spawn_points: Array[Marker2D]

@onready var player_scene: PackedScene = preload("uid://gxwhd0it1x17")

func _ready() -> void:
	var player_id: int = 0
	var registered: Array[Controller] = InputManager.get_registered_controllers()
	for controller: Controller in registered:
		if player_id > spawn_points.size():
			DebugLogger.error("Not enough spawn points for the amount of players!")
			break
		_spawn_player(spawn_points[player_id].global_position, player_id, controller.device_id)
		player_id += 1
	if !generate_unregistered:
		return
	var unregistered_devices: Array[int] = InputManager.get_available_devices()
	for device_id: int in unregistered_devices:
		if player_id > spawn_points.size():
			DebugLogger.error("Not enough spawn points for the amount of players!")
			break
		_spawn_player(spawn_points[player_id].global_position, player_id, device_id)

func _spawn_player(pos: Vector2, player_id: int, device_id: int) -> void:
	var player: Player = player_scene.instantiate()
	player.player_id = player_id
	player.controller_id = device_id
	get_parent().add_child.call_deferred(player)
	player.global_position = spawn_points[player_id].global_position
