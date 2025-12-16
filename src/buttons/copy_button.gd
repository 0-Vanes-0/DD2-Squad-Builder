class_name CopyButton
extends Button

@export var main_scene: MainScene


func _ready() -> void:
	assert(main_scene)


func _on_pressed() -> void:
	var code := SquadCode.encode_squad(Data.current_squad)
	if code.is_empty():
		main_scene.notification_panel.show_message("Heroes and/or skills not filled!")
	else:
		DisplayServer.clipboard_set(code)
		main_scene.notification_panel.show_message("Copied!")
