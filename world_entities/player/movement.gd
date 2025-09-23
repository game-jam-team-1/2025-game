class_name PlayerMovement
extends Node2D

const jump_buffer_max_time: float = 0.01
const coyote_jump_max_time: float = 1.0

@export var gravity_force: float = 60.0
@export var walk_speed: float = 300.0
@export var jump_force: float = 1300.0

@export var slow_down_factor: float = 0.3

var jump_buffer_timer: float = 0.0
var coyote_jump_timer: float = 0.0

@onready var player: Player = get_parent()
@onready var pushable: Pushable = $"PushableComponent"

@onready var overhead_raycasts: Array[RayCast2D] = [
	$"RayCast1",
	$"RayCast2",
	$"RayCast3",
	$"RayCast4",
]

# Jump and timers

func _physics_process(delta: float) -> void:
	if jump_buffer_timer > 0:
		jump_buffer_timer -= delta
	
	if coyote_jump_timer > 0:
		coyote_jump_timer -= delta
	
	# TODO: Change to is_button_just_pressed
	if player.controller.is_button_pressed("jump"):
		jump_buffer_timer = jump_buffer_max_time
	
	if player.is_on_floor_custom():
		coyote_jump_timer = coyote_jump_max_time

# Walk

func is_walk_requested() -> bool:
	var dir: float = player.controller.get_button_axis("walk_left", "walk_right")
	return !is_zero_approx(dir)

func apply_walking_movement(delta: float) -> void:
	var dir: float = player.controller.get_button_axis("walk_left", "walk_right")
	
	if is_zero_approx(dir):
		slow_down_walking_movement(delta)
	else:
		player.velocity.x = walk_speed * dir * delta * 60
		
		if dir > 0:
			player.facing_direction = 1
		else:
			player.facing_direction = -1

func slow_down_walking_movement(delta: float) -> void:
	if is_zero_approx(player.velocity.x):
		player.velocity.x = 0.0
		return
	
	player.velocity.x = lerp(player.velocity.x, 0.0, slow_down_factor)


## JUMP

func is_jump_just_pressed() -> bool:
	return jump_buffer_timer > 0.0

func can_jump() -> bool:
	var inner_left = overhead_raycasts[1].is_colliding()
	var inner_right = overhead_raycasts[2].is_colliding()
	
	return coyote_jump_timer > 0.0 && !inner_left && !inner_right

func apply_jump_force() -> void:
	player.velocity.y = -jump_force

# If the player is just barly hitting their head on a block after a jump,
# this will push them a bit outwards 
func push_off_overhead_blocks() -> void:
	var outer_left := overhead_raycasts[0].is_colliding()
	var inner_left := overhead_raycasts[1].is_colliding()
	var inner_right := overhead_raycasts[2].is_colliding()
	var outer_right := overhead_raycasts[3].is_colliding()
	
	if outer_left && !inner_left && !outer_right && !inner_right:
		player.global_position.x += 20
	elif outer_right && !inner_right && !outer_left && !inner_left:
		player.global_position.x -= 20
	


## GRAVITY

func apply_gravity(delta: float) -> void:
	if !player.is_on_floor_custom():
		player.velocity.y += gravity_force * delta * 60


## PUSH

func apply_push_force(delta: float) -> void:
	#player.velocity += pushable.get_push_force()
	pass
