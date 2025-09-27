class_name Player
extends CharacterBody2D
## A player, controller by a [class Controller].

## Emitted when health goes below or equal to 0. 'to' is who killed us.
signal died(to: Node)

## TODO: Replace this with a Global singleton debug.
@export var debug: bool = false

## Default weapon (probably [class Fists]).
@export var default_weapon: MeleWeapon

## Player ID, usually gonna be from 1-4.
var player_id: int = 0

## The [class Controller] that supplies input to this player.
var controller: Controller

## (Actually device_id). Device the controller uses. Should not need this?
var controller_id: int = -1

 ## Player appearance / skin / character
var skin_id: int = 0 

## -1 is left, 1 is right
var facing_direction: int = 1  

## Velocity is changed after move and slide
## this tracks wanted velocity (If no walls)
var input_velocity: Vector2 = Vector2.ZERO

@onready var hutbox: Hurtbox = $"Hurtbox"
@onready var state_machine: PlayerStateMachine = $"StateMachine"
@onready var movement: PlayerMovement = $"Movement"
@onready var holding_item: Item = default_weapon ## Item the player is currently holding.

func _ready() -> void:
	controller = InputManager.register_controller(controller_id, player_id)
	
	state_machine.init(self)
	state_machine.changed_state.connect(_on_changed_state)
	
	if holding_item:
		holding_item.notify_picked_up(self)

func _physics_process(delta: float) -> void:
	if controller.is_button_just_pressed("attack") && holding_item:
		holding_item.use_item()
	
	if holding_item:
		holding_item.enabled = true
		holding_item.follow_mouse(global_position, get_global_mouse_position())
	state_machine.process_physics(delta)
	input_velocity = velocity

## Use this instead of is_on_floor.
func is_on_floor_custom() -> bool:
	return is_on_floor()

## Gets input velocity from the controller.
func get_input_velocity() -> Vector2:
	return input_velocity

## Signal from the [class Health] node for when we die.
func _on_health_died(entity: Node) -> void:
	died.emit(entity)

## Signal from [signal StateMachine.changed_state].
func _on_changed_state(state: State) -> void:
	if debug:
		DebugLogger.info("Player State: %s" % [state.name])

func _on_hit() -> void:
	if holding_item && holding_item is Weapon:
		(holding_item as Weapon).attacked()
