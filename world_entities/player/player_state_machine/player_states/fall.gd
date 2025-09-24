class_name PlayerFall
extends PlayerState

signal landed()


func enter() -> void:
	pass

func exit() -> void:
	pass

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	player.movement.apply_walking_movement(delta)
	player.movement.apply_push_force(delta)
	player.movement.apply_gravity(delta)
	player.move_and_slide()
	
	if player.is_on_floor_custom():
		
		landed.emit()
		
		if player.movement.is_walk_requested():
			return player_sm.walk_state
		else:
			return player_sm.idle_state
	
	return null
