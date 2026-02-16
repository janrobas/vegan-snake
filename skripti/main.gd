extends Node2D

@export var food_scene: PackedScene
var rng = RandomNumberGenerator.new()
@onready var play_area = $PlayArea/CollisionShape2D

func _ready():
	reset_snake()
		
func reset_snake():
	#for segment in SnakeManager.segments:
		#segment.queue_free()
	SnakeManager.segments.clear()
	$Slabakaca1.position = Vector2(500, 300)
	$Slabakaca1.rotation = 0
	SnakeManager.trail.clear()
	SnakeManager.time_left = 200
	SnakeManager.score = 0
		
	spawn_food()
	
	for i in range(3):
		await get_tree().create_timer(0.4).timeout
		SnakeManager.add_segment()

func spawn_food():
	var food = food_scene.instantiate()
	
	var random_type = Hrana.Type.GOOD if randi() % 2 == 0 else Hrana.Type.BAD
	food.set_type(random_type)
	
	var play_area_rect = play_area.shape
	
	var pos = null
	
	while not pos or is_position_occupied(pos):
		pos = Vector2(
			rng.randf_range(32, play_area_rect.size.x - 64),
			rng.randf_range(32, play_area_rect.size.y - 64)
		)
	
	food.global_position = pos
	add_child(food)

func is_position_occupied(pos: Vector2) -> bool:
	for segment in SnakeManager.segments:
		if segment.global_position.distance_to(pos) < 40:
			return true
			
	for food in get_tree().get_nodes_in_group("hrana"):
		if food.global_position.distance_to(pos) < 80:
			return true
	
	return false

func _on_timer_timeout() -> void:
	spawn_food()

func _on_timer_konec_igre_timeout() -> void:
	SnakeManager.time_left -= 1

func _on_play_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("kacja_glava"):
		SnakeManager.game_over()


func _on_play_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("kacja_glava"):
		SnakeManager.game_over()
