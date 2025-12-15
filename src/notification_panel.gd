class_name NotificationPanel
extends PanelContainer

const DURATION_PER_CHARACTER := 0.1 # seconds
@export var label: Label
var is_on_right := true


func _ready() -> void:
	assert(label)
	self.hide()


func _physics_process(_delta: float) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	self.position = mouse_pos + Vector2.UP * self.size
	if not is_on_right:
		self.position += Vector2.LEFT * self.size


func show_message(message: String, is_hover := false, on_right := true):
	is_on_right = on_right
	label.text = " " + message + " "
	self.size.x = 1
	self.show()
	if not is_hover: # is lick
		await get_tree().create_timer(DURATION_PER_CHARACTER * message.length()).timeout
		self.hide()
