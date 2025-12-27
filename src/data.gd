extends Node

var heroes_textures: Dictionary[HeroesPaths.Enum, Texture2D] = {
	HeroesPaths.Enum.NONE: preload("res://assets/portraits/NONE.png"),
	HeroesPaths.Enum.A0: preload("res://assets/portraits/A0.png"),
	HeroesPaths.Enum.A1: preload("res://assets/portraits/A1.png"),
	HeroesPaths.Enum.A2: preload("res://assets/portraits/A2.png"),
	HeroesPaths.Enum.A3: preload("res://assets/portraits/A3.png"),
	HeroesPaths.Enum.B0: preload("res://assets/portraits/B0.png"),
	HeroesPaths.Enum.C0: preload("res://assets/portraits/C0.png"),
	HeroesPaths.Enum.C1: preload("res://assets/portraits/C1.png"),
	HeroesPaths.Enum.C2: preload("res://assets/portraits/C2.png"),
	HeroesPaths.Enum.C3: preload("res://assets/portraits/C3.png"),
	HeroesPaths.Enum.D0: preload("res://assets/portraits/D0.png"),
	HeroesPaths.Enum.D1: preload("res://assets/portraits/D1.png"),
	HeroesPaths.Enum.D2: preload("res://assets/portraits/D2.png"),
	HeroesPaths.Enum.D3: preload("res://assets/portraits/D3.png"),
	HeroesPaths.Enum.F0: preload("res://assets/portraits/F0.png"),
	HeroesPaths.Enum.F1: preload("res://assets/portraits/F1.png"),
	HeroesPaths.Enum.F2: preload("res://assets/portraits/F2.png"),
	HeroesPaths.Enum.F3: preload("res://assets/portraits/F3.png"),
	HeroesPaths.Enum.G0: preload("res://assets/portraits/G0.png"),
	HeroesPaths.Enum.G1: preload("res://assets/portraits/G1.png"),
	HeroesPaths.Enum.G2: preload("res://assets/portraits/G2.png"),
	HeroesPaths.Enum.G3: preload("res://assets/portraits/G3.png"),
	HeroesPaths.Enum.H0: preload("res://assets/portraits/H0.png"),
	HeroesPaths.Enum.H1: preload("res://assets/portraits/H1.png"),
	HeroesPaths.Enum.H2: preload("res://assets/portraits/H2.png"),
	HeroesPaths.Enum.H3: preload("res://assets/portraits/H3.png"),
	HeroesPaths.Enum.J0: preload("res://assets/portraits/J0.png"),
	HeroesPaths.Enum.J1: preload("res://assets/portraits/J1.png"),
	HeroesPaths.Enum.J2: preload("res://assets/portraits/J2.png"),
	HeroesPaths.Enum.J3: preload("res://assets/portraits/J3.png"),
	HeroesPaths.Enum.L0: preload("res://assets/portraits/L0.png"),
	HeroesPaths.Enum.L1: preload("res://assets/portraits/L1.png"),
	HeroesPaths.Enum.L2: preload("res://assets/portraits/L2.png"),
	HeroesPaths.Enum.L3: preload("res://assets/portraits/L3.png"),
	HeroesPaths.Enum.M0: preload("res://assets/portraits/M0.png"),
	HeroesPaths.Enum.M1: preload("res://assets/portraits/M1.png"),
	HeroesPaths.Enum.M2: preload("res://assets/portraits/M2.png"),
	HeroesPaths.Enum.M3: preload("res://assets/portraits/M3.png"),
	HeroesPaths.Enum.O0: preload("res://assets/portraits/O0.png"),
	HeroesPaths.Enum.O1: preload("res://assets/portraits/O1.png"),
	HeroesPaths.Enum.O2: preload("res://assets/portraits/O2.png"),
	HeroesPaths.Enum.O3: preload("res://assets/portraits/O3.png"),
	HeroesPaths.Enum.P0: preload("res://assets/portraits/P0.png"),
	HeroesPaths.Enum.P1: preload("res://assets/portraits/P1.png"),
	HeroesPaths.Enum.P2: preload("res://assets/portraits/P2.png"),
	HeroesPaths.Enum.P3: preload("res://assets/portraits/P3.png"),
	HeroesPaths.Enum.R0: preload("res://assets/portraits/R0.png"),
	HeroesPaths.Enum.R1: preload("res://assets/portraits/R1.png"),
	HeroesPaths.Enum.R2: preload("res://assets/portraits/R2.png"),
	HeroesPaths.Enum.R3: preload("res://assets/portraits/R3.png"),
	HeroesPaths.Enum.W0: preload("res://assets/portraits/W0.png"),
	HeroesPaths.Enum.W1: preload("res://assets/portraits/W1.png"),
	HeroesPaths.Enum.W2: preload("res://assets/portraits/W2.png"),
	HeroesPaths.Enum.W3: preload("res://assets/portraits/W3.png"),
	HeroesPaths.Enum.V0: preload("res://assets/portraits/V0.png"),
	HeroesPaths.Enum.V1: preload("res://assets/portraits/V1.png"),
	HeroesPaths.Enum.V2: preload("res://assets/portraits/V2.png"),
	HeroesPaths.Enum.V3: preload("res://assets/portraits/V3.png"),
}

