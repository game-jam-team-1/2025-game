@abstract
class_name Ammo
extends Hitbox
## Abstract class for bullet objects.

var exclude_bodies: Array[Node2D]

func _ready() -> void:
	body_entered.connect(_hit_object)

## If object is not in the exclude array.
func _can_hit_object(object: Node2D) -> bool:
	return !exclude_bodies.has(object)

## Shoot, starting at the position in the direction at the speed.
@abstract
func shoot(pos: Vector2, direction: Vector2, speed: float)

@abstract
func _hit_object(object: Node2D) -> void
