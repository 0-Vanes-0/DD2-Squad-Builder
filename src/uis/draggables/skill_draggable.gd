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


#region Other overrides
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
#endregion
