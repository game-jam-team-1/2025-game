# upgrade_bank.gd
## Stores all the upgrades in the game
extends Node

@export_dir var upgrades_folder: String = "res://upgrade_system/upgrades/"

## Key: upgrade id
## Value: upgrade object
var upgrades_by_id: Dictionary = {}

## All upgrades in no particular order
# Don't you wish Godot had sets / hash sets ;(;(:(
var upgrades_array: Array[Upgrade]


func _ready() -> void:
	_add_upgrades_from_dir(upgrades_folder)
	print("Upgrades loaded: " + str(upgrades_by_id.keys()))


func get_upgrade(id: String) -> Upgrade:
	if upgrades_by_id.has(id):
		return upgrades_by_id[id]
	else:
		DebugLogger.warn("Upgrade id invalid")
		return null


## Adds all upgrades from a directory recursively
func _add_upgrades_from_dir(dir_path: String) -> void:
	if !DirAccess.dir_exists_absolute(dir_path):
		DebugLogger.error("Error loading upgrades.")
		return
	
	# If it's a script, instantiate and add to dictionary
	for filename in DirAccess.get_files_at(dir_path):
		if filename.ends_with(".gd"):
			var full_path: String = dir_path.path_join(filename)
			_add_upgrade(full_path)
	
	# If it's another folder, iterate through that one
	for dirname in DirAccess.get_directories_at(dir_path):
		var full_path: String = dir_path.path_join(dirname)
		_add_upgrades_from_dir(full_path)


## Instantiates upgrade from script and adds to dictionary
func _add_upgrade(path: String) -> void:
	if !path.ends_with(".gd"):
		DebugLogger.error("Invalid upgrade path")
		return
	
	var script: Script = load(path)
	var obj = script.new()
	
	if obj is Upgrade:
		var upgrade: Upgrade = obj
		
		if upgrades_by_id.has(upgrade.id):
			DebugLogger.warn("Duplicate upgrade id: " + str(upgrade.id))
		
		# Add to both dictionary and array
		upgrades_by_id[upgrade.id] = upgrade
		upgrades_array.append(upgrade)
		
	else:
		DebugLogger.error("Invalid upgrade path")
