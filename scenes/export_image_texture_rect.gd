class_name EITR
extends TextureRect

signal go_back


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hide_export_image"):
		go_back.emit()
