class_name HeroPathSlot
extends TextureRect

var hero_path: Data.HeroesPaths = Data.HeroesPaths.NONE


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Dictionary:
		return data.has("hero_path")
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is Dictionary:
		self.texture = data["texture"] if data.has("texture") else null
