class_name Player
extends CharacterBody2D

@export var debug: bool = false

@export var controller_id: int = 0  ## The controller device the player is using, also seen as player_id
var skin_id: int = 0  ## Player appearance / skin / character

var facing_direction: int = 1  ## -1 is left, 1 is right

## Velocity is changed after move and slide
## this tracks wanted velocity (If no walls)
var input_velocity: Vector2 = Vector2.ZERO


@onready var state_machine: PlayerStateMachine = $"StateMachine"

@onready var movement: PlayerMovement = $"Movement"

func _ready() -> void:
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
