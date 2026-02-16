class_name Hrana
extends Area2D
enum Type { GOOD, BAD }

var type: Type = Type.GOOD
var avg_color: Color = Color.WHITE

@export var good_textures: Array[Texture2D]
@export var bad_textures: Array[Texture2D]

func set_type(new_type: Type) -> void:
	type = new_type
	var textures = good_textures if type == Type.GOOD else bad_textures
	if not textures.is_empty():
		var random_index = randi() % textures.size()
		$HranaSprite.texture = textures[random_index]
		avg_color = get_average_color(textures[random_index])   # compute average color
	else:
		$HranaSprite.texture = null
		push_warning("No textures assigned for food type: ", type)

func get_average_color(texture: Texture2D) -> Color:
	var image: Image = texture.get_image()
	if image == null:
		return Color.WHITE   # fallback

	#image.lock()
	var total_r := 0.0
	var total_g := 0.0
	var total_b := 0.0
	var pixel_count := 0

	for x in image.get_width():
		for y in image.get_height():
			var pixel: Color = image.get_pixel(x, y)
			if pixel.a > 0.1:
				total_r += pixel.r
				total_g += pixel.g
				total_b += pixel.b
				pixel_count += 1

	#image.unlock()

	if pixel_count == 0:
		return Color.WHITE

	return Color(total_r / pixel_count, total_g / pixel_count, total_b / pixel_count)
