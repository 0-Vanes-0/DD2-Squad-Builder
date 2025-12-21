class_name AllHeroesSkillsPropertiesDictionary
extends Resource

@export var properties: Dictionary[HeroesPaths.Enum, SkillsPropsDictionary] = {}


func get_tokens(of_hero_path: HeroesPaths.Enum, of_skill: int) -> Array[String]:
	if of_skill == -1:
		return []
	
	var tokens := properties[of_hero_path].get_tokens(of_skill)
	if tokens == null:
		var default_hero_path: HeroesPaths.Enum = HeroesPaths.Enum[HeroesPaths.to_hero(of_hero_path) + "0"] as HeroesPaths.Enum
		tokens = properties[default_hero_path].get_tokens(of_skill)
	
	return tokens
