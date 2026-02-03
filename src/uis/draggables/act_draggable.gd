class_name ActDraggable
extends HoverableTextureRect

enum Acts {
	NONE, ONE, TWO, THREE, FOUR, FIVE,
}

signal act_dropped
signal info_requested(act: Acts)

@export var is_slot := false
var act_assigned := Acts.NONE


static func create(act: Acts) -> ActDraggable:
	var act_draggable := Data.act_draggable_scene.instantiate() as ActDraggable
	act_draggable.act_assigned = act
	act_draggable.texture = Data.acts_textures[act]
	return act_draggable


func _ready() -> void:
	self.hovered.connect(
			func(is_hovered: bool):
				if is_hovered:
					info_requested.emit(act_assigned)
				else:
					info_requested.emit(Acts.NONE)
	)


func _get_drag_data(_at_position: Vector2) -> Variant:
	if act_assigned == Acts.NONE:
		return null
	
	var drag_preview := TextureRect.new()
	drag_preview.texture = self.texture
	drag_preview.scale = Vector2.ONE
	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
	var control := Control.new()
	control.add_child(drag_preview)
	self.set_drag_preview(control)
	return { 
			"act_assigned": act_assigned,
			"texture": self.texture,
			"slot_ref": self if is_slot else null,
	}


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Dictionary:
		return data.has("act_assigned")
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is Dictionary:
		if data.has("act_assigned"):
			if is_slot:
				act_assigned = data["act_assigned"]
				self.texture = data["texture"]
				act_dropped.emit()
			
			if data["slot_ref"] != null:
				var slot_ref := data["slot_ref"] as ActDraggable
				slot_ref.act_assigned = Acts.NONE
				slot_ref.texture = Data.acts_textures[Acts.NONE]
				slot_ref.act_dropped.emit()


func set_act(act: Acts):
	self.act_assigned = act
	self.texture = Data.acts_textures[act]
