class_name SaveButton
extends Button

@export var main_scene: MainScene


func _ready() -> void:
	assert(main_scene)


func _on_pressed() -> void:
	var is_ok := true

	for rankbox: RankBox in main_scene.rank_boxes.values():
		var hero_path := rankbox.hero_path_draggable.get_hero_path()
		if hero_path == HeroesPaths.Enum.NONE:
			is_ok = false
			break
		
		for i in rankbox.skills.size():
			var skill_drg := rankbox.skills[i]
			if skill_drg.get_skill() == -1 and (i < 5 or HeroesPaths.is_abomination(hero_path)):
				is_ok = false
				break
		
	if is_ok:
		main_scene.popup_panel.show_panel(MyPopupPanel.MessageType.SAVE_SQUAD, Data.current_squad["squad_name"])
	else:
		main_scene.notification_panel.show_message("Heroes and/or skills not filled!")
