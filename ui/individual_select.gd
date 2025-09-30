class_name IndividualCharacterSelect
extends PanelContainer

@export var player_id: int

@onready var label: Label = $Label

var is_ready: bool = false

func select(controller: Controller) -> void:
	controller.player_id = player_id
	label.text = "Selected (press select to ready up)"
	controller.button_pressed.connect(_on_button_pressed)

func _on_button_pressed(button_name: String) -> void:
	if button_name == "select":
		is_ready = true
