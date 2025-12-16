class_name RankBox
extends VBoxContainer

@export_range(0, 4) var rank := 0
@export var hero_path_draggable: HeroPathDraggable
@export var grid: GridContainer
@export var skills: Array[SkillDraggable] = [null, null, null, null, null, null, null, null, null]


func _ready() -> void:
	assert(hero_path_draggable and grid)
	for skill in skills:
		assert(skill)
		skill.is_unique = (
				func(dropped_skill_number: int) -> bool: 
					return skills.all(
							func(s: SkillDraggable):
								return s.skill_number != dropped_skill_number
					)
		)
		skill.hide()


func get_skills() -> Array[int]:
	var skill_numbers: Array[int] = []
	for skill in skills:
		skill_numbers.append(skill.skill_number)
	return skill_numbers


func set_skills(skill_numbers: Array[int], hero_path: Data.HeroesPaths):
	for i in skill_numbers.size():
		skills[i].hero_path_assigned = hero_path
		skills[i].skill_number = skill_numbers[i]
		skills[i].texture = Data.get_skill_texture(hero_path, skill_numbers[i])


func update_skills_visibility():
	if hero_path_draggable.hero_path == Data.HeroesPaths.NONE:
		for skill in skills:
			skill.hide()
	else:
		var is_abomination := Data.is_abomination(hero_path_draggable.hero_path)
		for i in skills.size():
			skills[i].visible = is_abomination or i < 5
		
		grid.columns = 2 if is_abomination else 1
