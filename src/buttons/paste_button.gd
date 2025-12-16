class_name PasteButton
extends Button

@export var main_scene: MainScene


func _ready() -> void:
	assert(main_scene)


func _on_pressed() -> void:
	var code := DisplayServer.clipboard_get()
	main_scene.paste_squad_data(code)
