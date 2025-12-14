class_name SkillDraggable
extends TextureRect

signal skill_dropped

@export var is_slot := false
var hero_path_assigned: Data.HeroesPaths = Data.HeroesPaths.NONE
var skill_number := -1


static func create(hero_path: Data.HeroesPaths, skill_number: int) -> SkillDraggable:
	var skill_draggable := Data.skill_draggable_scene.instantiate() as SkillDraggable
	skill_draggable.hero_path_assigned = hero_path
	skill_draggable.skill_number = skill_number
	var hero: String = Data.hero_path_to_hero(hero_path)
	skill_draggable.texture = Data.skills_textures[hero][skill_number]
	return skill_draggable


func _get_drag_data(_at_position: Vector2) -> Variant:
	if hero_path_assigned == Data.HeroesPaths.NONE:
		return null

	var drag_preview := TextureRect.new()
	drag_preview.texture = self.texture
	drag_preview.scale = Vector2.ONE / 4
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
			return data.has("skill_number") and data["skill_number"] >= 0 and data["hero_path_assigned"] != hero_path_assigned
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is Dictionary:
		if data.has("skill_number"):
			if data["slot_ref"] != null:
				var slot_ref := data["slot_ref"] as SkillDraggable
				slot_ref.hero_path_assigned = hero_path_assigned
				slot_ref.skill_number = skill_number
				slot_ref.texture = self.texture
			
			hero_path_assigned = data["hero_path_assigned"]
			skill_number = data["skill_number"]
			self.texture = data["texture"]

			skill_dropped.emit()
