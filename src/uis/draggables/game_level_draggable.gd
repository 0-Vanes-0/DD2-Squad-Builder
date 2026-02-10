class_name GameLevelDraggable
extends DraggableTextureRect

enum GameLevels {
	NONE, ACT_ONE, ACT_TWO, ACT_THREE, ACT_FOUR, ACT_FIVE,
	KINGDOM_BEAST, KINGDOM_COVEN, KINGDOM_CRIMSON,
}

static func create(game_level: GameLevels) -> GameLevelDraggable:
	var game_level_draggable := DraggableTextureRect.create_base(Data.game_level_draggable_scene) as GameLevelDraggable
	game_level_draggable.set_info({"game_level": game_level})
	return game_level_draggable


func get_game_level() -> GameLevels:
	return self.data[get_obligatory_key()] as GameLevels


func set_game_level(game_level: GameLevels):
	self.set_info({get_obligatory_key(): game_level})


func get_obligatory_key() -> String:
	return "game_level"


func _get_drag_dict() -> Dictionary:
	Data.current_drag_data = {
		get_obligatory_key(): get_game_level(),
		"slot_ref": self if is_slot else null,
	}
	return Data.current_drag_data


func _get_drag_scale() -> float:
	return 1.0


func _get_texture(data: Variant) -> Texture2D:
	var game_level := data[get_obligatory_key()] as GameLevels
	return Data.game_levels_textures[game_level]


func get_drop_info() -> Variant:
	return null


func _get_check_for_can_drop_data(_data: Dictionary) -> bool:
	return true


func _get_check_for_get_drag_data(data: Dictionary) -> bool:
	return data[get_obligatory_key()] != GameLevels.NONE


func _get_hover_data() -> Variant:
	return get_game_level()


func _is_unique() -> bool:
	return false
