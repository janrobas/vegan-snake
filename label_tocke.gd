extends Label

func _ready():
	SnakeManager.score_changed.connect(_on_score_changed)
	_on_score_changed(SnakeManager.score)

func _on_score_changed(new_score: int):
	text = "Točke: " + str(new_score)
