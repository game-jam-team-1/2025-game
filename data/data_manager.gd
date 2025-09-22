class_name SingletonDataManager
extends Node
## DataManager is responsible for saving and loading game state, and also loading
## the static settings file.

## Emits when the game settings file was changed. Usually this will only emit
## once.
signal settings_changed(new_settings: Dictionary[String, Variant])

## Private, game settings filepath.
@export_file("*.txt") var _game_settings: String

## Filename for the user data save.
@export var user_data_file_name: String

## Interval static settings file will be checked.
@export var static_settings_check_interval: float = 0.5

## Private, settings file text the last time we checked.
var _previous_settings_text: String

## Static settings, name -> value. Cannot set this manually.
var settings: Dictionary[String, Variant]

## Game data, set this manually.
var data: Dictionary[String, Variant]

func _ready() -> void:
	_detect_settings_changes()

## Coroutine to detect when the file is changed.
func _detect_settings_changes() -> void:
	while true:
		await get_tree().create_timer(static_settings_check_interval).timeout
		_check_settings_changed()

## Called by [method _detect_settings_changed]
func _check_settings_changed() -> void:
	var file: FileAccess = FileAccess.open(_game_settings, FileAccess.READ)
	var text: String = file.get_as_text()
	file.close()
	if text != _previous_settings_text:
		_parse_settings(text)
		settings_changed.emit()
		_previous_settings_text = text

## Parse settings text and add it to [member SingletonDataManager.settings]
func _parse_settings(text: String) -> void:
	settings = parse_data(text)

## Loads the file into [member data].
func load_data() -> void:
	var file: FileAccess = FileAccess.open(user_data_file_name, FileAccess.READ)
	if file == null:
		return
	data = parse_data(file.get_as_text())
	file.close()

## Saves [member data] to file.
func save_data() -> void:
	var file: FileAccess = FileAccess.open(user_data_file_name, FileAccess.WRITE)
	file.store_string(generate_data(data))
	file.close()

## Parse data from files.
static func parse_data(text: String) -> Dictionary[String, Variant]:
	var out: Dictionary[String, Variant]
	var lines = text.split("\n", false)
	for line in lines:
		if line.strip_edges().is_empty():
			continue
		assert(line.contains("="), "Error parsing settings: line must have an =")
		assert(line.split("=").size() == 2, "Error parsing settings: line must have 1 =")
		var var_name = line.split("=")[0].strip_edges()
		var value = line.split("=")[1].strip_edges()
		out[var_name] = str_to_var(value)
	return out

## Generate string data from a dictionary.
static func generate_data(dict: Dictionary[String, Variant]) -> String:
	var out: String = ""
	for value: String in dict.keys():
		out += value + "=" + var_to_str(dict[value]).replace("\n", "") + "\n"
	return out
