class_name GunAmmo
extends Ammo
## Basic gun bullet
##
## Scene: item/weapon/ranged/gun/gun_ammo.tscn

var velocity: Vector2

func _process(delta: float) -> void:
	position += velocity * delta
	rotation = velocity.angle()

func shoot(pos: Vector2, direction: Vector2, speed: float) -> void:
	global_position = pos
	velocity = direction * speed

func _hit_object(object: Node2D) -> void:
	if !_can_hit_object(object):
		return
	queue_free()
