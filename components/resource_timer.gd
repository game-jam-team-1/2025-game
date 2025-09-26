class_name ResourceTimer
extends Resource

signal timeout

var time_left: float

func _init(time: float) -> void:
	time_left = time

func process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		if time_left <= 0:
			time_left = 0
			timeout.emit()
