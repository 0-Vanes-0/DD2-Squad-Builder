class_name HeroesMenu
extends MarginContainer

@export var main_scene: MainScene
@export_group("Required Children")
@export var heroes_table: GridContainer


func _ready() -> void:
	assert(main_scene and heroes_table)

	for node in heroes_table.get_children():
		node.queue_free()
	
	for value in HeroesPaths.Enum.values():
		if value == HeroesPaths.Enum.NONE:
			continue
		var hero_path_draggable := HeroPathDraggable.create(value)
		hero_path_draggable.info_requested.connect(
				func(hero_path: HeroesPaths.Enum):
					if hero_path == HeroesPaths.Enum.NONE:
						main_scene.notification_panel.hide()
					else:
						main_scene.notification_panel.show_hero_path(hero_path)
		)
		heroes_table.add_child(hero_path_draggable)
