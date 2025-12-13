class_name RankBox
extends VBoxContainer

signal rank_changed(from_rank: int, to_rank: int, hero_path: Data.HeroesPaths, skills: Array[int])

@export_range(1, 4) var rank := 0
@export var hero_path_draggable: HeroPathDraggable
@export var skills: Array[SkillDraggable] = [null, null, null, null, null]


func _ready() -> void:
	assert(hero_path_draggable)
	for skill in skills:
		assert(skill)
	
	hero_path_draggable.hero_dropped.connect(
			func(from_rank: int, to_rank: int):
				var array: Array[int] = []
				for skill in skills:
					array.append(skill.skill_number)
				rank_changed.emit(from_rank, to_rank, hero_path_draggable.hero_path, array)
	)
