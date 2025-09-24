class_name PlayerIdle
extends PlayerState

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	player.movement.slow_down_walking_movement(delta)
	
	player.movement.apply_push_force(delta)
	
	player.movement.apply_gravity(delta)
	
	player.move_and_slide()
	
	
	if player.movement.is_jump_just_pressed() && player.movement.can_jump():
		return player_sm.jump_state
	
	if player.velocity.y > 0:
		return player_sm.fall_state
	
	if player.movement.is_walk_requested():
		return player_sm.walk_state
	
	return null
