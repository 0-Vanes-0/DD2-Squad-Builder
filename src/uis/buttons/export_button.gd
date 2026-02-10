class_name ExportButton
extends Button

@export var main_scene: MainScene
@export var dialogues: ColorRect
@export var export_image_texture_rect: EITR
@export var export_viewport: ExportSubViewport


func _ready() -> void:
	export_image_texture_rect.go_back.connect(
			func():
				dialogues.hide()
				export_image_texture_rect.hide()
	)


func _on_pressed() -> void:
	var is_ok := true
	
	var heroes_skills: Dictionary[HeroesPaths.Enum, Array] = {}
	for rankbox: RankBox in main_scene.rank_boxes.values():
		if rankbox.hero_path_draggable.get_hero_path() == HeroesPaths.Enum.NONE:
			is_ok = false
			break
		heroes_skills[rankbox.hero_path_draggable.get_hero_path()] = []
		for i in rankbox.skills.size():
			var skill_drg := rankbox.skills[i]
			heroes_skills[rankbox.hero_path_draggable.get_hero_path()].append(skill_drg.get_skill())
		
	if is_ok:
		dialogues.show()
		var texture := await export_viewport.generate_texture()
		export_image_texture_rect.texture = texture
		export_image_texture_rect.show()
	else:
		main_scene.notification_panel.show_message("Heroes and/or skills not filled!")
