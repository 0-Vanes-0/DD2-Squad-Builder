class_name RankBox
extends VBoxContainer

@export var hero_path_draggable: HeroPathDraggable
var skills: Array[SkillSlot] = []


func _ready() -> void:
	assert(hero_path_draggable)
