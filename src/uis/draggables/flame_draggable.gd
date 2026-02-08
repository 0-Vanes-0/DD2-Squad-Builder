class_name FlameDraggable
extends DraggableTextureRect

enum Flames {
	NONE, RADIANT, FRAGILE, DESPAIRING, CORPSE,
	KILLER, DOOM, STAR, HATEFUL, BASTARD, STYGIAN,
}


static func create(flame: Flames) -> FlameDraggable:
	var flame_draggable := DraggableTextureRect.create_base(Data.flame_draggable_scene) as FlameDraggable
	flame_draggable.set_info({"flame": flame})
	return flame_draggable


func get_flame() -> Flames:
	return self.data[get_obligatory_key()] as Flames


func get_obligatory_key() -> String:
	return "flame"


func _get_drag_dict() -> Dictionary:
	Data.current_drag_data = {
		get_obligatory_key(): get_flame(),
		"slot_ref": self if is_slot else null,
	}
	return Data.current_drag_data


func _get_drag_scale() -> float:
	return 0.7


func _get_texture(data: Variant) -> Texture2D:
	var flame := data[get_obligatory_key()] as Flames
	return Data.flames_textures[flame]


func get_drop_info() -> Variant:
	return null


func _get_check_for_can_drop_data(_data: Dictionary) -> bool:
	return true


func _get_check_for_get_drag_data(data: Dictionary) -> bool:
	return data[get_obligatory_key()] != Flames.NONE


func _get_hover_data() -> Variant:
	return get_flame()


func _is_unique() -> bool:
	return false
