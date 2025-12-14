class_name SavedSquadsMenu
extends MarginContainer

@export_group("Required Children")
@export var v_box: VBoxContainer
@export var no_squads_label: Label

var squad_boxes: Array[SquadBox] = []


func _ready() -> void:
	assert(no_squads_label and v_box)


func _on_visibility_changed() -> void:
	if self.visible:
		if squad_boxes.is_empty():
			no_squads_label.show()
		else:
			no_squads_label.hide()
			pass # TODO
