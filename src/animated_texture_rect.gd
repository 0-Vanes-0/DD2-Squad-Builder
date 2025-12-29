@tool
class_name AnimatedTextureRect
extends TextureRect

@export var sprite_frames: SpriteFrames
@export var animation: StringName = &"default"
@export var autoplay: bool = true
@export var speed_scale: float = 1.0
@export var playing := false

var _frame_index := 0
var _time_left := 0.0


func _ready() -> void:
	if autoplay:
		play()
	else:
		stop()


func play() -> void:
	playing = true
	set_process(true)
	_reset_to_first_frame()


func stop() -> void:
	playing = false
	set_process(false)


func _process(delta: float) -> void:
	if not playing or sprite_frames == null:
		return
	if not sprite_frames.has_animation(animation):
		return

	_time_left -= delta
	while _time_left <= 0.0:
		_advance_frame()


func _reset_to_first_frame() -> void:
	_frame_index = 0
	_apply_frame()


func _advance_frame() -> void:
	var count := sprite_frames.get_frame_count(animation)
	if count <= 0:
		return

	_frame_index += 1
	if _frame_index >= count:
		if sprite_frames.get_animation_loop(animation):
			_frame_index = 0
		else:
			_frame_index = count - 1
			stop()

	_apply_frame()


func _apply_frame() -> void:
	var fps := sprite_frames.get_animation_speed(animation) * absf(speed_scale)
	if fps <= 0.0:
		return

	var count := sprite_frames.get_frame_count(animation)
	if count <= 0:
		return

	_frame_index = clampi(_frame_index, 0, count - 1)
	texture = sprite_frames.get_frame_texture(animation, _frame_index)

	# Per-frame duration support:
	var rel := sprite_frames.get_frame_duration(animation, _frame_index) # defaults to 1.0
	_time_left = rel / fps
