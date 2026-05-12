@abstract
class_name DraggableTextureRect
extends HoverableTextureRect

signal item_dropped(drop_info: Variant)
signal info_requested(info: Variant)

## Dropping draggable is possible only if [member is_slot] is [code]true[/code].
@export var is_slot := false
@export var is_single_slot := false
var data: Dictionary = {}

## Returns String of must-have key (e.g. hero path draggable must contain "hero_path").
@abstract func get_obligatory_key() -> String
## Returns dictionary of what stuff data would contain. Must change [member Data.current_drag_data]!
@abstract func _get_drag_dict() -> Dictionary
## Returns scale value for original texture.
@abstract func _get_drag_scale() -> float
## Returns texture from some textures in [Data] by [param data].
@abstract func _get_texture(data: Variant) -> Texture2D
## Returns drop info for [signal item_dropped].
@abstract func get_drop_info() -> Variant
## Additional check in _can_drop_data() function.
@abstract func _get_check_for_can_drop_data(data: Dictionary) -> bool
## Additional check in _get_drag_data() function.
@abstract func _get_check_for_get_drag_data(data: Dictionary) -> bool

@abstract func _get_hover_data() -> Variant

@abstract func _is_unique() -> bool


static func create_base(scene: PackedScene) -> DraggableTextureRect:
	var draggable := scene.instantiate() as DraggableTextureRect
	assert(draggable != null)
	return draggable


func _ready() -> void:
	super()
	if is_single_slot:
		assert(is_slot, "If is_slot = false, is_single_slot can't be true")
	
	if data.is_empty():
		data = { get_obligatory_key(): 0 }
	
	self.hovered.connect(
			func(is_hovered: bool):
				if is_hovered:
					info_requested.emit(_get_hover_data())
				else:
					info_requested.emit(0)
	)


func _get_drag_data(_at_position: Vector2) -> Variant:
	if data.is_empty() or not _get_check_for_get_drag_data(data):
		return null
	
	var drag_preview := TextureRect.new()
	drag_preview.texture = self.texture
	drag_preview.scale = Vector2.ONE * _get_drag_scale()
	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
	var control := Control.new()
	control.add_child(drag_preview)
	self.set_drag_preview(control)
	
	var dict := _get_drag_dict()
	assert(dict.has("slot_ref"))
	Data.current_drag_data = dict
	Data.was_drag_useless = true
	return dict


func _can_drop_data(_at_position: Vector2, drop_data: Variant) -> bool:
	if drop_data is Dictionary:
		return drop_data.has(get_obligatory_key()) and _get_check_for_can_drop_data(drop_data)
	return false


func _drop_data(_at_position: Vector2, drop_data: Variant) -> void:
	if drop_data is Dictionary:
		if drop_data.has(get_obligatory_key()) and is_slot:
			if is_single_slot:
				set_info(drop_data)
				Data.was_drag_useless = false
				item_dropped.emit(get_drop_info())
			
			elif _is_unique() or drop_data["slot_ref"] != null:
				var slot_ref := drop_data["slot_ref"] as DraggableTextureRect
				if slot_ref != null:
					slot_ref.set_info(data)
					#if drop_data.has("skill"):
						#print_debug("Dropped data: %s| Slot ref data: %s" % [data, slot_ref.data])
				
				set_info(drop_data)
				Data.was_drag_useless = false
				item_dropped.emit(get_drop_info())
				
				#if drop_data.has("skill"):
					#var slot_data := slot_ref.data if slot_ref else {}
					#print_debug("Dropped data: %s| Slot ref data: %s" % [data, slot_data])


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_BEGIN:
		self.is_hoverable = false
		Data.is_dragging = true
	elif what == NOTIFICATION_DRAG_END:
		self.is_hoverable = true
		Data.is_dragging = false
		if is_slot and Data.was_drag_useless:
			var slot_ref := Data.current_drag_data.get("slot_ref") as DraggableTextureRect
			if slot_ref != null:
				slot_ref.clear_info()
				slot_ref.item_dropped.emit(slot_ref.get_drop_info())
				Data.current_drag_data["slot_ref"] = null
				print_debug("drag was useless")


func set_info(data: Dictionary):
	self.data[get_obligatory_key()] = data[get_obligatory_key()]
	self.texture = _get_texture(data)


func clear_info():
	set_info({ get_obligatory_key(): 0 })
