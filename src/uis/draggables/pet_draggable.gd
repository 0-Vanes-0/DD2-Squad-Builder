class_name PetDraggable
extends DraggableTextureRect

enum Pets {
	NONE, WOLF, PLISKIN, OWL, RABBIT, SLIME, 
	CHICK, LARVA, CROC, TICK, SHAMBY, PUSSY,
}


static func create(pet: Pets) -> PetDraggable:
	var pet_draggable := DraggableTextureRect.create_base(Data.pet_draggable_scene) as PetDraggable
	pet_draggable.set_info({"pet": pet})
	return pet_draggable


func get_pet() -> Pets:
	return self.data[get_obligatory_key()] as Pets


func set_pet(pet: Pets):
	self.set_info({get_obligatory_key(): pet})


func get_obligatory_key() -> String:
	return "pet"


func _get_drag_dict() -> Dictionary:
	Data.current_drag_data = {
		get_obligatory_key(): get_pet(),
		"slot_ref": self if is_slot else null,
	}
	return Data.current_drag_data


func _get_drag_scale() -> float:
	return 1.0


func _get_texture(data: Variant) -> Texture2D:
	var pet := data[get_obligatory_key()] as Pets
	return Data.pets_textures[pet]


func get_drop_info() -> Variant:
	return null


func _get_check_for_can_drop_data(_data: Dictionary) -> bool:
	return true


func _get_check_for_get_drag_data(data: Dictionary) -> bool:
	return data[get_obligatory_key()] != Pets.NONE


func _get_hover_data() -> Variant:
	return get_pet()


func _is_unique() -> bool:
	return false
