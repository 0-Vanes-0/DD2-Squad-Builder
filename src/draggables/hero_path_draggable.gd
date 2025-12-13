class_name HeroPathDraggable
extends AspectRatioContainer

signal hero_dropped(from_rank: int, to_rank: int)

@export var is_slot := false
@export var rank_number := 0
@export var texture_rect: TextureRect
var hero_path: Data.HeroesPaths


static func create(hero_path: Data.HeroesPaths) -> HeroPathDraggable:
	var hero_path_draggable := Data.hero_path_draggable_scene.instantiate() as HeroPathDraggable
	hero_path_draggable.hero_path = hero_path
	hero_path_draggable.texture_rect.texture = Data.heroes_textures[hero_path]
	return hero_path_draggable


func _ready() -> void:
	assert(texture_rect)
	await get_tree().process_frame
	self.custom_minimum_size.y = self.size.x / self.ratio


func _get_drag_data(_at_position: Vector2) -> Variant:
	if hero_path == Data.HeroesPaths.NONE:
		return null
	
	var drag_preview := TextureRect.new()
	drag_preview.texture = texture_rect.texture
	drag_preview.scale = Vector2.ONE / 4
	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
	var control := Control.new()
	control.add_child(drag_preview)
	self.set_drag_preview(control)
	return { 
			"hero_path": hero_path,
			"rank_number": rank_number,
			"texture": texture_rect.texture, 
			"slot_ref": self if is_slot else null,
	}


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Dictionary:
		if is_slot:
			return data.has("hero_path") and data["hero_path"] != Data.HeroesPaths.NONE
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is Dictionary:
		if data.has("hero_path"):
			if data["slot_ref"] != null:
				var slot_ref := data["slot_ref"] as HeroPathDraggable
				slot_ref.hero_path = hero_path
				slot_ref.texture_rect.texture = texture_rect.texture
			
			hero_path = data["hero_path"]
			texture_rect.texture = data["texture"]

			if is_slot:
				hero_dropped.emit(data["rank_number"], rank_number)
			else:
				hero_dropped.emit(0, rank_number)
