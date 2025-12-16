class_name SaveButton
extends Button

@export var main_scene: MainScene


func _ready() -> void:
	assert(main_scene)


func _on_pressed() -> void:
	var heroes: Array[Data.HeroesPaths] = []
	var skill_numbers: Array[int] = []
	for rankbox: RankBox in main_scene.rank_boxes.values():
		heroes.append(rankbox.hero_path_draggable.hero_path)
		for skill in rankbox.skills:
			skill_numbers.append(skill.skill_number)

	var is_heroes_filled := heroes.all( func(hp): return hp != Data.HeroesPaths.NONE )
	var is_skills_filled := skill_numbers.all( func(sn): return sn != -1 )
	if is_heroes_filled and is_skills_filled:
		main_scene.popup_panel.show_panel(MyPopupPanel.MessageType.SAVE_SQUAD, Data.current_squad["squad_name"])
	else:
		main_scene.notification_panel.show_message("Heroes and/or skills not filled!")
