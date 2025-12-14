class_name ClearButton
extends Button

@export var main_scene: MainScene


func _ready() -> void:
	assert(main_scene)


func _on_pressed() -> void:
	for rank_box: RankBox in main_scene.rank_boxes.values():
		rank_box.hero_path_draggable.hero_path = Data.HeroesPaths.NONE
		rank_box.hero_path_draggable.texture = Data.heroes_textures[Data.HeroesPaths.NONE]
		rank_box.set_skills([-1, -1, -1, -1, -1], Data.HeroesPaths.NONE)
		for skill in rank_box.skills:
			skill.hide()
	
	main_scene.update_heroes_in_data()
	main_scene.tab_container.current_tab = 0
	main_scene.tab_bar.current_tab = 0
