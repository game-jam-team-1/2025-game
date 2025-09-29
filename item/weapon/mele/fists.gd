class_name FistsWeapon
extends MeleWeapon
## Fists are always on the player.
## 
## SCENE: item/weapon/mele/fists.tscn

const player_dist_cutoff: float = 50.0
const mouse_force_multiplier: float = 100.0
const max_mouse_dist: float = 100.0
const player_force_multiplier: float = 500.0
const attack_force: float = 2000.0

@onready var collision: CollisionShape2D = $CollisionShape2D

func _process(delta: float) -> void:
	super(delta)
	if enabled:
		collision.disabled = false
	else:
		collision.disabled = true

## This item cannot be thrown.
func throw_item(direction: Vector2, force: float) -> void:
	return

func begin_attack() -> void:
	apply_impulse(held_by.global_position.direction_to(global_position) * attack_force)

func follow_mouse(player_position: Vector2, mouse_position: Vector2) -> void:
	var mouse_dist: float = min(global_position.distance_to(mouse_position), max_mouse_dist)
	var player_dist: float = global_position.distance_to(player_position)
	apply_force(global_position.direction_to(mouse_position) * mouse_dist * mouse_force_multiplier)
	if player_dist > player_dist_cutoff:
		apply_force(global_position.direction_to(player_position) * (player_dist - player_dist_cutoff) * player_force_multiplier)
	hitbox.global_position = player_position + player_position.direction_to(mouse_position) * max_mouse_dist
	hitbox.global_rotation = player_position.direction_to(mouse_position).angle()
