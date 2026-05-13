class_name LinkIssueContainer
extends MarginContainer

@export var dialogues: ColorRect
@export var deeplink: Deeplink


func appear():
	var user_data := SaveLoad.load_data()
	if not user_data.has("refused_links"):
		dialogues.show()
		self.show()


func _on_yes_button_pressed() -> void:
	deeplink.navigate_to_open_by_default_settings()
	dialogues.hide()
	self.hide()


func _on_no_button_pressed() -> void:
	var user_data := SaveLoad.load_data()
	user_data["refused_links"] = 1
	SaveLoad.save_data(user_data)
	dialogues.hide()
	self.hide()
