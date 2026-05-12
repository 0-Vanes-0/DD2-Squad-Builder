@abstract
class_name HoverableTextureRect
extends TextureRect

signal hovered(is_hovered: bool)

const _HOVER_WAIT_TIME := 0.35 # sec
@export var is_hoverable := true

var _timer: Timer
var _tracking := false          # we started a hover attempt
var _hover_active := false      # hovered(true) already emitted
var _is_mouse_within := false

# Touch tracking (Android)
var _touch_down := false
var _touch_index := -1
var _saw_real_touch := false    # if we get ScreenTouch, prefer it over emulated mouse


func _ready() -> void:
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.wait_time = _HOVER_WAIT_TIME
	_timer.timeout.connect(_on_hover_timeout)
	self.add_child(_timer)


func _gui_input(event: InputEvent) -> void:
	if not is_hoverable or not self.is_visible_in_tree():
		_cancel_hover()
		return
	
	if Data.is_android:
		# Prefer real touch events (more deterministic than emulated mouse hover).
		if event is InputEventScreenTouch:
			_saw_real_touch = true
			_handle_screen_touch(event)
			return
		if event is InputEventScreenDrag:
			_handle_screen_drag(event)
			return


func _process(_delta: float) -> void:
	if _timer == null:
		return
	
	if not Data.is_android:
		if Rect2(Vector2(), self.size).has_point(get_local_mouse_position()):
			if not _is_mouse_within:
				_is_mouse_within = true
				_on_mouse_entered()
		else:
			if _is_mouse_within:
				_is_mouse_within = false
				_on_mouse_exited()


func _on_mouse_entered():
	if not is_hoverable:
		return
	_begin_hover_candidate()


func _on_mouse_exited():
	_cancel_hover()


func _begin_hover_candidate():
	if not _tracking:
		_tracking = true
		_timer.start()


func _on_hover_timeout():
	if not is_hoverable or not self.is_visible_in_tree():
		_cancel_hover()
		return
	
	if Data.is_android:
		# On touch: require finger down and still inside at timeout.
		if not _touch_down or not _is_point_inside(get_local_mouse_position()):
			_cancel_hover()
			return
	else:
		# Desktop: require cursor still inside.
		if not _is_point_inside(get_local_mouse_position()):
			_cancel_hover()
			return
	
	_hover_active = true
	hovered.emit(true)


func _cancel_hover() -> void:
	if not _tracking and not _hover_active:
		return
	_timer.stop()
	
	# Match your original behavior: emit false when a hover attempt ends.
	hovered.emit(false)
	
	_tracking = false
	_hover_active = false
	
	if Data.is_android:
		_touch_down = false
		_touch_index = -1
		_saw_real_touch = false


func _handle_screen_touch(e: InputEventScreenTouch) -> void:
	if e.pressed:
		_touch_down = true
		_touch_index = e.index
		if _is_point_inside(e.position):
			_begin_hover_candidate()
		else:
			_cancel_hover()
	else:
		# Release ends hover regardless of where release happens.
		if e.index == _touch_index:
			_cancel_hover()


func _handle_screen_drag(e: InputEventScreenDrag) -> void:
	if not _touch_down or e.index != _touch_index:
		return
	
	if _is_point_inside(e.position):
		if not _tracking and not _hover_active:
			_begin_hover_candidate()
	else:
		_cancel_hover()


func _handle_emulated_mouse_button(e: InputEventMouseButton) -> void:
	if e.button_index != MOUSE_BUTTON_LEFT:
		return
	_touch_down = e.pressed
	
	if _touch_down and _is_point_inside(e.position):
		_begin_hover_candidate()
	else:
		_cancel_hover()


func _handle_emulated_mouse_motion(e: InputEventMouseMotion) -> void:
	if not _touch_down:
		return
	
	if not _is_point_inside(e.position):
		_cancel_hover()


func _is_point_inside(viewport_pos: Vector2) -> bool:
	return Rect2(Vector2(), self.size).has_point(viewport_pos)


#@abstract
#class_name HoverableTextureRect
#extends TextureRect
#
#signal hovered(is_hovered: bool)
#
#const _HOVER_WAIT_TIME := 0.35 # sec
#var _timer := 0.0
#var _is_signal_sent := false
#var is_hoverable := true
#
#
#func _process(delta: float) -> void:
	#if _is_hovered() and is_hoverable:
		#_timer += delta
		#if _timer >= _HOVER_WAIT_TIME and not _is_signal_sent:
			#hovered.emit(true)
			#_is_signal_sent = true
	#elif _timer > 0:
		#_on_mouse_exited()
#
#
#func _is_hovered() -> bool:
	#return self.is_visible_in_tree() and _is_cursor_within()
#
#
#func _is_cursor_within() -> bool:
	#return Rect2(Vector2(), self.size).has_point(get_local_mouse_position())
#
#
#func _on_mouse_exited():
	#_timer = 0
	#hovered.emit(false)
	#_is_signal_sent = false
