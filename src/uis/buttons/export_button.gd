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
		dialogues.show()
		var texture := await export_viewport.generate_texture()
		export_image_texture_rect.texture = texture
		export_image_texture_rect.show()
	else:
		main_scene.notification_panel.show_message("Heroes and/or skills not filled!")
