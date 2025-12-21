class_name SkillDraggable
extends TextureRect

signal skill_dropped

@export var is_slot := false
var hero_path_assigned: HeroesPaths.Enum = HeroesPaths.Enum.NONE
var skill_number := -1
var is_unique := Callable()


static func create(hero_path: HeroesPaths.Enum, skill_number: int) -> SkillDraggable:
	var skill_draggable := Data.skill_draggable_scene.instantiate() as SkillDraggable
	skill_draggable.hero_path_assigned = hero_path
	skill_draggable.skill_number = skill_number
	var hero: String = HeroesPaths.to_hero(hero_path)
	skill_draggable.texture = Data.skills_textures[hero].skills[skill_number]
	return skill_draggable


func _ready() -> void:
	if not is_slot:
		is_unique = func() -> bool: return true


func _get_drag_data(_at_position: Vector2) -> Variant:
	if skill_number == -1:
		return null

	var drag_preview := TextureRect.new()
	drag_preview.texture = self.texture
	drag_preview.scale = Vector2.ONE / 5
	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
	var control := Control.new()
	control.add_child(drag_preview)
	self.set_drag_preview(control)
	return { 
			"hero_path_assigned": hero_path_assigned,
			"skill_number": skill_number,
			"texture": self.texture,
			"slot_ref": self if is_slot else null,
	}


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Dictionary:
		if is_slot:
			return (
					data.has("skill_number") 
					and data["skill_number"] >= 0 
					and data["hero_path_assigned"] == hero_path_assigned
					and hero_path_assigned != HeroesPaths.Enum.NONE
			)
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is Dictionary:
		if data.has("skill_number"):
			assert(not is_unique.is_null(), "is_unique() must be set if it's slot!")
			if is_unique.call(data["skill_number"]) == true or data["slot_ref"] != null:
				if data["slot_ref"] != null:
					var slot_ref := data["slot_ref"] as SkillDraggable
					slot_ref.hero_path_assigned = hero_path_assigned
					slot_ref.skill_number = skill_number
					slot_ref.texture = self.texture
				
				hero_path_assigned = data["hero_path_assigned"]
				skill_number = data["skill_number"]
				self.texture = data["texture"]

				skill_dropped.emit()