@export var skills_textures: Dictionary[String, HeroSkillsTextures] = {
	"P": null,
	"G": null,
	"W": null,
	"M": null,
	"H": null,
	"J": null,
	"L": null,
	"O": null,
	"R": null,
	"V": null,
	"F": null,
	"D": null,
	"C": null,
	"A": null,
	"B": null,
	"-": null,
}
@export var hero_path_draggable_scene: PackedScene
@export var skill_draggable_scene: PackedScene

@export_file_path("*.json") var all_props_file: String
@export var all_icons: AllIconsDictionary
@export var all_heroes_skills_properties: AllHeroesSkillsPropertiesDictionary
const RANKS_TOKENS: Array[String] = ["heal", "stress", "execute", "move_ally", "aoe", "selfdmg"]

var current_squad: Dictionary = {
	"1": {
		"hero_path": HeroesPaths.Enum.NONE,
		"skills": [-1, -1, -1, -1, -1, -1, -1, -1, -1],
	},
	"2": {
		"hero_path": HeroesPaths.Enum.NONE,
		"skills": [-1, -1, -1, -1, -1, -1, -1, -1, -1],
	},
	"3": {
		"hero_path": HeroesPaths.Enum.NONE,
		"skills": [-1, -1, -1, -1, -1, -1, -1, -1, -1],
	},
	"4": {
		"hero_path": HeroesPaths.Enum.NONE,
		"skills": [-1, -1, -1, -1, -1, -1, -1, -1, -1],
	},
	"squad_name": "",
}
var settings: Dictionary
var DEFAULT_SETTINGS := {
	"language": "eng",
}
var all_props: AllPropertiesDictionary


func _ready() -> void:
	assert(hero_path_draggable_scene and skill_draggable_scene)
	for hst in skills_textures.values():
		assert(hst is HeroSkillsTextures, "All skills_textures values must be HeroSkillsTextures")
	
	var file := FileAccess.open(all_props_file, FileAccess.READ)
	var error: Error = FileAccess.get_open_error()
	assert(error == OK, "Error upon reading all_properties file!")
	var text := file.get_as_text()
	all_props = AllPropertiesDictionary.create(text)


func get_skill_texture(hero_path: HeroesPaths.Enum, skill_number: int) -> Texture2D:
	if hero_path == HeroesPaths.Enum.NONE or skill_number == -1:
		return skills_textures["-"].skills[0]
	
	var hero: String = HeroesPaths.to_hero(hero_path)
	return skills_textures[hero].skills[skill_number]


func get_empty_skills() -> Array[int]:
	var array: Array[int] = []
	array.resize(9)
	array.fill(-1)
	return array
