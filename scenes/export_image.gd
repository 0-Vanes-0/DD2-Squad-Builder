class_name ExportImage
extends MarginContainer

@export var coach_h_box: HBoxContainer
@export var game_level_v_box: VBoxContainer
@export var game_level_draggable: GameLevelDraggable
@export var flame_v_box: VBoxContainer
@export var flame_draggable: FlameDraggable
@export var pet_v_box: VBoxContainer
@export var pet_draggable: PetDraggable
@export var ranks: Array[VBoxContainer] = [null, null, null, null]


func _ready() -> void:
	assert(ranks.all( func(rank): return rank != null ))


func apply_info_and_get_size() -> Vector2:
	coach_h_box.visible = _is_flame_not_none() or _is_pet_not_none() or _is_game_level_not_none()
	game_level_v_box.visible = _is_game_level_not_none()
	flame_v_box.visible = _is_flame_not_none()
	pet_v_box.visible = _is_pet_not_none()

	game_level_draggable.set_game_level(Data.current_squad["game_level"])
	flame_draggable.set_flame(Data.current_squad["flame"])
	pet_draggable.set_pet(Data.current_squad["pet"])

	for i in ranks.size():
		var label := ranks[i].get_child(0) as Label
		var hero_path_drg := ranks[i].get_child(1) as HeroPathDraggable
		var grid := ranks[i].get_child(2) as GridContainer
		var rank := str(ranks.size() - i)

		var hero_path := Data.current_squad[rank]["hero_path"] as HeroesPaths.Enum
		label.text = Data.all_paths_names.get_path_name(hero_path).split(" ")[-1]
		hero_path_drg.set_hero_path(hero_path)
		var is_hero_path_abom := HeroesPaths.is_abomination(hero_path)
		grid.columns = 2 if is_hero_path_abom else 1
		for j in grid.get_child_count():
			var skill_drg := grid.get_child(j) as SkillDraggable
			if j < 5 or is_hero_path_abom:
				skill_drg.set_skill(hero_path, Data.current_squad[rank]["skills"][j])
				skill_drg.show()
			else:
				skill_drg.hide()

	await get_tree().process_frame
	return self.size


func _is_flame_not_none() -> bool:
	return Data.current_squad["flame"] != FlameDraggable.Flames.NONE


func _is_pet_not_none() -> bool:
	return Data.current_squad["pet"] != PetDraggable.Pets.NONE


func _is_game_level_not_none() -> bool:
	return Data.current_squad["game_level"] != GameLevelDraggable.GameLevels.NONE
