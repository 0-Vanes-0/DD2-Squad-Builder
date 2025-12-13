class_name NotificationPanel
extends PanelContainer

const DURATION := 2.0 # seconds
const Messages: Dictionary[String, String] = {
	"copy": "Squad copied!",
	"paste_error": "Wrong squad data in clipboard.",

}
@export var label: Label


func _ready() -> void:
	assert(label)
	self.hide()


func _physics_process(_delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	self.position = mouse_pos


func show_message(message_key: String):
	label.text = Messages.get(message_key, "...")
	self.show()
	await get_tree().create_timer(DURATION).timeout
	self.hide()
