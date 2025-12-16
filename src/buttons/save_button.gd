class_name SaveButton
extends Button

@export var main_scene: MainScene


func _ready() -> void:
	assert(main_scene)


func _on_pressed() -> void:
	var is_ok := true

	var heroes_skills: Dictionary[Data.HeroesPaths, Array] = {}
	for rankbox: RankBox in main_scene.rank_boxes.values():
		if rankbox.hero_path_draggable.hero_path == Data.HeroesPaths.NONE:
			is_ok = false
			break
		heroes_skills[rankbox.hero_path_draggable.hero_path] = []
		for i in rankbox.skills.size():
			var skill := rankbox.skills[i]
			heroes_skills[rankbox.hero_path_draggable.hero_path].append(skill.skill_number)
		
	if is_ok:
		main_scene.popup_panel.show_panel(MyPopupPanel.MessageType.SAVE_SQUAD, Data.current_squad["squad_name"])
	else:
		main_scene.notification_panel.show_message("Heroes and/or skills not filled!")
