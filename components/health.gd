class_name Health
extends Node

signal damaged(amount: float, by: Player)
signal healed(amount: float, by: Player)

@export var health: float

func damage(amount: float, from: Player) -> void:
	health -= amount
	damaged.emit(amount, from)

func heal(amount: float, from: Player) -> void:
	health += amount
	healed.emit(amount, from)
