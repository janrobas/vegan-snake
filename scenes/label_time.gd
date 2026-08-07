extends Label

func _ready():
	SnakeManager.time_left_changed.connect(_on_time_changed)
	_on_time_changed(SnakeManager.time_left)

func _on_time_changed(new_time: int):
	text = "Time: " + str(new_time)
