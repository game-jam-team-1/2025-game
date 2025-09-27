@abstract
class_name Weapon
extends Item
## Weapons are anything that can be used more than once. 

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

## Emits signal and calls [function begin_attack].
func use_item() -> void:
	if !can_perform_action():
		return
	item_used.emit()

## Signal from [ResourceTimer.timeout] on [member cooldown_timer].
func _on_cooldown_timer_timeout() -> void:
	pass

## Called by the player when it is attacked.
func attacked() -> void:
	pass

## Called when the actual attack should begin.
@abstract
func begin_attack() -> void
