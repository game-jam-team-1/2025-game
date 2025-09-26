@abstract
class_name Weapon
extends Item
## Weapons are anything that can be used more than once. They may or may not use
## ammo. They can also reload at certain use intervals.

## Damage was dealt that was originating from this weapon.
signal damage_dealt(amount: float)

@export var cooldown_time: float ## Time until the weapon can be used again after using.

@onready var cooldown_timer: ResourceTimer = ResourceTimer.new(0) ## Timer for using.

func _ready() -> void:
	super()
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

func _process(delta: float) -> void:
	cooldown_timer.process(delta)

## Checks if timers are finished.
func can_perform_action() -> bool:
	return cooldown_timer.time_left == 0

## Emits signal and starts timer if can perform reload.
func use_item() -> void:
	if !can_perform_action():
		return
	cooldown_timer.time_left = cooldown_time
	item_used.emit()

## Signal from [signal SceneTreeTimer.timeout] on [member cooldown_timer].
func _on_cooldown_timer_timeout() -> void:
	pass
