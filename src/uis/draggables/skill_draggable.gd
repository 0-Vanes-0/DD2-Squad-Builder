class_name SkillDraggable
extends DraggableTextureRect

## Returns [code]true[/code] if hero-path is unique among others heroes-paths. Abstract function, assigned beyond the object.
var is_unique := Callable()


static func create(hero_path: HeroesPaths.Enum, skill: int) -> SkillDraggable:
	var skill_draggable := DraggableTextureRect.create_base(Data.skill_draggable_scene) as SkillDraggable
	skill_draggable.set_info({
		"hero_path_assigned": hero_path,
		"skill": skill,
	})
	return skill_draggable


func _ready() -> void:
	super()
	if get_hero_path_assigned() == HeroesPaths.Enum.NONE:
		self.data["skill"] = -1

	if not is_slot:
		is_unique = func(): return true


func set_info(data: Dictionary):
	self.data[get_obligatory_key()] = data[get_obligatory_key()]
	self.data["skill"] = data["skill"] if data[get_obligatory_key()] != 0 else -1
	self.texture = _get_texture(self.data)


func clear_info():
	self.set_info({
		get_obligatory_key(): self.data[get_obligatory_key()],
		"skill": -1,
	})


func get_hero_path_assigned() -> HeroesPaths.Enum:
	return self.data[get_obligatory_key()] as HeroesPaths.Enum


func get_skill() -> int:
	return self.data["skill"] as int


func set_skill(hero_path: HeroesPaths.Enum, skill: int):
	self.set_info({
		get_obligatory_key(): hero_path,
		"skill": skill,
	})


func get_obligatory_key() -> String:
	return "hero_path_assigned"


func _get_drag_dict() -> Dictionary:
	Data.current_drag_data = {
		get_obligatory_key(): get_hero_path_assigned(),
		"skill": self.data["skill"],
		"slot_ref": self if is_slot else null,
	}
	print_debug("_get_drag_dict(): ", Data.current_drag_data)
	return Data.current_drag_data


func _get_drag_scale() -> float:
	return 1/5.0


func _get_texture(from_data: Variant) -> Texture2D:
	return Data.get_skill_texture(from_data[get_obligatory_key()], from_data["skill"])


func get_drop_info() -> Variant:
	return null


func _get_check_for_can_drop_data(drop_data: Dictionary) -> bool:
	return drop_data["skill"] >= 0 and drop_data[get_obligatory_key()] == get_hero_path_assigned()


func _get_check_for_get_drag_data(data: Dictionary) -> bool:
	return data["skill"] != -1


func _get_hover_data() -> Variant:
	return {
		get_obligatory_key(): self.data[get_obligatory_key()],
		"skill": self.data["skill"]
	}


func _is_unique() -> bool:
	assert(not is_unique.is_null(), "is_unique() must be set if it's slot!")
	return is_unique.call(Data.current_drag_data["skill"])


# signal skill_dropped
# signal info_requested(hero_path: HeroesPaths.Enum, skill_number: int)

# @export var is_slot := false
# var hero_path_assigned: HeroesPaths.Enum = HeroesPaths.Enum.NONE
# var skill_number := -1
# var is_unique := Callable()


# static func create(hero_path: HeroesPaths.Enum, skill_number: int) -> SkillDraggable:
# 	var skill_draggable := Data.skill_draggable_scene.instantiate() as SkillDraggable
# 	skill_draggable.hero_path_assigned = hero_path
# 	skill_draggable.skill_number = skill_number
# 	var hero: String = HeroesPaths.to_hero(hero_path)
# 	skill_draggable.texture = Data.skills_textures[hero].skills[skill_number]
# 	return skill_draggable


# func _ready() -> void:
# 	if not is_slot:
# 		is_unique = func() -> bool: return true
	
# 	self.hovered.connect(
# 			func(is_hovered: bool):
# 				if is_hovered:
# 					info_requested.emit(hero_path_assigned, skill_number)
# 				else:
# 					info_requested.emit(HeroesPaths.Enum.NONE, -1)
# 	)


# func _get_drag_data(_at_position: Vector2) -> Variant:
# 	if skill_number == -1:
# 		return null
	
# 	var drag_preview := TextureRect.new()
# 	drag_preview.texture = self.texture
# 	drag_preview.scale = Vector2.ONE / 5
# 	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
# 	var control := Control.new()
# 	control.add_child(drag_preview)
# 	self.set_drag_preview(control)
# 	return { 
# 			"hero_path_assigned": hero_path_assigned,
# 			"skill_number": skill_number,
# 			"texture": self.texture,
# 			"slot_ref": self if is_slot else null,
# 	}


# func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
# 	if data is Dictionary:
# 		if is_slot:
# 			return (
# 					data.has("skill_number") 
# 					and data["skill_number"] >= 0 
# 					and data["hero_path_assigned"] == hero_path_assigned
# 					and hero_path_assigned != HeroesPaths.Enum.NONE
# 			)
# 	return false


# func _drop_data(_at_position: Vector2, data: Variant) -> void:
# 	if data is Dictionary:
# 		if data.has("skill_number"):
# 			assert(not is_unique.is_null(), "is_unique() must be set if it's slot!")
# 			if is_unique.call(data["skill_number"]) == true or data["slot_ref"] != null:
# 				if data["slot_ref"] != null:
# 					var slot_ref := data["slot_ref"] as SkillDraggable
# 					slot_ref.hero_path_assigned = hero_path_assigned
# 					slot_ref.skill_number = skill_number
# 					slot_ref.texture = self.texture
				
# 				hero_path_assigned = data["hero_path_assigned"]
# 				skill_number = data["skill_number"]
# 				self.texture = data["texture"]
				
# 				skill_dropped.emit()
