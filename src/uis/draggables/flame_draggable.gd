class_name FlameDraggable
extends HoverableTextureRect

enum Flames {
	NONE, RADIANT, FRAGILE, DESPAIRING, CORPSE,
	KILLER, DOOM, STAR, HATEFUL, BASTARD, STYGIAN,
}

signal flame_dropped
signal info_requested(flame: Flames)

@export var is_slot := false
var flame_assigned := Flames.NONE


static func create(flame: Flames) -> FlameDraggable:
	var flame_draggable := Data.flame_draggable_scene.instantiate() as FlameDraggable
	flame_draggable.flame_assigned = flame
	flame_draggable.texture = Data.flames_textures[flame]
	return flame_draggable


func _ready() -> void:
	self.hovered.connect(
			func(is_hovered: bool):
				if is_hovered:
					info_requested.emit(flame_assigned)
				else:
					info_requested.emit(Flames.NONE)
	)


func _get_drag_data(_at_position: Vector2) -> Variant:
	if flame_assigned == Flames.NONE:
		return null
	
	var drag_preview := TextureRect.new()
	drag_preview.texture = self.texture
	drag_preview.scale = Vector2.ONE / 2
	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
	var control := Control.new()
	control.add_child(drag_preview)
	self.set_drag_preview(control)
	return { 
			"flame_assigned": flame_assigned,
			"texture": self.texture,
			"slot_ref": self if is_slot else null,
	}


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Dictionary:
		return data.has("flame_assigned")
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is Dictionary:
		if data.has("flame_assigned"):
			if is_slot:
				flame_assigned = data["flame_assigned"]
				self.texture = data["texture"]
				flame_dropped.emit()
			
			if data["slot_ref"] != null:
				var slot_ref := data["slot_ref"] as FlameDraggable
				slot_ref.flame_assigned = Flames.NONE
				slot_ref.texture = Data.flames_textures[Flames.NONE]
