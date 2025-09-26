@abstract
class_name Weapon
extends Item
## Weapons are anything that can be used more than once. They may or may not use
## ammo. They can also reload at certain use intervals.

## Damage was dealt that was originating from this weapon.
signal damage_dealt(amount: float)

@export var cooldown_time: float ## Time until the weapon can be used again after using.

@onready var cooldown_timer: SceneTreeTimer = get_tree().create_timer(0) ## Timer for using.

## Checks if timers are finished.
func can_perform_action() -> bool:
	return cooldown_timer.time_left == 0

## Emits signal and starts timer if can perform reload.
func use_item() -> void:
	if !can_perform_action():
		return
	cooldown_timer.time_left = cooldown_time
	item_used.emit()
