class_name ClearButton
extends Button

@export var main_scene: MainScene


func _ready() -> void:
	assert(main_scene)


func _on_pressed() -> void:
	for rank_box: RankBox in main_scene.rank_boxes.values():
		rank_box.hero_path_draggable.set_hero_path(HeroesPaths.Enum.NONE)
		rank_box.set_skills(Data.get_empty_skills(), HeroesPaths.Enum.NONE)
		for skill in rank_box.skills:
			skill.hide()
	
	main_scene.update_heroes_in_data()
	if main_scene.tab_container.current_tab == 1:
		main_scene.tab_container.current_tab = 0
		main_scene.tab_bar.current_tab = 0
