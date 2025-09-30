class_name CharacterSelect
extends Control

@export var selectors: Array[IndividualCharacterSelect]
@export var level_scene: PackedScene

var selected_devices: Array[int] = []
var selected_selectors: Array[IndividualCharacterSelect]

func _ready() -> void:
	InputManager.button_pressed.connect(_on_button_pressed)

func _on_button_pressed(event_name: String, controller: Controller) -> void:
	if selectors.is_empty() || selected_devices.has(controller.device_id):
		return
	
	var next_selector: IndividualCharacterSelect = selectors.pop_at(0)
	next_selector.select(controller)
	selected_devices.append(controller.device_id)
	selected_selectors.append(next_selector)

func _process(delta: float) -> void:
	if selected_selectors.is_empty():
		return
	var not_ready: bool = false
	for selector: IndividualCharacterSelect in selected_selectors:
		if !selector.is_ready:
			not_ready = true
	if not_ready:
		return
	get_tree().change_scene_to_packed(level_scene) ## TODO: Change this, we should be able to choose the level here.
