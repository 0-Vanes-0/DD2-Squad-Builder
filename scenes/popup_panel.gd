class_name MyPopupPanel
extends PopupPanel

enum MessageType {
	NONE, SAVE_SQUAD, RENAME_SQUAD, DELETE_SQUAD
}

signal save_requested(squad_name: String)
signal rename_requested(from_squad_name: String, to_squad_name: String)
signal delete_requested(squad_name: String)

@export var color_rect: ColorRect
@export_group("Required Children")
@export var message_label: Label
@export var line_edit: LineEdit
@export var ok_button: Button

var current_type: MessageType = MessageType.NONE
var squad_name := ""


func _ready() -> void:
	assert(color_rect and message_label and line_edit and ok_button)


func show_panel(type: MessageType, arg := "") -> void:
	current_type = type
	message_label.show()
	match type:
		MessageType.SAVE_SQUAD:
			self.title = "Saving squad..."
			message_label.text = ""
			line_edit.text = arg
			line_edit.placeholder_text = "Enter squad name..."
			line_edit.show()

		MessageType.RENAME_SQUAD:
			squad_name = arg
			self.title = "Renaming squad..."
			message_label.text = ""
			line_edit.show()
			line_edit.text = arg
			line_edit.placeholder_text = "Enter new squad name..."

		MessageType.DELETE_SQUAD:
			squad_name = arg
			self.title = "Deleting squad..."
			message_label.text = "Delete squad '%s'?" % arg
			line_edit.hide()

	color_rect.show()
	self.popup(Rect2i(0, 0, 360, 240))
	(self.get_child(0) as MarginContainer).set_anchors_preset(Control.PRESET_FULL_RECT)


func _on_close_requested() -> void:
	_on_popup_hide()


func _on_popup_hide() -> void:
	color_rect.hide()
	self.hide() # Just in case.


func _on_ok_button_pressed() -> void:
	var user_data := SaveLoad.load_data()
	match current_type:
		MessageType.SAVE_SQUAD:
			var name_text := line_edit.text.strip_edges()
			var no_spaces_text := name_text.replace(" ", "_")
			if no_spaces_text.substr(0, 1).is_valid_int():
				no_spaces_text[0] = "_"
			
			for value in user_data.values():
				if value is Dictionary:
					var saved_name := value["squad_name"] as String
					if saved_name.to_lower() == name_text.to_lower():
						message_label.text = "Squad name already existing!"
						return
			
			if name_text == "":
				message_label.text = "Squad name cannot be empty!"
				return
			if not no_spaces_text.is_valid_ascii_identifier():
				message_label.text = "The name may contain only letters, digits and spaces."
				return
			save_requested.emit(name_text)
			close_requested.emit()
		
		MessageType.RENAME_SQUAD:
			var name_text := line_edit.text.strip_edges()
			for value in user_data.values():
				if value is Dictionary:
					var saved_name := value["squad_name"] as String
					if saved_name.to_lower() == name_text.to_lower():
						message_label.text = "Squad name already existing!"
						return
			
			if name_text == "":
				message_label.text = "Squad name cannot be empty!"
				return
			if name_text == squad_name:
				message_label.text = "Squad name is same as previous!"
				return
			if name_text.contains("|"):
				message_label.text = "The symbol | is prohibited due to its usage in codes."
				return
			rename_requested.emit(squad_name, name_text)
			close_requested.emit()
		
		MessageType.DELETE_SQUAD:
			delete_requested.emit(squad_name)
			close_requested.emit()
