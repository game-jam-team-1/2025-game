@abstract
class_name MeleWeapon
extends Weapon
## A weapon that doesn't need to be reloaded.

## Hitbox that does damage, you can set actions. Player should set exclude.
@export var hitbox: Hitbox
@export var windup_time: float

@onready var windup_timer: ResourceTimer = ResourceTimer.new(0) ## Timer for short windup before attack.

func _ready() -> void:
	super()
	assert(hitbox, "MeleWeapon must have a Hitbox node set.")
	hitbox.damaged.connect(_on_hitbox_damaged)
	hitbox.player = held_by
	windup_timer.timeout.connect(_on_windup_timer_timeout)
	windup_timer._initial_time = windup_time

func can_perform_action() -> bool:
	return super() && windup_timer.finished()

func _process(delta: float) -> void:
	super(delta)
	
	if held_by:
		hitbox.player = held_by
	
	windup_timer.process(delta)
	if enabled:
		visible = true
		hitbox.disabled = false
	else:
		visible = false
		hitbox.disabled = true

func _on_cooldown_timer_timeout() -> void:
	hitbox.disabled = false

func use_item() -> void:
	if !can_perform_action():
		return
	super()
	windup_timer.reset()

func attacked() -> void:
	windup_timer.cancel()

## Signal from [signal HitBox2D.hit_box_entered] on [member hitbox].
func _on_hitbox_damaged(hurtbox: Hurtbox) -> void:
	hitbox.disabled = true

func _on_windup_timer_timeout() -> void:
	cooldown_timer.time_left = cooldown_time
	begin_attack()
