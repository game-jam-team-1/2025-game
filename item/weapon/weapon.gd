@abstract
class_name Weapon
extends Item
## Weapons are anything that can be used more than once. They may or may not use
## ammo. They can also reload at certain use intervals.

## Emitted when the weapon is reloaded.
signal reloaded

@export var needs_ammo: bool ## If this is true the weapon will require ammo to function.
@export var ammo_resource: AmmoResource ## Provides info for ammo.
@export var reloads: bool ## If this weapon reloads when ammo runs out. (Manual)
@export var reload_time: float ## Time it will take to reload in seconds.
@export var cooldown_time: float ## Time until the weapon can be used again after using.

var reload_timer: SceneTreeTimer ## Timer for reloading.
var cooldown_timer: SceneTreeTimer ## Timer for using.
var ammo_count: int ## Current amount of ammo the gun has.
var has_rounds: bool ## If the [class Player] controlling this weapon has more rounds.

## Checks if timers are finished.
func can_perform_action() -> bool:
	return cooldown_timer.time_left == 0 && reload_timer.time_left == 0

## Reloads the weapon, if [member reloads] is true. By default this function 
## will reset the timer and emit the signal.
func reload() -> void:
	if !reloads || !has_rounds || !can_perform_action():
		return
	reload_timer.time_left = reload_time
	reloaded.emit()
	ammo_count += ammo_resource.round_size

## Emits signal and starts timer if can perform reload. Does not use ammo 
## automatically.
func use_item() -> void:
	if (needs_ammo && ammo_count == 0) || !can_perform_action():
		return
	cooldown_timer.time_left = cooldown_time
	item_used.emit()
