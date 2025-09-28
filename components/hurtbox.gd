class_name Hurtbox
extends Area2D

signal hit(knockback_force: float, knockback_direciton: Vector2, by: Player)

@export var player: Player
@export var health: Health

func damage(amount: float, force: float, dir: Vector2, by: Player) -> void:
	health.damage(amount, by)
	hit.emit(force, dir, by)
