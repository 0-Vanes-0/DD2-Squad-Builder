class_name PetDraggable
extends HoverableTextureRect

enum Pets {
	NONE, WOLF, PLISKIN, OWL, RABBIT, SLIME, 
	CHICK, LARVA, CROC, TICK, SHAMBY, PUSSY,
}

signal pet_dropped
signal info_requested(pet: Pets)

@export var is_slot := false
var pet_assigned := Pets.NONE


static func create(pet: Pets) -> PetDraggable:
	var pet_draggable := Data.pet_draggable_scene.instantiate() as PetDraggable
	pet_draggable.pet_assigned = pet
	pet_draggable.texture = Data.pets_textures[pet]
	return pet_draggable


func _ready() -> void:
	self.hovered.connect(
			func(is_hovered: bool):
				if is_hovered:
					info_requested.emit(pet_assigned)
				else:
					info_requested.emit(Pets.NONE)
	)


func _get_drag_data(_at_position: Vector2) -> Variant:
	if pet_assigned == Pets.NONE:
		return null
	
	var drag_preview := TextureRect.new()
	drag_preview.texture = self.texture
	drag_preview.scale = Vector2.ONE / 1
	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
	var control := Control.new()
	control.add_child(drag_preview)
	self.set_drag_preview(control)
	return { 
			"pet_assigned": pet_assigned,
			"texture": self.texture,
			"slot_ref": self if is_slot else null,
	}


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Dictionary:
		return data.has("pet_assigned")
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is Dictionary:
		if data.has("pet_assigned"):
			if is_slot:
				pet_assigned = data["pet_assigned"]
				self.texture = data["texture"]
				pet_dropped.emit()
			
			if data["slot_ref"] != null:
				var slot_ref := data["slot_ref"] as PetDraggable
				slot_ref.pet_assigned = Pets.NONE
				slot_ref.texture = Data.pets_textures[Pets.NONE]
