extends Node

var trail : Array[Vector2] = []
signal score_changed(new_score)
signal time_left_changed(time_left)

const FRAMES_PER_SEGMENT := 10

const MAX_TRAIL_SIZE := 1000
var body_scene : PackedScene = preload("res://objekti/segment_kace.tscn")

var segments : Array[Node] = []

var score: int = 0 : set = _set_score
var time_left: int = 10 : set = _set_time_left

func _set_score(value: int):
	score = value
	score_changed.emit(score)

func _set_time_left(value: int):
	time_left = value
	time_left_changed.emit(score)
	
	if time_left == 0:
		get_tree().change_scene_to_file("res://scene/konec_igre.tscn")

func add_segment() -> void:
	var new_segment = body_scene.instantiate()
	
	var container = get_tree().get_first_node_in_group("snake_container")
	if container:
		#container.add_child(new_segment)
		container.call_deferred("add_child", new_segment)
	else:
		push_error("Snake container not found")
	
	new_segment.set_segment_index(segments.size() + 1)
	segments.append(new_segment)


func remove_last_segment() -> void:
	if segments.is_empty():
		return
	var last = segments.pop_back()
	last.queue_free()


func add_head_position(pos : Vector2) -> void:
	trail.append(pos)
	if trail.size() > MAX_TRAIL_SIZE:
		trail.pop_front()

func get_position_for_segment(index : int) -> Vector2:
	var desired_index = trail.size() - 1 - index * FRAMES_PER_SEGMENT
	desired_index = max(desired_index, 0)
	return trail[desired_index]

func get_head_position() -> Vector2:
	if trail.is_empty():
		return Vector2.ZERO
	return trail[-1]
