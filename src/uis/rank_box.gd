class_name RankBox
extends VBoxContainer

@export_range(0, 4) var rank := 0
@export var hero_path_draggable: HeroPathDraggable
@export var grid: GridContainer
@export var skills: Array[SkillDraggable] = [null, null, null, null, null, null, null, null, null]
@export var self_ranks: HBoxContainer
@export var target_ranks: HBoxContainer


func _ready() -> void:
	assert(hero_path_draggable and grid and self_ranks and target_ranks)
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
	
	self_ranks.hide()
	target_ranks.hide()


func get_skills() -> Array[int]:
	var skill_numbers: Array[int] = []
	for skill_drg in skills:
		skill_numbers.append(skill_drg.get_skill())
	
	_update_ranks_map()
	return skill_numbers


func set_skills(skill_numbers: Array[int], hero_path: HeroesPaths.Enum):
	for i in skill_numbers.size():
		skills[i].set_skill(hero_path, skill_numbers[i])
	
	_update_skills_visibility()
	_update_ranks_map()


func _update_skills_visibility():
	if hero_path_draggable.get_hero_path() == HeroesPaths.Enum.NONE:
		for skill in skills:
			skill.hide()
	else:
		var is_abomination := HeroesPaths.is_abomination(hero_path_draggable.get_hero_path())
		for i in skills.size():
			skills[i].visible = is_abomination or i < 5
		
		grid.columns = 2 if is_abomination else 1
		
		if is_abomination:
			var last_skill := skills.back() as SkillDraggable
			last_skill.set_skill(hero_path_draggable.get_hero_path(), 5)
			last_skill.is_dragging_enabled = false


func _update_ranks_map():
	if skills.all( func(skill: SkillDraggable): return skill.get_skill() == -1 ):
		self_ranks.hide()
		target_ranks.hide()
		return
	
	var dict := {
		"self": {
			"rank_1": self_ranks.get_child(3),
			"rank_2": self_ranks.get_child(2),
			"rank_3": self_ranks.get_child(1),
			"rank_4": self_ranks.get_child(0),
			"count_1": 0,
			"count_2": 0,
			"count_3": 0,
			"count_4": 0,
		},
		"target": {
			"rank_1": target_ranks.get_child(0),
			"rank_2": target_ranks.get_child(1),
			"rank_3": target_ranks.get_child(2),
			"rank_4": target_ranks.get_child(3),
			"count_1": 0,
			"count_2": 0,
			"count_3": 0,
			"count_4": 0,
		},
	}
	for skill in skills:
		var skill_hero_path_assigned := skill.get_hero_path_assigned()
		var skill_number := skill.get_skill()
		if (
				skill_hero_path_assigned == HeroesPaths.Enum.NONE or skill_number == -1
				or
				HeroesPaths.is_abomination(skill_hero_path_assigned) and skill_number > 5
		):
			continue
		
		var skill_data = Data.all_skills_comments.get_skill_data(skill_hero_path_assigned, skill_number)
		var self_ranks_numbers := (skill_data["skill_ranks"] as String).split()
		var target_ranks_numbers := (skill_data["target_ranks"] as String).split()
		for text in self_ranks_numbers:
			if text == "1":
				dict["self"]["count_1"] += 1
			elif text == "2":
				dict["self"]["count_2"] += 1
			elif text == "3":
				dict["self"]["count_3"] += 1
			elif text == "4":
				dict["self"]["count_4"] += 1
		
		if skill_data["target_type"] == "enemy":
			for text in target_ranks_numbers:
				if text == "1":
					dict["target"]["count_1"] += 1
				elif text == "2":
					dict["target"]["count_2"] += 1
				elif text == "3":
					dict["target"]["count_3"] += 1
				elif text == "4":
					dict["target"]["count_4"] += 1
	
	(dict["self"]["rank_1"] as TextureRect).texture = Data.self_ranks_images[dict["self"]["count_1"]]
	(dict["self"]["rank_2"] as TextureRect).texture = Data.self_ranks_images[dict["self"]["count_2"]]
	(dict["self"]["rank_3"] as TextureRect).texture = Data.self_ranks_images[dict["self"]["count_3"]]
	(dict["self"]["rank_4"] as TextureRect).texture = Data.self_ranks_images[dict["self"]["count_4"]]
	
	(dict["target"]["rank_1"] as TextureRect).texture = Data.target_ranks_images[dict["target"]["count_1"]]
	(dict["target"]["rank_2"] as TextureRect).texture = Data.target_ranks_images[dict["target"]["count_2"]]
	(dict["target"]["rank_3"] as TextureRect).texture = Data.target_ranks_images[dict["target"]["count_3"]]
	(dict["target"]["rank_4"] as TextureRect).texture = Data.target_ranks_images[dict["target"]["count_4"]]
	self_ranks.show()
	target_ranks.show()
