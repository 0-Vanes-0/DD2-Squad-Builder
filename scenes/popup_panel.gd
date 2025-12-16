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
	self.size = Vector2(360, 240)
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
	self.popup()


func _on_close_requested() -> void:
	_on_popup_hide()


func _on_popup_hide() -> void:
	color_rect.hide()
	self.hide() # Just in case.


func _on_ok_button_pressed() -> void:
	match current_type:
		MessageType.SAVE_SQUAD:
			if line_edit.text.strip_edges() == "":
				message_label.text = "Squad name cannot be empty!"
				return
			if line_edit.text.contains("|"):
				message_label.text = "The symbol | is prohibited due to its usage in codes."
				return
			save_requested.emit(line_edit.text)
			close_requested.emit()
		
		MessageType.RENAME_SQUAD:
			if line_edit.text.strip_edges() == "":
				message_label.text = "Squad name cannot be empty!"
				return
			if line_edit.text.strip_edges() == squad_name:
				message_label.text = "Squad name is same as previous!"
				return
			if line_edit.text.contains("|"):
				message_label.text = "The symbol | is prohibited due to its usage in codes."
				return
			rename_requested.emit(squad_name, line_edit.text)
			close_requested.emit()
		
		MessageType.DELETE_SQUAD:
			delete_requested.emit(squad_name)
			close_requested.emit()
