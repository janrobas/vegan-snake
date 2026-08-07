extends Node2D

@export var food_scene: PackedScene
var rng = RandomNumberGenerator.new()
@onready var play_area = $PlayArea/CollisionShape2D
var start_color: Color
var end_color = Color.BLACK
const max_iskanje_proste_celice = 20

@onready var background = $CanvasLayerBack/ColorRectBack

func generate_start_color():
	var hue = rng.randf()
	var sat = rng.randf_range(0.2, 0.4)
	var val = rng.randf_range(0.5, 0.7)
	start_color = Color.from_hsv(hue, sat, val)
	
func _ready():
	generate_start_color()
	reset_snake()
	
	var os_name = OS.get_name()
	if os_name == "Android" or os_name == "iOS":
		$CanvasLayerTips.show()
		var container = $CanvasLayerTips/ControlFade
		var tween = create_tween()
		tween.tween_property(container, "modulate", Color(1, 1, 1, 0), 5.0)
	else:
		$CanvasLayerTips.hide()
		
func reset_snake():
	#for segment in SnakeManager.segments:
		#segment.queue_free()
	$SnakeHead.position = Vector2(500, 300)
	$SnakeHead.rotation = 0
	SnakeManager.reset()
	generate_start_color()
	background.color = start_color
	spawn_food()
	
	for i in range(3):
		await get_tree().create_timer(0.6).timeout
		SnakeManager.add_segment()

func spawn_food():
	var food = food_scene.instantiate()
	
	var random_type = Hrana.Type.GOOD if randi() % 2 == 0 else Hrana.Type.BAD
	food.set_type(random_type)
	
	var play_area_rect = play_area.shape
	
	var pos = null
	
	var iskanje_proste_celice = 0
	
	while (not pos or is_position_occupied(pos)) and iskanje_proste_celice < max_iskanje_proste_celice:
		pos = Vector2(
			rng.randf_range(32, play_area_rect.size.x - 64),
			rng.randf_range(32, play_area_rect.size.y - 64)
		)
		iskanje_proste_celice += 1
	
	if iskanje_proste_celice < max_iskanje_proste_celice:
		food.global_position = pos
		add_child(food)

func is_position_occupied(pos: Vector2) -> bool:
	for segment in SnakeManager.segments:
		if segment.global_position.distance_to(pos) < 60:
			return true
			
	for food in get_tree().get_nodes_in_group("food"):
		if food.global_position.distance_to(pos) < 100:
			return true
	
	return false

func _on_timer_timeout() -> void:
	spawn_food()

func _on_timer_konec_igre_timeout() -> void:
	SnakeManager.time_left -= 1

func _on_play_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("snake_head"):
		SnakeManager.game_over()

func _on_play_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("snake_head"):
		SnakeManager.game_over()

func _process(delta: float) -> void:
	update_background_color()
	
func update_background_color():
	var t = SnakeManager.time_left / float(SnakeManager.max_time)
	background.color = start_color.lerp(end_color, 1.0 - t)
