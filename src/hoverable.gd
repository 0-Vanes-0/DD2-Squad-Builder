@abstract
class_name HoverableTextureRect
extends TextureRect

signal hovered(is_hovered: bool)

const _HOVER_WAIT_TIME := 0.35 # sec
var _timer := 0.0
var _is_signal_sent := false


func _process(delta: float) -> void:
	if _is_hovered() and not Data.is_dragging:
		_timer += delta
		if _timer >= _HOVER_WAIT_TIME and not _is_signal_sent:
			hovered.emit(true)
			_is_signal_sent = true
	elif _timer > 0:
		_on_mouse_exited()


func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_BEGIN:
		Data.is_dragging = true
	elif what == NOTIFICATION_DRAG_END:
		Data.is_dragging = false


func _is_hovered() -> bool:
	return self.is_visible_in_tree() and Rect2(Vector2(), self.size).has_point(get_local_mouse_position())


func _on_mouse_exited():
	_timer = 0
	hovered.emit(false)
	_is_signal_sent = false
