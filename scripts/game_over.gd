extends Node2D

func _ready() -> void:
	var funnyLabel = $CanvasLayer/VFlowContainer/LabelFunny
	$CanvasLayer/VFlowContainer/LabelTocke.text = "Points: " + str(SnakeManager.score)

	if SnakeManager.score == -666:
		funnyLabel.text = ":("
	elif SnakeManager.score < -12:
		funnyLabel.text = "The vegan snake has become a meat roll."
	elif SnakeManager.score < -9:
		funnyLabel.text = "How about another schnitzel?"
	elif SnakeManager.score < -6:
		funnyLabel.text = "More hummus next time."
	elif SnakeManager.score < -3:
		funnyLabel.text = "You once were a ve-gone, now you will be gone!"
	elif SnakeManager.score < 0:
		funnyLabel.text = "A balanced diet... just not for a vegan snake."
	elif SnakeManager.score < 6:
		funnyLabel.text = "Not great, not terrible!"
	elif SnakeManager.score < 9:
		funnyLabel.text = "Nice effort!"
	elif SnakeManager.score < 15:
		funnyLabel.text = "Excellent vegan slalom!"
	elif SnakeManager.score < 30:
		funnyLabel.text = "Certified vegan!"
	else:
		funnyLabel.text = "You are the ultimate vegan snake!"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
