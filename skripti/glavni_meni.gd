extends Button


func _on_pressed_start() -> void:
	get_tree().change_scene_to_file("res://scene/main.tscn")

func _on_button_izhod_pressed() -> void:
	get_tree().quit()
