class_name Hitbox
extends Area2D

signal damaged(what: Hurtbox)

@export var player: Player
@export var exclude: Array[Hurtbox]
@export var damage_amount: float

var disabled: bool = false
var get_knockback: Callable

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	assert(player, "Hitbox must have a Player assigned.")
	if disabled || !area is Hurtbox || exclude.has(area):
		return
	
	var as_hurtbox: Hurtbox = area as Hurtbox
	assert(get_knockback, "Hitbox must have a get_knockback function assigned.")
	var knockback: Vector2 = get_knockback.call(self, as_hurtbox)
	as_hurtbox.damage(damage_amount, knockback.length(), knockback.normalized(), player)
	damaged.emit(as_hurtbox)
