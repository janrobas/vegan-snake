extends Node2D

func _ready() -> void:
	$CanvasLayer/VFlowContainer/LabelTocke.text = "Točke: " + str(SnakeManager.score)
	var foraLabel = $CanvasLayer/VFlowContainer/LabelFora
	
	if SnakeManager.score == -666:
		foraLabel.text = ":("
	elif SnakeManager.score < -12:
		foraLabel.text = "Veganska kača je postala mesna rolada."
	elif SnakeManager.score < -9:
		foraLabel.text = "A bi še en šnicelj?"
	elif SnakeManager.score < -6:
		foraLabel.text = "Več humusa prihodnjič."
	elif SnakeManager.score < -3:
		foraLabel.text = "You once were a ve-gone, now you will begone!"
	elif SnakeManager.score < 0:
		foraLabel.text = "Uravnotežena dieta, ampak ne za vegansko kačo."
	elif SnakeManager.score < 6:
		foraLabel.text = "Not great, not terrible!"
	elif SnakeManager.score < 9:
		foraLabel.text = "Čestitke za trud!"
	elif SnakeManager.score < 12:
		foraLabel.text = "Odličen slalom okoli mesa!"
	elif SnakeManager.score < 20:
		foraLabel.text = "Certificirano vegansko!"
	else:
		foraLabel.text = "Ti si veganska kača!"

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/meni.tscn")
