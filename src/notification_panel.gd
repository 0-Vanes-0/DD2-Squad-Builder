class_name NotificationPanel
extends PanelContainer

const DURATION_PER_CHARACTER := 0.1 # seconds
@export var _label: RichTextLabel


func _ready() -> void:
	assert(_label)
	self.hide()


func _process(_delta: float) -> void:
	if self.visible:
		_update_position()


func show_message(message: String, is_hover := false):
	_label.clear()
	_label.append_text(" " + message + " ")
	_show_panel(is_hover)


func show_hero_path(hero_path: HeroesPaths.Enum):
	_label.clear()
	_label.push_bold()
	_label.append_text(Data.all_paths_names.get_path_name(hero_path))
	_label.pop()
	_label.append_text("\n\n")
	Data.all_props.append_path_comment(_label, hero_path, true)
	_show_panel(true)


func show_skill(hero_path: HeroesPaths.Enum, skill_number: int):
	_label.clear()
	await Data.all_skills_comments.assign_comments(_label, hero_path, skill_number)
	_show_panel(true)


func _show_panel(is_hover := false):
	self.show()
	
	self.reset_size.call_deferred()
	
	if not is_hover: # is click
		await get_tree().create_timer(DURATION_PER_CHARACTER * _label.get_parsed_text().length()).timeout
		self.hide()


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
	var right_x := mouse_pos.x + 20
	var left_x := mouse_pos.x - size.x
	var pos_x := right_x
	
	if pos_x + size.x > viewport_rect.end.x:
		pos_x = left_x
	
	# Final clamp (covers extremely large panels / edge cases).
	pos_x = clamp(pos_x, viewport_rect.position.x, viewport_rect.end.x - size.x)
	pos_y = clamp(pos_y, viewport_rect.position.y, viewport_rect.end.y - size.y)
	
	self.global_position = Vector2(pos_x, pos_y)
