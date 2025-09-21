class_name MainMenu
extends CanvasLayer

@export var level_scene: PackedScene

func _on_play_button_button_down() -> void:
	get_tree().change_scene_to_packed(level_scene)
