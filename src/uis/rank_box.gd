class_name RankBox
extends VBoxContainer

@export_range(0, 4) var rank := 0
@export var hero_path_draggable: HeroPathDraggable
@export var grid: GridContainer
@export var skills: Array[SkillDraggable] = [null, null, null, null, null, null, null, null, null]


func _ready() -> void:
	assert(hero_path_draggable and grid)
	for skill_draggable in skills:
		assert(skill_draggable)
		skill_draggable.is_unique = (
				func(dropped_skill_number: int) -> bool: 
					return skills.all(
							func(s: SkillDraggable):
								return s.get_skill() != dropped_skill_number
					)
		)
		skill_draggable.hide()


func get_skills() -> Array[int]:
	var skill_numbers: Array[int] = []
	for skill_drg in skills:
		skill_numbers.append(skill_drg.get_skill())
	return skill_numbers


func set_skills(skill_numbers: Array[int], hero_path: HeroesPaths.Enum):
	for i in skill_numbers.size():
		skills[i].set_skill(hero_path, skill_numbers[i])
	
	update_skills_visibility()


func update_skills_visibility():
	if hero_path_draggable.get_hero_path() == HeroesPaths.Enum.NONE:
		for skill in skills:
			skill.hide()
	else:
		var is_abomination := HeroesPaths.is_abomination(hero_path_draggable.get_hero_path())
		for i in skills.size():
			skills[i].visible = is_abomination or i < 5
		
		grid.columns = 2 if is_abomination else 1
