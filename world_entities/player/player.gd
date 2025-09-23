class_name Player
extends CharacterBody2D

## Emitted when health goes below or equal to 0. To is who killed us.
signal died(to: Node)

@export var debug: bool = false

var player_id: int = 0

var controller: Controller
var controller_id: int = -1

var skin_id: int = 0  ## Player appearance / skin / character

var facing_direction: int = 1  ## -1 is left, 1 is right

## Velocity is changed after move and slide
## this tracks wanted velocity (If no walls)
var input_velocity: Vector2 = Vector2.ZERO


@onready var state_machine: PlayerStateMachine = $"StateMachine"

@onready var movement: PlayerMovement = $"Movement"


func _ready() -> void:
	controller = InputManager.register_controller(controller_id, player_id)
	
	state_machine.init(self)
	state_machine.changed_state.connect(change_state)


func change_state(state: State) -> void:
	if debug:
		DebugLogger.info("Player State: %s" % [state.name])


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	input_velocity = velocity


func is_on_floor_custom() -> bool:
	return is_on_floor()

func get_input_velocity() -> Vector2:
	return input_velocity

func _on_health_died(entity: Node) -> void:
	died.emit(entity)
