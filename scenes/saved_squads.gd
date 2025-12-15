class_name SavedSquadsMenu
extends MarginContainer

@export_group("Required Children")
@export var vbox: VBoxContainer
@export var no_squads_label: Label


func _ready() -> void:
	assert(no_squads_label and vbox)


func _on_visibility_changed() -> void:
	if self.visible:
		var user_data := SaveLoad.load_data()
		print("Loaded saved squads: %s" % user_data)
		if user_data.is_empty():
			no_squads_label.show()
		else:
			no_squads_label.hide()
			var names: Array[String] = []
			for node: SquadBox in vbox.get_children():
				var n := node.squad_data["squad_name"] as String
				names.append(n)

			print("Existing squad boxes: ", names)
			for key in user_data.keys():
				if not key in names:
					print("Creating squad box for: %s" % key)
					var squad_data := user_data[key] as Dictionary
					var squad_box := SquadBox.create(squad_data)
					vbox.add_child(squad_box)
