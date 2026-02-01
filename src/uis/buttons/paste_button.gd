class_name PasteButton
extends Button

@export var main_scene: MainScene


func _ready() -> void:
	assert(main_scene)


func _on_pressed() -> void:
	var code := DisplayServer.clipboard_get()
	if code.is_empty():
		print_debug("Clipboard is empty, waiting for clipboard to be populated...")
		await get_tree().create_timer(0.2).timeout
		code = DisplayServer.clipboard_get()
	print_debug("Pasting squad code from clipboard: %s" % str(code))
	main_scene.paste_squad_data(code)
