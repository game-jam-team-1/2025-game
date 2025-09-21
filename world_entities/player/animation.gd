class_name PlayerAnimation
extends AnimatedSprite2D

const LAND_ANIM_MIN_TIME: float = 0.1

var skin_id: int:
	get:
		return player.skin_id

var land_anim_timer: float = 0.0

@onready var player: Player = $"../"
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


func _on_player_landed() -> void:
	play("jump_land")
	land_anim_timer = LAND_ANIM_MIN_TIME
