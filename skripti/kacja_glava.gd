extends Node2D

@export var speed := 220.0          # pixels per second
@export var angular_speed := 210.0  # degrees per second
var hrana_particles = preload("res://objekti/hrana_particles.tscn")
var hrana_particles_bad = preload("res://objekti/hrana_particles_bad.tscn")

func _ready():
	pass
	#for i in range(SnakeManager.FRAMES_PER_SEGMENT * 3):
		#SnakeManager.add_head_position(position)
	#
	#for i in range(1,3):
		#SnakeManager.add_segment()

func _process(delta: float) -> void:
	#var rotation_dir = 0
	#if Input.is_action_pressed("turn_left"):
		#rotation_dir -= 1
	#if Input.is_action_pressed("turn_right"):
		#rotation_dir += 1
	
	var rotation_dir = Input.get_axis("turn_left", "turn_right")
	rotation += deg_to_rad(angular_speed * rotation_dir * delta)

	var velocity = Vector2.RIGHT.rotated(rotation) * speed * delta
	
	if not SnakeManager.konec_igre:
		position += velocity

	#SnakeManager.add_head_position(position)

func game_over():
	SnakeManager.game_over()

func flash(color: Color, duration: float):
	modulate = color
	await get_tree().create_timer(duration).timeout
	modulate = Color.WHITE


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("hrana"):
		var particles
		
		if (area.type == Hrana.Type.BAD):
			particles = hrana_particles_bad.instantiate()
		else:
			particles = hrana_particles.instantiate()
			
		particles.global_position = area.global_position
		
		match area.type:
			Hrana.Type.GOOD:
				#particles.modulate = Color.GREEN_YELLOW
				particles.modulate = area.avg_color
				SnakeManager.add_segment()
				SnakeManager.score += 1
				$AudioStreamPlayerGood.play()
			Hrana.Type.BAD:
				particles.modulate = Color.RED
				SnakeManager.remove_last_segment()
				SnakeManager.score -= 3
				$AudioStreamPlayerBad.play()
				flash(Color.RED, 1)
				
		get_node("/root/main").add_child(particles)
		area.queue_free()
		#get_node("/root/main").spawn_food()
		get_node("/root/main").call_deferred("spawn_food")
	elif area.is_in_group("kacji_segment"):
		game_over()
