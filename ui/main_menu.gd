class_name MainMenu
extends CanvasLayer

@export var character_select: PackedScene

func _on_play_button_button_down() -> void:
	get_tree().change_scene_to_packed(character_select)
