class_name Gun
extends RangedWeapon
## Tier 1 ranged weapon
## 
## Scene is item/weapon/ranged/gun/gun.tscn

## If this is true the gun will snap to the four directions. Otherwise it will
## try to point at the mouse.
@export var use_digital_mode: bool

func _ready() -> void:
	super()
	freeze = true

## Shoots the gun
func begin_attack() -> void:
	var ammo: GunAmmo = ammo_resource.get_scene().instantiate()
	get_parent().get_parent().add_child(ammo) ## TODO: Replace this with root node on global singleton...
	ammo.exclude_bodies.append(self)
	ammo.shoot(shoot_pos.global_position, Vector2.from_angle(rotation), shoot_speed)

func throw_item(direction: Vector2, speed: float) -> void:
	pass

func follow_mouse(player_position: Vector2, mouse_position: Vector2) -> void:
	var to_mouse: Vector2 = player_position.direction_to(mouse_position)
	global_position = player_position + to_mouse * 100
	rotation = to_mouse.angle()
