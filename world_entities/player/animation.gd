class_name PlayerAnimation
extends AnimatedSprite2D
## Player animation code.

## Min (or max?) time the animation can run for.
const LAND_ANIM_MIN_TIME: float = 0.1

## Player's skin, aka appearance.
var skin_id: int:
	get:
		return player.skin_id

## TODO: Make this thing better. Feels like spaghetti code.
##
## Time in seconds the land animation has left.
var land_anim_timer: float = 0.0

## Do not set values direclty using this.
@onready var player: Player = $"../"

## [class PlayerStateMachine].
@onready var player_sm: PlayerStateMachine = $"../StateMachine"

func _ready() -> void:
	await get_tree().process_frame
	player_sm.fall_state.landed.connect(_on_player_landed)

func _process(delta: float) -> void:
	scale.x = player.facing_direction * 3
	
	# Stop if jump_land is not done playing
	if animation.begins_with("jump_land") and land_anim_timer > 0:
		land_anim_timer -= delta
		return
	
	var anim_name := get_animation_name()
	if anim_name != animation:
		play(anim_name)

## Gets the name of the currently playing animation, based on the state.
func get_animation_name() -> String:
	match player_sm.current_state:
		player_sm.jump_state:
			return "jump_up"
		player_sm.fall_state:
			return "jump_down"
		player_sm.walk_state:
			return "walk"
		_:
			return "idle"

## Signal, from [signal PlayerStateMachine.landed].
func _on_player_landed() -> void:
	play("jump_land")
	land_anim_timer = LAND_ANIM_MIN_TIME
