class_name SkillDraggable
extends TextureRect

signal skill_dropped
signal info_requested(hero_path: HeroesPaths.Enum, skill_number: int)

@export var is_slot := false
var hero_path_assigned: HeroesPaths.Enum = HeroesPaths.Enum.NONE
var skill_number := -1
var is_unique := Callable()
var _is_hovered := false


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
	
	self.mouse_entered.connect( func(): _is_hovered = true )
	self.mouse_exited.connect(
			func(): 
				_is_hovered = false
				info_requested.emit(HeroesPaths.Enum.NONE, -1)
	)


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


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_BEGIN:
		Data.is_dragging = true
	elif what == NOTIFICATION_DRAG_END:
		Data.is_dragging = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if _is_hovered and not Data.is_dragging:
			if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
				info_requested.emit(hero_path_assigned, skill_number)
			else:
				info_requested.emit(HeroesPaths.Enum.NONE, -1)
