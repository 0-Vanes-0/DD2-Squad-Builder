class_name SkillDraggable
extends AspectRatioContainer

@export var is_slot := false
@export var texture_rect: TextureRect
var hero: String = ""
var skill_number := -1


static func create(hero_path: Data.HeroesPaths, skill_number: int) -> SkillDraggable:
	var skill_draggable := Data.skill_draggable_scene.instantiate() as SkillDraggable
	var hero: String = (Data.HeroesPaths.keys()[hero_path] as String).substr(0, 1)
	skill_draggable.hero = hero
	skill_draggable.skill_number = skill_number
	skill_draggable.texture_rect.texture = Data.skills_textures[hero][skill_number]
	return skill_draggable


func _ready() -> void:
	assert(texture_rect)


func _get_drag_data(_at_position: Vector2) -> Variant:
	if hero == "":
		return null

	var drag_preview := TextureRect.new()
	drag_preview.texture = self.texture
	drag_preview.scale = Vector2.ONE / 4
	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
	var control := Control.new()
	control.add_child(drag_preview)
	self.set_drag_preview(control)
	return { 
			"hero": hero,
			"skill_number": skill_number,
			"texture": texture_rect.texture,
			"slot_ref": self if is_slot else null,
	}


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Dictionary:
		if is_slot:
			return data.has("skill_number") and data["skill_number"] >= 0
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is Dictionary:
		if data.has("skill_number"):
			if data["slot_ref"] != null:
				var slot_ref := data["slot_ref"] as SkillDraggable
				slot_ref.hero = hero
				slot_ref.skill_number = skill_number
				slot_ref.texture_rect.texture = texture_rect.texture
			
			hero = data["hero"]
			skill_number = data["skill_number"]
			texture_rect.texture = data["texture"]
