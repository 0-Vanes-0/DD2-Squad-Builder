class_name SavedSquadsMenu
extends MarginContainer

@export_group("Required Children")
@export var vbox: VBoxContainer
@export var no_squads_label: Label


func _ready() -> void:
	assert(no_squads_label and vbox)


func _on_visibility_changed() -> void:
	if self.visible:
		for child in vbox.get_children():
			child.queue_free()

		var user_data := SaveLoad.load_data()
		if user_data.is_empty():
			no_squads_label.show()
		else:
			no_squads_label.hide()
			for key in user_data.keys():
				var squad_data := user_data[key] as Dictionary
				var squad_box := SquadBox.create(squad_data)
				vbox.add_child(squad_box)
