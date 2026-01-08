class_name HeroPathDraggable
extends TextureRect

signal hero_dropped(from_rank: int)
signal info_requested(hero_path: HeroesPaths.Enum)

@export var is_slot := false
@export var rank_number := 0
var hero_path: HeroesPaths.Enum = HeroesPaths.Enum.NONE
var is_unique := Callable()
var _is_hovered := false


static func create(hero_path: HeroesPaths.Enum) -> HeroPathDraggable:
	var hero_path_draggable := Data.hero_path_draggable_scene.instantiate() as HeroPathDraggable
	hero_path_draggable.set_hero_path(hero_path)
	return hero_path_draggable


func _ready() -> void:
	if not is_slot:
		is_unique = func() -> bool: return true
	
	self.mouse_entered.connect( func(): _is_hovered = true )
	self.mouse_exited.connect(
			func(): 
				_is_hovered = false
				info_requested.emit(HeroesPaths.Enum.NONE)
	)


func _get_drag_data(_at_position: Vector2) -> Variant:
	if hero_path == HeroesPaths.Enum.NONE:
		return null
	
	var drag_preview := TextureRect.new()
	drag_preview.texture = self.texture
	drag_preview.scale = Vector2.ONE / 4
	drag_preview.position = (Vector2.UP + Vector2.LEFT) * drag_preview.texture.get_size() * drag_preview.scale / 2
	var control := Control.new()
	control.add_child(drag_preview)
	self.set_drag_preview(control)
	return { 
			"hero_path": hero_path,
			"rank_number": rank_number,
			"texture": self.texture, 
			"slot_ref": self if is_slot else null,
	}


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data is Dictionary:
		if is_slot:
			return data.has("hero_path") and data["hero_path"] != HeroesPaths.Enum.NONE
	return false


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if data is Dictionary:
		if data.has("hero_path"):
			assert(not is_unique.is_null(), "is_unique() must be set if it's slot!")
			if is_unique.call(data["hero_path"]) == true or data["slot_ref"] != null:
				if data["slot_ref"] != null:
					var slot_ref := data["slot_ref"] as HeroPathDraggable
					slot_ref.hero_path = hero_path
					slot_ref.texture = self.texture
				
				hero_path = data["hero_path"]
				self.texture = data["texture"]

				if is_slot:
					hero_dropped.emit(data["rank_number"])
				else:
					hero_dropped.emit(0)


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_BEGIN:
		Data.is_dragging = true
	elif what == NOTIFICATION_DRAG_END:
		Data.is_dragging = false


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if _is_hovered and not Data.is_dragging:
			if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
				info_requested.emit(hero_path)
			else:
				info_requested.emit(HeroesPaths.Enum.NONE)


func set_hero_path(hero_path: HeroesPaths.Enum):
	self.hero_path = hero_path
	self.texture = Data.heroes_textures[hero_path]
