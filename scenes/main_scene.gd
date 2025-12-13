class_name MainScene
extends Control

@export var tab_container: TabContainer
@export var heroes_table: GridContainer
@export var rank_boxes: Array[RankBox]


func _ready() -> void:
	assert(tab_container and heroes_table and rank_boxes.size() == 4)
	tab_container.current_tab = 0
	
	for node in heroes_table.get_children():
		node.queue_free()
	
	for value in Data.HeroesPaths.values():
		if value == Data.HeroesPaths.NONE:
			continue
		var hero_path_draggable := HeroPathDraggable.create(value)
		heroes_table.add_child(hero_path_draggable)
	
	for rank_box in rank_boxes:
		rank_box.rank_changed.connect(
				func(from_rank: int, to_rank: int, hero_path: Data.HeroesPaths, skills: Array[int]):
					pass # Add data
		)
