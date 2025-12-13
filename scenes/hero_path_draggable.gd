class_name HeroPathDraggable
extends AspectRatioContainer

var hero_path: Data.HeroesPaths
@export var texture_rect: TextureRect


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
	var drag_preview := TextureRect.new()
	drag_preview.texture = texture_rect.texture
	drag_preview.scale = Vector2.ONE / 4
	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
	var control := Control.new()
	control.add_child(drag_preview)
	self.set_drag_preview(control)
	return {"hero_path": hero_path, "texture": texture_rect.texture}
