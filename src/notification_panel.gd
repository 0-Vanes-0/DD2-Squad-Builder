class_name NotificationPanel
extends PanelContainer

const DURATION_PER_CHARACTER := 0.1 # seconds
@export var label: Label


func _ready() -> void:
	assert(label)
	self.hide()


func _physics_process(_delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	self.position = mouse_pos + Vector2.UP * self.size


func show_message(message: String):
	label.text = " " + message + " "
	self.show()
	await get_tree().create_timer(DURATION_PER_CHARACTER * message.length()).timeout
	self.hide()
