class_name HeroesMenu
extends MarginContainer

@export_group("Required Children")
@export var heroes_table: GridContainer


func _ready() -> void:
	assert(heroes_table)

	for node in heroes_table.get_children():
		node.queue_free()
	
	for value in HeroesPaths.Enum.values():
		if value == HeroesPaths.Enum.NONE:
			continue
		var hero_path_draggable := HeroPathDraggable.create(value)
		heroes_table.add_child(hero_path_draggable)
