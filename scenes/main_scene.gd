class_name MainScene
extends Control

@export_group("Required Chilren")
@export var tab_container: TabContainer
@export var heroes_table: GridContainer
@export var split_container: HSplitContainer
@export var rank_boxes: Dictionary[int, RankBox] = {
	1: null,
	2: null,
	3: null,
	4: null,
}


func _ready() -> void:
	assert(tab_container and heroes_table and split_container)
	for rank_box in rank_boxes.values():
		assert(rank_box)
	tab_container.current_tab = 0
	
	for node in heroes_table.get_children():
		node.queue_free()
	
	for value in Data.HeroesPaths.values():
		if value == Data.HeroesPaths.NONE:
			continue
		var hero_path_draggable := HeroPathDraggable.create(value)
		heroes_table.add_child(hero_path_draggable)
	
	for rank_box: RankBox in rank_boxes.values():
		rank_box.hero_path_draggable.hero_dropped.connect(
				func(from_rank: int):
					# If dropped from another rank box:
					if from_rank > 0:
						if from_rank != rank_box.rank:
							var temp: Array[int] = rank_boxes[from_rank].get_skills()
							rank_boxes[from_rank].set_skills(rank_box.get_skills(), rank_box.hero_path_draggable.hero_path)
							rank_box.set_skills(temp, rank_boxes[from_rank].hero_path_draggable.hero_path)
					
					# If dropped from heroes table:
					else:
						var hero_path_from_data := Data.dict[rank_box.rank]["hero_path"] as Data.HeroesPaths
						var hero_path_dropped := rank_box.hero_path_draggable.hero_path
						var hero_from_data := Data.hero_path_to_hero(hero_path_from_data)
						var hero_dropped := Data.hero_path_to_hero(hero_path_dropped)
						if hero_from_data != hero_dropped:
							rank_box.set_skills([-1, -1, -1, -1, -1], Data.HeroesPaths.NONE)
					
					update_heroes_in_data()
		)

		for skill_draggable in rank_box.skills:
			skill_draggable.skill_dropped.connect( func(): update_heroes_in_data() )


func _on_resized() -> void:
	var tab_container_size := 600
	split_container.split_offset = int(self.size.x) - tab_container_size


func update_heroes_in_data():
	for rank_box: RankBox in rank_boxes.values():
		var rank := rank_box.rank
		Data.dict[rank]["hero_path"] = rank_box.hero_path_draggable.hero_path
		Data.dict[rank]["skills"] = rank_box.get_skills()
