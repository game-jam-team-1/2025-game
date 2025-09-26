@abstract
class_name RangedWeapon
extends Weapon
## Weapon with ammo and reloading. Shoots a scene.

## Emitted when the weapon is reloaded.
signal reloaded

@export var reload_time: float ## Time in seconds to reload.
@export var ammo_resource: AmmoResource ## Resource for ammo info.

var ammo_count: int ## Amount of ammo currently in the weapon.
var has_rounds: bool ## If whatever is holding this currently can supply rounds.

@onready var reload_timer: ResourceTimer = ResourceTimer.new(0) ## Timer activated when reloading.

func _ready() -> void:
	super()
	reload_timer.timeout.connect(_on_reload_timer_timeout)
	assert(ammo_resource, "RangedWeapon must have an AmmoResource.")

func _process(delta: float) -> void:
	super(delta)
	reload_timer.process(delta)

func can_perform_action() -> bool:
	return super.can_perform_action() && reload_timer.time_left == 0

## Emits signal, resets timer and ammo count.
func reload() -> void:
	if !has_rounds || !can_perform_action():
		return
	ammo_count = ammo_resource.round_size
	reload_timer.time_left = reload_time
	reloaded.emit()

## Signal from [signal SceneTreeTimer.timeout] on [member reload_timer].
func _on_reload_timer_timeout() -> void:
	pass
