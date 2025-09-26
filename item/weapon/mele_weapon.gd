@abstract
class_name MeleWeapon
extends Weapon
## A weapon that doesn't need to be reloaded and damage is based on the force 
## used.

## Hitbox we use to detect collisions, I strongly recommend against setting 
## custom modifiers.
@export var hitbox: HitBox2D
@export var base_damage: int ## Damage applied at 100px/s
@export var damage_multiplier: float ## Damage multiplied based on speed increase / 100.

func _ready() -> void:
	assert(hitbox, "MeleWeapon must have a HitBox2D node set.")
	hitbox.hurt_box_entered.connect(_on_hurt_box_entered)

## Gets damage multiplier based on the speed of the weapon.
func get_multiplier() -> float:
	return 1.0 + (linear_velocity.length() / 100.0 - 1.0) * damage_multiplier

## Signal from [signal HitBox2D.hit_box_entered] on [member hitbox].
func _on_hurt_box_entered(hurtbox: HurtBox2D) -> void:
	hurtbox.health.damage(base_damage, 0, get_multiplier())
