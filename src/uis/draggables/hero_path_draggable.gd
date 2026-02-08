class_name HeroPathDraggable
extends DraggableTextureRect

@export var rank_number := 0
## Returns [code]true[/code] if hero-path is unique among others heroes-paths. Abstract function, assigned beyond the object.
var is_unique := Callable()


static func create(hero_path: HeroesPaths.Enum) -> HeroPathDraggable:
	var hero_path_draggable := DraggableTextureRect.create_base(Data.hero_path_draggable_scene) as HeroPathDraggable
	hero_path_draggable.set_info({"hero_path": hero_path})
	return hero_path_draggable


func _ready() -> void:
	super()

	if not is_slot:
		is_unique = func(): return true


func get_hero_path() -> HeroesPaths.Enum:
	return self.data[get_obligatory_key()] as HeroesPaths.Enum


func set_hero_path(hero_path: HeroesPaths.Enum):
	self.set_info({get_obligatory_key(): hero_path})


func get_obligatory_key() -> String:
	return "hero_path"


func _get_drag_dict() -> Dictionary:
	Data.current_drag_data = {
		get_obligatory_key(): get_hero_path(),
		"rank_number": rank_number,
		"slot_ref": self if is_slot else null,
	}
	return Data.current_drag_data


func _get_drag_scale() -> float:
	return 1/4.0


func _get_texture(data: Variant) -> Texture2D:
	return Data.heroes_textures[data[get_obligatory_key()]]


func get_drop_info() -> Variant:
	return Data.current_drag_data["rank_number"]


func _get_check_for_can_drop_data(_data: Dictionary) -> bool:
	return true


func _get_check_for_get_drag_data(data: Dictionary) -> bool:
	return data[get_obligatory_key()] != HeroesPaths.Enum.NONE


func _get_hover_data() -> Variant:
	return get_hero_path()


func _is_unique() -> bool:
	assert(not is_unique.is_null(), "is_unique() must be set if it's slot!")
	return is_unique.call(Data.current_drag_data[get_obligatory_key()])


# signal hero_dropped(from_rank: int)
# signal info_requested(hero_path: HeroesPaths.Enum)

# @export var is_slot := false
# @export var rank_number := 0
# var hero_path: HeroesPaths.Enum = HeroesPaths.Enum.NONE
# var is_unique := Callable()


# static func create(hero_path: HeroesPaths.Enum) -> HeroPathDraggable:
# 	var hero_path_draggable := Data.hero_path_draggable_scene.instantiate() as HeroPathDraggable
# 	hero_path_draggable.set_hero_path(hero_path)
# 	return hero_path_draggable


# func _ready() -> void:
# 	if not is_slot:
# 		is_unique = func() -> bool: return true
	
# 	self.hovered.connect(
# 			func(is_hovered: bool):
# 				if is_hovered:
# 					info_requested.emit(hero_path)
# 				else:
# 					info_requested.emit(HeroesPaths.Enum.NONE)
# 	)


# func _get_drag_data(_at_position: Vector2) -> Variant:
# 	if hero_path == HeroesPaths.Enum.NONE:
# 		return null
	
# 	var drag_preview := TextureRect.new()
# 	drag_preview.texture = self.texture
# 	drag_preview.scale = Vector2.ONE / 4
# 	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
# 	var control := Control.new()
# 	control.add_child(drag_preview)
# 	self.set_drag_preview(control)
# 	return { 
# 			"hero_path": hero_path,
# 			"rank_number": rank_number,
# 			"texture": self.texture, 
# 			"slot_ref": self if is_slot else null,
# 	}


# func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
# 	if data is Dictionary:
# 		if is_slot:
# 			return data.has("hero_path") and data["hero_path"] != HeroesPaths.Enum.NONE
# 	return false


# func _drop_data(_at_position: Vector2, data: Variant) -> void:
# 	if data is Dictionary:
# 		if data.has("hero_path"):
# 			assert(not is_unique.is_null(), "is_unique() must be set if it's slot!")
# 			if is_unique.call(data["hero_path"]) == true or data["slot_ref"] != null:
# 				if data["slot_ref"] != null:
# 					var slot_ref := data["slot_ref"] as HeroPathDraggable
# 					slot_ref.hero_path = hero_path
# 					slot_ref.texture = self.texture
				
# 				hero_path = data["hero_path"]
# 				self.texture = data["texture"]
# 				hero_dropped.emit(data["rank_number"])


# func set_hero_path(hero_path: HeroesPaths.Enum):
# 	self.hero_path = hero_path
# 	self.texture = Data.heroes_textures[hero_path]
