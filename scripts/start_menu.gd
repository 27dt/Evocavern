extends TextureRect

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_instructions_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/instructions.tscn")
