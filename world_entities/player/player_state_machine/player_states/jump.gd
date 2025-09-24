class_name PlayerJump
extends PlayerState


func enter() -> void:
	player.movement.apply_jump_force()

func exit() -> void:
	pass

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	player.movement.push_off_overhead_blocks()
	
	player.movement.apply_walking_movement(delta)
	player.movement.apply_push_force(delta)
	player.movement.apply_gravity(delta)
	player.move_and_slide()
	
	if player.velocity.y > 0:
		return player_sm.fall_state
	
	if player.is_on_floor_custom():
		return player_sm.idle_state
	
	return null
