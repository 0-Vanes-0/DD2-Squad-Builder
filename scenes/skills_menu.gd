class_name SkillsMenu
extends MarginContainer

@export var no_skills_label: Label


func _ready() -> void:
	assert(no_skills_label)
	no_skills_label.visible = true


func _on_visibility_changed() -> void:
	if self.visible:
		no_skills_label.visible = true
