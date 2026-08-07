extends Node

#var trail : Array[Vector2] = []
signal score_changed(new_score)
signal time_left_changed(time_left)

const MAX_TRAIL_SIZE := 1000
var body_scene : PackedScene = preload("res://objects/snake_segment.tscn")

var segments : Array[Node] = []

var score: int = 0 : set = _set_score
var time_left: int = 10 : set = _set_time_left

const SEGMENT_DISTANCE := 36.0

var trail : Array[Dictionary] = []  # {pos: Vector2, dist: float}

var total_trail_length := 0.0

var head = null

var is_game_over = false

var max_time: int = 180

func reset():
	SnakeManager.segments.clear()
	SnakeManager.trail.clear()
	SnakeManager.time_left = max_time
	SnakeManager.score = 0
	SnakeManager.is_game_over = false

func record_head_position():
	if not head:
		head = get_tree().get_first_node_in_group("snake_head")
	if not head:
		return

	var head_pos = head.global_position
	var last_dist = total_trail_length

	if trail.is_empty():
		trail.append({"pos": head_pos, "dist": 0.0})
		total_trail_length = 0.0
	else:
		# Compute distance from last recorded position
		var last_entry = trail[-1]
		var step_dist = last_entry["pos"].distance_to(head_pos)
		total_trail_length += step_dist
		trail.append({"pos": head_pos, "dist": total_trail_length})

	if trail.size() > 1000:
		trail.pop_front()
		

func _set_score(value: int):
	score = value
	score_changed.emit(score)

func _set_time_left(value: int):
	time_left = value
	time_left_changed.emit(time_left)
	
	if time_left == 0:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

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
	refresh_tail_visual()


func remove_last_segment() -> void:
	if segments.is_empty():
		return
	var last = segments.pop_back()
	last.queue_free()
	refresh_tail_visual()


func add_head_position(pos : Vector2) -> void:
	trail.append(pos)
	if trail.size() > MAX_TRAIL_SIZE:
		trail.pop_front()

func get_position_for_segment(index: int) -> Vector2:
	if trail.is_empty():
		return Vector2.ZERO

	# Distance behind head we want for this segment
	var target_dist = total_trail_length - (index) * SEGMENT_DISTANCE

	# If target is before the first recorded point, return the first point
	if target_dist <= trail[0]["dist"]:
		return trail[0]["pos"]

	# Binary search to find the two entries that bracket target_dist
	var low = 0
	var high = trail.size() - 1
	while low <= high:
		var mid = (low + high) / 2
		if trail[mid]["dist"] < target_dist:
			low = mid + 1
		else:
			high = mid - 1

	# low is the index of the first entry with dist >= target_dist
	var idx2 = low
	var idx1 = idx2 - 1

	# Interpolate between trail[idx1] and trail[idx2]
	var p1 = trail[idx1]["pos"]
	var p2 = trail[idx2]["pos"]
	var d1 = trail[idx1]["dist"]
	var d2 = trail[idx2]["dist"]
	var t = (target_dist - d1) / (d2 - d1)

	return p1.lerp(p2, t)

func get_head_position() -> Vector2:
	if trail.is_empty():
		return Vector2.ZERO
	return trail[-1]["pos"]
	
func game_over():
	if time_left < 3 or is_game_over:
		return
	is_game_over = true
	if head:
		head.get_node("AudioStreamPlayerBad").play()
	await get_tree().create_timer(0.5).timeout
	score = -666
	time_left = 0

func _process(delta: float) -> void:
	if SnakeManager.time_left < 1:
		return
	record_head_position()
	for i in segments.size():
		var segment = segments[i]
		segment.global_position = get_position_for_segment(i)

func refresh_tail_visual():
	if segments.is_empty():
		return
	
	for segment in segments:
		segment.set_as_tail(false)
	
	segments[-1].set_as_tail(true)
