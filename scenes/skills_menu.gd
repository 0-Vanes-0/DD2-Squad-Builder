class_name SkillsMenu
extends MarginContainer

@export var main_scene: MainScene
@export_group("Required Children")
@export var no_skills_label: Label
@export var rank1_grid: GridContainer
@export var rank2_grid: GridContainer
@export var rank3_grid: GridContainer
@export var rank4_grid: GridContainer

var rank_grids: Array[GridContainer]


func _ready() -> void:
	assert(no_skills_label and rank1_grid and rank2_grid and rank3_grid and rank4_grid and main_scene)
	no_skills_label.visible = true
	rank_grids = [rank1_grid, rank2_grid, rank3_grid, rank4_grid]


func _on_visibility_changed() -> void:
	if self.visible:
		for grid in rank_grids:
			for child in grid.get_children():
				child.queue_free()
			grid.get_parent().hide()
		
		var hero_paths: Array[Data.HeroesPaths] = []
		for rank_box: RankBox in main_scene.rank_boxes.values():
			hero_paths.append(rank_box.hero_path_draggable.hero_path)
		
		if hero_paths.any( func(hp: Data.HeroesPaths): return hp != Data.HeroesPaths.NONE ):
			no_skills_label.hide()
			for i in hero_paths.size():
				if hero_paths[i] != Data.HeroesPaths.NONE:
					rank_grids[i].get_parent().show()
					rank_grids[i].add_child(Control.new())

					var hero := Data.hero_path_to_hero(hero_paths[i])
					for j in Data.skills_textures[hero].skills.size():
						var skill_draggable := SkillDraggable.create(hero_paths[i], j)
						rank_grids[i].add_child(skill_draggable)

		else:
			no_skills_label.show()
