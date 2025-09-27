class_name ResourceTimer
extends Resource

signal timeout

var time_left: float
var _initial_time: float

func _init(time: float) -> void:
	time_left = time
	_initial_time = time

func process(delta: float) -> void:
	if time_left > 0:
		time_left -= delta
		if time_left <= 0:
			time_left = 0
			timeout.emit()

func finished() -> bool:
	return time_left == 0

func cancel() -> void:
	time_left = 0

func reset() -> void:
	time_left = _initial_time
