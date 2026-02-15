extends Node2D

var segment_index : int = 0

func set_segment_index(idx : int) -> void:
	segment_index = idx

func _process(_delta: float) -> void:
	if segment_index == 0:
		return

	var pos = SnakeManager.get_position_for_segment(segment_index)
	global_position = pos

	var ahead_pos: Vector2
	if segment_index == 1:
		ahead_pos = SnakeManager.get_head_position()
	else:
		ahead_pos = SnakeManager.get_position_for_segment(segment_index - 1)

	var dir = ahead_pos - pos
	if dir.length_squared() > 0:
		rotation = dir.angle()
