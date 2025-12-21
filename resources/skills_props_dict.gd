class_name SkillsPropsDictionary
extends Resource

@export var info: Dictionary[int, PropertiesArray] = {
	0: null,
	1: null,
	2: null,
	3: null,
	4: null,
	5: null,
	6: null,
	7: null,
	8: null,
	9: null,
	10: null,
}


func get_tokens(of_skill: int) -> Array[String]:
	if info[of_skill] == null:
		return []
	return info[of_skill].get_all()
