class_name HeroesMenu
extends MarginContainer

@export_group("Required Children")
@export var heroes_table: GridContainer


func _ready() -> void:
	assert(heroes_table)

	for node in heroes_table.get_children():
		node.queue_free()
	
	for value in Data.HeroesPaths.values():
		if value == Data.HeroesPaths.NONE:
			continue
		var hero_path_draggable := HeroPathDraggable.create(value)
		heroes_table.add_child(hero_path_draggable)
