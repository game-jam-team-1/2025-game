class_name GunAmmo
extends Ammo
## Basic gun bullet
##
## Scene: item/weapon/ammo/gun_ammo.tscn

var velocity: Vector2

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	position += velocity * delta
	rotation = velocity.angle()

func shoot(pos: Vector2, direction: Vector2, speed: float) -> void:
	global_position = pos
	velocity = direction * speed

## Connected from [signal body_entered]
func _on_body_entered(body: Node2D) -> void:
	queue_free()
