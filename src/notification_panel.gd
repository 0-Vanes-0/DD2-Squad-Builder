class_name NotificationPanel
extends PanelContainer

const DURATION_PER_CHARACTER := 0.1 # seconds
@export var label: RichTextLabel


func _ready() -> void:
	assert(label)
	self.hide()


func _process(_delta: float) -> void:
	if self.visible:
		_update_position()


func show_message(message: String, is_hover := false):
	label.clear()
	label.append_text(" " + message + " ")
	self.show()
	
	self.reset_size.call_deferred()
	
	if not is_hover: # is click
		await get_tree().create_timer(DURATION_PER_CHARACTER * message.length()).timeout
		self.hide()


func show_hero_path(hero_path: HeroesPaths.Enum):
	var path_name := Data.all_paths_names.get_path_name(hero_path)
	var path_comment := Data.all_props.get_path_comment(hero_path, true)
	var full_message := "[b]%s[/b]" % [path_name]
	full_message += "\n\n" + path_comment if not path_comment.is_empty() else ""
	show_message(full_message, true)


func _update_position():
	var viewport_rect: Rect2 = self.get_viewport().get_visible_rect()
	var mouse_pos: Vector2 = self.get_global_mouse_position()
	
	# Vertical: prefer above cursor, otherwise go below.
	var above_y := mouse_pos.y - size.y
	var below_y := mouse_pos.y
	var pos_y := above_y
	if pos_y < viewport_rect.position.y:
		pos_y = below_y
	
	# Horizontal: prefer right (or left if requested), flip if off-screen.
	var right_x := mouse_pos.x
	var left_x := mouse_pos.x - size.x
	var pos_x := right_x
	
	if pos_x + size.x > viewport_rect.end.x:
		pos_x = left_x
	
	# Final clamp (covers extremely large panels / edge cases).
	pos_x = clamp(pos_x, viewport_rect.position.x, viewport_rect.end.x - size.x)
	pos_y = clamp(pos_y, viewport_rect.position.y, viewport_rect.end.y - size.y)
	
	self.global_position = Vector2(pos_x, pos_y)
