class_name GooglePlayContainer
extends MarginContainer

@export var dialogues: ColorRect


func _ready() -> void:
	if not Data.is_android:
		var user_data := SaveLoad.load_data()
		if not user_data.has("visited"):
			dialogues.show()
			self.show()
		else:
			self.hide()


func _input(event: InputEvent) -> void:
	if self.visible and event.is_action_pressed("hide_export_image") or event is InputEventScreenTouch:
		var user_data := SaveLoad.load_data()
		user_data["visited"] = 1
		SaveLoad.save_data(user_data)
		dialogues.hide()
		self.hide()
