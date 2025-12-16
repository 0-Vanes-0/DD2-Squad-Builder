extends Node

enum HeroesPaths {
	NONE,
	P0, P1, P2, P3,
	G0, G1, G2, G3,
	W0, W1, W2, W3,
	M0, M1, M2, M3,
	H0, H1, H2, H3,
	J0, J1, J2, J3,
	L0, L1, L2, L3,
	O0, O1, O2, O3,
	R0, R1, R2, R3,
	V0, V1, V2, V3,
	F0, F1, F2, F3,
	D0, D1, D2, D3,
	C0, C1, C2, C3,
	A0, A1, A2, A3,
	B0,
}

var heroes_textures: Dictionary[HeroesPaths, Texture2D] = {
	HeroesPaths.NONE: preload("res://assets/portraits/NONE.png"),
	HeroesPaths.A0: preload("res://assets/portraits/A0.png"),
	HeroesPaths.A1: preload("res://assets/portraits/A1.png"),
	HeroesPaths.A2: preload("res://assets/portraits/A2.png"),
	HeroesPaths.A3: preload("res://assets/portraits/A3.png"),
	HeroesPaths.B0: preload("res://assets/portraits/B0.png"),
	HeroesPaths.C0: preload("res://assets/portraits/C0.png"),
	HeroesPaths.C1: preload("res://assets/portraits/C1.png"),
	HeroesPaths.C2: preload("res://assets/portraits/C2.png"),
	HeroesPaths.C3: preload("res://assets/portraits/C3.png"),
	HeroesPaths.D0: preload("res://assets/portraits/D0.png"),
	HeroesPaths.D1: preload("res://assets/portraits/D1.png"),
	HeroesPaths.D2: preload("res://assets/portraits/D2.png"),
	HeroesPaths.D3: preload("res://assets/portraits/D3.png"),
	HeroesPaths.F0: preload("res://assets/portraits/F0.png"),
	HeroesPaths.F1: preload("res://assets/portraits/F1.png"),
	HeroesPaths.F2: preload("res://assets/portraits/F2.png"),
	HeroesPaths.F3: preload("res://assets/portraits/F3.png"),
	HeroesPaths.G0: preload("res://assets/portraits/G0.png"),
	HeroesPaths.G1: preload("res://assets/portraits/G1.png"),
	HeroesPaths.G2: preload("res://assets/portraits/G2.png"),
	HeroesPaths.G3: preload("res://assets/portraits/G3.png"),
	HeroesPaths.H0: preload("res://assets/portraits/H0.png"),
	HeroesPaths.H1: preload("res://assets/portraits/H1.png"),
	HeroesPaths.H2: preload("res://assets/portraits/H2.png"),
	HeroesPaths.H3: preload("res://assets/portraits/H3.png"),
	HeroesPaths.J0: preload("res://assets/portraits/J0.png"),
	HeroesPaths.J1: preload("res://assets/portraits/J1.png"),
	HeroesPaths.J2: preload("res://assets/portraits/J2.png"),
	HeroesPaths.J3: preload("res://assets/portraits/J3.png"),
	HeroesPaths.L0: preload("res://assets/portraits/L0.png"),
	HeroesPaths.L1: preload("res://assets/portraits/L1.png"),
	HeroesPaths.L2: preload("res://assets/portraits/L2.png"),
	HeroesPaths.L3: preload("res://assets/portraits/L3.png"),
	HeroesPaths.M0: preload("res://assets/portraits/M0.png"),
	HeroesPaths.M1: preload("res://assets/portraits/M1.png"),
	HeroesPaths.M2: preload("res://assets/portraits/M2.png"),
	HeroesPaths.M3: preload("res://assets/portraits/M3.png"),
	HeroesPaths.O0: preload("res://assets/portraits/O0.png"),
	HeroesPaths.O1: preload("res://assets/portraits/O1.png"),
	HeroesPaths.O2: preload("res://assets/portraits/O2.png"),
	HeroesPaths.O3: preload("res://assets/portraits/O3.png"),
	HeroesPaths.P0: preload("res://assets/portraits/P0.png"),
	HeroesPaths.P1: preload("res://assets/portraits/P1.png"),
	HeroesPaths.P2: preload("res://assets/portraits/P2.png"),
	HeroesPaths.P3: preload("res://assets/portraits/P3.png"),
	HeroesPaths.R0: preload("res://assets/portraits/R0.png"),
	HeroesPaths.R1: preload("res://assets/portraits/R1.png"),
	HeroesPaths.R2: preload("res://assets/portraits/R2.png"),
	HeroesPaths.R3: preload("res://assets/portraits/R3.png"),
	HeroesPaths.W0: preload("res://assets/portraits/W0.png"),
	HeroesPaths.W1: preload("res://assets/portraits/W1.png"),
	HeroesPaths.W2: preload("res://assets/portraits/W2.png"),
	HeroesPaths.W3: preload("res://assets/portraits/W3.png"),
	HeroesPaths.V0: preload("res://assets/portraits/V0.png"),
	HeroesPaths.V1: preload("res://assets/portraits/V1.png"),
	HeroesPaths.V2: preload("res://assets/portraits/V2.png"),
	HeroesPaths.V3: preload("res://assets/portraits/V3.png"),
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

var current_squad: Dictionary = {
	"1": {
		"hero_path": HeroesPaths.NONE,
		"skills": [-1, -1, -1, -1, -1],
	},
	"2": {
		"hero_path": HeroesPaths.NONE,
		"skills": [-1, -1, -1, -1, -1],
	},
	"3": {
		"hero_path": HeroesPaths.NONE,
		"skills": [-1, -1, -1, -1, -1],
	},
	"4": {
		"hero_path": HeroesPaths.NONE,
		"skills": [-1, -1, -1, -1, -1],
	},
	"squad_name": "",
}

var settings: Dictionary
var DEFAULT_SETTINGS := {
	"language": "eng",
}


func _ready() -> void:
	assert(hero_path_draggable_scene and skill_draggable_scene)
	for hst in skills_textures.values():
		assert(hst is HeroSkillsTextures, "All skills_textures values must be HeroSkillsTextures")


func get_skill_texture(hero_path: Data.HeroesPaths, skill_number: int) -> Texture2D:
	if hero_path == Data.HeroesPaths.NONE or skill_number == -1:
		return skills_textures["-"].skills[0]
	
	var hero: String = Data.hero_path_to_hero(hero_path)
	return skills_textures[hero].skills[skill_number]


func hero_path_to_hero(hero_path: Data.HeroesPaths) -> String:
	return (Data.HeroesPaths.keys()[hero_path] as String).substr(0, 1)
