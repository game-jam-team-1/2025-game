class_name Pushable
extends Node2D

@export var parent: CharacterBody2D
@export var detection_area: Area2D

@export var pushability_factor: float = 0.5  # scale the push force

var push_force := Vector2.ZERO

func get_push_force() -> Vector2:
	if !detection_area or !parent:
		return Vector2.ZERO
	
	var target_push_force := Vector2.ZERO
	
	for body in detection_area.get_overlapping_bodies():
		if body is CharacterBody2D and body != parent:
			# Use input_velocity if available
			var body_vel: Vector2 = body.velocity
			if body.has_method("get_input_velocity"):
				body_vel = body.get_input_velocity()
			
			# Determine direction relative to parent
			var position_dif: float = body.global_position.x - parent.global_position.x
			
			# Only push if moving towards each other
			if (position_dif > 0 and body_vel.x < 0) or (position_dif < 0 and body_vel.x > 0):
				target_push_force.x += body_vel.x * pushability_factor
	
	# Smoothly lerp push_force towards target_push_force
	push_force = push_force.lerp(target_push_force, 0.5)
	
	return push_force
