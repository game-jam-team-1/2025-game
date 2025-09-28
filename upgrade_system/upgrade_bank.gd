## Stores all the upgrades in the game
class_name UpgradeBank
extends Node

var all_upgrades: Array[Upgrade]

func _ready() -> void:
	var dir := DirAccess.open("res://upgrade_system/upgrades/")
	
	if dir:
		dir.list_dir_begin()
		var filename: String = dir.get_next()
		while filename != "":
			if dir.current_is_dir():
				pass
