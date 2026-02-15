extends Node2D

var segment_index : int = 0
@onready var sprite = $Slabakaca2

func set_segment_index(idx : int) -> void:
	segment_index = idx

var should_be_tail := false

func set_as_tail(is_tail: bool):
	should_be_tail = is_tail
	if sprite:
		_apply_tail_visual()

func _ready():
	_apply_tail_visual()

func _apply_tail_visual():
	if not sprite:
		return
	if should_be_tail:
		sprite.texture = preload("res://images/kaca/slabakaca_rep.png")
	else:
		sprite.texture = preload("res://images/kaca/slabakaca1.png")
		
func _process(_delta: float) -> void:
	if segment_index == 0:
		return

	var pos = SnakeManager.get_position_for_segment(segment_index)
	global_position = pos
#
	var ahead_pos: Vector2
	if segment_index == 1:
		ahead_pos = SnakeManager.get_head_position()
	else:
		ahead_pos = SnakeManager.get_position_for_segment(segment_index - 1)

	var dir = ahead_pos - pos
	if dir.length_squared() > 0:
		rotation = dir.angle()

#func set_as_tail(is_tail: bool):
	#if is_tail:
		#sprite.texture = preload("res://images/kaca/slabakaca_rep.png")
	#else:
		#sprite.texture = preload("res://images/kaca/slabakaca1.png")
