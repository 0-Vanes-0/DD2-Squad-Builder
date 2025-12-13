class_name MainScene
extends Control

@export var tab_container: TabContainer
@export var heroes_table: GridContainer


func _ready() -> void:
	assert(tab_container and heroes_table)
	tab_container.current_tab = 0
	
	for node in heroes_table.get_children():
		node.queue_free()
	
	for value in Data.HeroesPaths.values():
		if value == Data.HeroesPaths.NONE:
			continue
		var hero_path_draggable := HeroPathDraggable.create(value)
		heroes_table.add_child(hero_path_draggable)
