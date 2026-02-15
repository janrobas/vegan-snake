class_name Hrana
extends Area2D
enum Type { GOOD, BAD }

var type: Type = Type.GOOD

@export var good_textures: Array[Texture2D]
@export var bad_textures: Array[Texture2D]

func set_type(new_type: Type) -> void:
	type = new_type
	var textures = good_textures if type == Type.GOOD else bad_textures
	if not textures.is_empty():
		var random_index = randi() % textures.size()
		$HranaSprite.texture = textures[random_index]
	else:
		$HranaSprite.texture = null
		push_warning("No textures assigned for food type: ", type)
