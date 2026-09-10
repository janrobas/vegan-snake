extends Node2D

@onready var exit_button: Button = $CanvasLayer/VFlowContainer/ButtonExit

func _ready() -> void:
	if OS.has_feature("web"):
		exit_button.hide()

func _on_pressed_start() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_button_exit_pressed() -> void:
	get_tree().quit()
